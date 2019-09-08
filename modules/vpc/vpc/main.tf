resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"

  tags = merge(var.tags, {Name = "main vpc"})
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = var.tags
}

module "public_subnet" {
  source = "../subnet/public"

  vpc_id = aws_vpc.vpc.id
  internet_gateway_id = aws_internet_gateway.internet_gateway.id
  key_name = var.key_name

  tags = merge(var.tags, {Name = "public subnet"})
}

module "private_subnet" {
  source = "../subnet/private"

  vpc_id = aws_vpc.vpc.id
  nat_gateway_ids = module.public_subnet.nat_gateway_ids

  tags = merge(var.tags, {Name = "private subnet"})
}