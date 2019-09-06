data "template_file" "user_data" {
  template = file("${path.module}/user_data.sh")
}

resource "aws_launch_configuration" "web_server" {
  image_id = "ami-0bbc25e23a7640b9b"
  instance_type = "t2.micro"

  security_groups = [
    var.vpc_security_group_id]

  user_data = data.template_file.user_data.rendered

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "web_server" {
  launch_configuration = aws_launch_configuration.web_server.id
  vpc_zone_identifier = [var.subnet_id]

  load_balancers = [aws_elb.load_balancer.name]
  health_check_type = "ELB"

  max_size = 10
  min_size = 2
}

resource "aws_elb" "load_balancer" {
  name = "web-server-load-balancer"
  subnets = [var.subnet_id]
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