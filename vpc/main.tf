terraform {
  backend "s3" {
    region = "eu-west-1"
    bucket = "jorgeroldanbarrio.terraform.state"
    key = "solutions-architect-associate-vpc/terraform.tfstate"
  }
}

provider "aws" {
  region = var.region
  profile = var.profile
}

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Project = "solutions-architect-associate-vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "eu-west-1a"
  map_public_ip_on_launch = true

  tags = {
    Project = "solutions-architect-associate-vpc"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "eu-west-1b"

  tags = {
    Project = "solutions-architect-associate-vpc"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Project = "solutions-architect-associate-vpc"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Project = "solutions-architect-associate-vpc"
  }
}

resource "aws_route_table_association" "public_subnet_association" {
  subnet_id = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_security_group" "web_dmz" {
  name        = "web_dmz"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Project = "solutions-architect-associate-vpc"
  }
}

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

resource "aws_key_pair" "deployer" {
  key_name = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC+gSeWRykbPXrHp2GsTFtNsX5FdSKl6pyQ8WqbaBhHgshndMS9KKwP0SsYLJX4o9KagyhxQx9pdkFZYAgGfmGwrEv1U4sThGU0WD609XjASkT+uQ1Kft5EANDcppOQAiDIWttxVSX1BqOmp9vOM0QPmdgrXa32m2CC0HqSMBGO6TbaW7yF8o9+wJHOE4klnbLT3/UOajaTpvQoLpEiaYbHbuCIBX8McsfzgJLsSjKHmKoxRN8wHjLMT528iUbh67J97HrIlGJRTOWCk+FehroGRZo8y+749GaXfYnS/ZC2X58zj6EZ0qQsSkmHUVRcnZzp0/OSee50jviAWxlOr8Rg/xz0Ymbx+QyifYoIRnZwLkYoQNUKE3Gippfu+Z7QYp5CvufzcQLitT/ZGY+eyF1k0HD5L+6oF0nUvDeCSKNATZS1WaIXL008u4aiGXiWQG9F8CdAw9ZyNQi/LT88Qbhy3UoNNJrNxYQ1jrMq/vqjOpMFPbVqJfvCHDX8lXXrOHmQqlb3dxkgdoOxXgivP45aD21Bs1GIjgyKJEZ7b2iPaKZsNQfpTqnqsHnSxzW6PFc3IVWYJwU4pOQttlb16wUsM8ArURYCwC9zcN8mVoJWIbCucyYcJYxqocC1lfoRoYuPMAnDPskfKs1HiGAq+JlmsnWw6aDxfsYW6MmAx8AB1Q== jorge.roldan@gmail.com"
}

resource "aws_instance" "web_server" {
  ami = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"

  subnet_id = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.web_dmz.id]

  key_name = aws_key_pair.deployer.key_name

  tags = {
    Project = "solutions-architect-associate-vpc"
  }
}

resource "aws_instance" "private_instance" {
  ami = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"

  subnet_id = aws_subnet.private_subnet.id

  key_name = aws_key_pair.deployer.key_name

  tags = {
    Project = "solutions-architect-associate-vpc"
  }
}