module "private_subnet" {
  source = "../subnet"

  vpc_id = var.vpc_id
  cidr_block = "10.0.2.0/24"
  availability_zone = "eu-west-1b"

  tags = merge(var.tags, {Name = "private subnet"})
}

module "db_sg" {
  source = "../../security_group/db"

  vpc_id = var.vpc_id
  tags = var.tags
}

resource "aws_route" "r" {
  route_table_id = var.default_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = var.nat_gateway_id
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id = var.vpc_id
  service_name = "com.amazonaws.eu-west-1.s3"
  route_table_ids = [var.default_route_table_id]
}