terraform {
  backend "s3" {
    region = "eu-west-1"
    bucket = "jrb.terraform.state"
    key = "solutions-architect-associate-vpc/terraform.tfstate"
  }
}

provider "aws" {
  region = var.region
}

//resource "aws_key_pair" "deployer" {
//  key_name = "deployer-key"
//  public_key = var.public_key
//}

module "vpc" {
  source = "../modules/vpc/vpc"

  region = var.region
  public_key = var.public_key

  tags = var.tags
}

//module "web_server" {
//  source = "../modules/ec2/web_server"
//
//  subnet_id = module.vpc.public_subnet_id
//  vpc_security_group_id = module.vpc.web_dmz_sg_id
//  key_name = aws_key_pair.deployer.key_name
//  tags = var.tags
//}
//
//module "db" {
//  source = "../modules/ec2/instance/db"
//
//  subnet_id = module.vpc.private_subnet_id
//  vpc_security_group_id = module.vpc.db_sg_id
//  key_name = aws_key_pair.deployer.key_name
//  tags = var.tags
//}