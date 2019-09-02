data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name = "name"
    values = [
      "amzn2-ami-hvm-2.0.????????-x86_64-gp2"]
  }

  filter {
    name = "virtualization-type"
    values = [
      "hvm"]
  }

  owners = [
    "137112412989"]
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

resource "aws_instance" "db" {
  ami = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.s3_access_profile.name

  subnet_id = var.subnet_id
  vpc_security_group_ids = [
    var.vpc_security_group_id]

  key_name = var.key_name

  tags = var.tags
}