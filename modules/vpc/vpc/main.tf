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
  tags = merge(var.tags, {Name = "public subnet"})
}

//module "private_subnet" {
//  source = "../subnet/private"
//
//  vpc_id = aws_vpc.vpc.id
//  nat_gateway_id = module.public_subnet.nat_gateway_id
//  default_route_table_id = aws_vpc.vpc.default_route_table_id
//  tags =  var.tags
//}