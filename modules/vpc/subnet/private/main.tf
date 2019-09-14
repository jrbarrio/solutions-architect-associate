data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "private_subnets" {
  count = length(data.aws_availability_zones.available.names)

  vpc_id = var.vpc_id
  cidr_block = "10.0.2${count.index}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = var.tags
}

module "db_sg" {
  source = "../../security_group/db"

  vpc_id = var.vpc_id
  tags = var.tags
}

resource "aws_route_table" "private_route_table" {
  count = length(aws_subnet.private_subnets)

  vpc_id = var.vpc_id
  tags = var.tags
}

resource "aws_route_table_association" "public_subnet_association" {
  count = length(aws_subnet.private_subnets)

  subnet_id = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_route_table[count.index].id
}

resource "aws_route" "r" {
  count = length(aws_subnet.private_subnets)

  route_table_id = aws_route_table.private_route_table[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = var.nat_gateway_ids[count.index]
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id = var.vpc_id
  service_name = "com.amazonaws.eu-west-1.s3"
  route_table_ids = aws_route_table.private_route_table[*].id
}