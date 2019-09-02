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

resource "aws_instance" "web_server" {
  ami = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"

  subnet_id = var.subnet_id
  vpc_security_group_ids = [
    var.vpc_security_group_id]

  key_name = var.key_name

  tags = var.tags
}