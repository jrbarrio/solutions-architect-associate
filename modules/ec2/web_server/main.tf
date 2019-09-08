data "template_file" "user_data" {
  template = file("${path.module}/user_data.sh")
}

data "aws_iam_policy" "AmazonS3FullAccess" {
  arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role" "s3_access" {
  name = "s3_access"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "s3_access_attach" {
  role = aws_iam_role.s3_access.name
  policy_arn = data.aws_iam_policy.AmazonS3FullAccess.arn
}

resource "aws_iam_instance_profile" "s3_access_profile" {
  name = "s3_access"
  role = aws_iam_role.s3_access.name
}

resource "aws_launch_configuration" "web_server" {
  image_id = "ami-0bbc25e23a7640b9b"
  instance_type = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.s3_access_profile.name

  security_groups = [
    var.vpc_security_group_id]

  key_name = var.key_name

  user_data = data.template_file.user_data.rendered

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "web_server" {
  launch_configuration = aws_launch_configuration.web_server.id
  vpc_zone_identifier = var.private_subnet_ids

  load_balancers = [aws_elb.load_balancer.name]
  health_check_type = "ELB"

  max_size = 10
  min_size = 2
}

resource "aws_elb" "load_balancer" {
  name = "web-server-load-balancer"
  subnets = var.subnet_ids
  security_groups = [var.vpc_security_group_id]

  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = 80
    instance_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    target = "HTTP:80/"
  }
}