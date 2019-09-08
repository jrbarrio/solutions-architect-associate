data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "public_subnets" {
  count = length(data.aws_availability_zones.available.names)

  vpc_id = var.vpc_id
  cidr_block = "10.0.1${count.index}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = var.tags
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
  count = length(aws_subnet.public_subnets)

  subnet_id = aws_subnet.public_subnets[count.index].id
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
  subnet_ids = aws_subnet.public_subnets.*.id
  tags = merge(var.tags, {Name = "web_acl"})
}

resource "aws_eip" "nat_gateway_eips" {
  count = length(aws_subnet.public_subnets)

  vpc = true
}

resource "aws_nat_gateway" "gws" {
  count = length(aws_subnet.public_subnets)

  allocation_id = aws_eip.nat_gateway_eips[count.index].id
  subnet_id = aws_subnet.public_subnets[count.index].id
}

module "bastion_sg" {
  source = "../../security_group/bastion"

  vpc_id = var.vpc_id
  tags = var.tags
}

resource "aws_instance" "bastion" {
  count = length(aws_subnet.public_subnets)

  ami = "ami-0bbc25e23a7640b9b"
  instance_type = "t2.micro"
  associate_public_ip_address = true

  subnet_id = aws_subnet.public_subnets[count.index].id
  vpc_security_group_ids = [module.bastion_sg.id]

  key_name = var.key_name

  tags = merge(var.tags, {Name = "bastion host"})
}