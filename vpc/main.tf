terraform {
  backend "s3" {
    region = "eu-west-1"
    bucket = "jrb.2019.terraform.state"
    key = "solutions-architect-associate-vpc/terraform.tfstate"
  }
}

provider "aws" {
  region = var.region
}

module "vpc" {
  source = "./vpc"

  region = var.region
  public_key = var.public_key

  tags = {
    Project = "solutions-architect-associate-vpc"
  }
}