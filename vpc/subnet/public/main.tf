module "public_subnet" {
  source = "../subnet"

  vpc_id = var.vpc_id
  cidr_block = "10.0.1.0/24"
  availability_zone = "eu-west-1a"
  map_public_ip_on_launch = true

  tags = merge(var.tags, {Name = "public subnet"})
}

resource "aws_route_table" "public_route_table" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.internet_gateway_id
  }

  tags = var.tags
}

resource "aws_route_table_association" "public_subnet_association" {
  subnet_id = module.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

module "web_dmz_sg" {
  source = "../../security_group/web_dmz"

  vpc_id = var.vpc_id
  tags = var.tags
}

module "web_acl" {
  source = "../../acl/web_acl"

  vpc_id = var.vpc_id
  subnet_id = module.public_subnet.id
  tags = merge(var.tags, {Name = "web_acl"})
}

resource "aws_eip" "nat_gateway_eip" {
  vpc = true
}

resource "aws_nat_gateway" "gw" {
  allocation_id = aws_eip.nat_gateway_eip.id
  subnet_id = module.public_subnet.id
}