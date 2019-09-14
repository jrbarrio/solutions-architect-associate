terraform {
  backend "s3" {
    bucket = "jrb.terraform.state"
    key = "solutions-architect-associate-vpc/terraform.tfstate"
    region = "eu-west-1"

    dynamodb_table = "jrb-terraform-state-locks"
    encrypt = true
  }
}

provider "aws" {
  region = var.region
}

module "vpc" {
  source = "../../modules/vpc/vpc"

  region = var.region
  key_name = var.public_key_name

  tags = var.tags
}

module "web_server" {
  source = "../../modules/ec2/web_server"

  vpc_id = module.vpc.id
  subnet_ids = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids
  vpc_security_group_id = module.vpc.web_dmz_sg_id
  key_name = var.public_key_name
  tags = var.tags
}