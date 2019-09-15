module "bastion_sg" {
  source = "../../vpc/security_group/bastion"

  vpc_id = var.vpc_id
  tags = var.tags
}

resource "aws_instance" "bastion" {
  count = length(var.public_subnet_ids)

  ami = "ami-0bbc25e23a7640b9b"
  instance_type = "t2.micro"

  subnet_id = var.public_subnet_ids[count.index]
  vpc_security_group_ids = [module.bastion_sg.id]

  key_name = var.key_name

  tags = merge(var.tags, {Name = "bastion host"})
}