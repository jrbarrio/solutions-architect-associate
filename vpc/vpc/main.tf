resource "aws_key_pair" "deployer" {
  key_name = "deployer-key"
  public_key = var.public_key
}

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

module "web_server" {
  source = "../ec2/instance/web_server"

  subnet_id = module.public_subnet.id
  vpc_security_group_id = module.public_subnet.web_dmz_sg_id
  key_name = aws_key_pair.deployer.key_name
  tags = var.tags
}

// Private subnet resources

module "private_subnet" {
  source = "../subnet/private"

  vpc_id = aws_vpc.vpc.id
  nat_gateway_id = module.public_subnet.nat_gateway_id
  default_route_table_id = aws_vpc.vpc.default_route_table_id
  tags =  var.tags
}

// Private subnet instances

module "db" {
  source = "../ec2/instance/db"

  subnet_id = module.private_subnet.id
  vpc_security_group_id = module.private_subnet.db_sg_id
  key_name = aws_key_pair.deployer.key_name
  tags = var.tags
}