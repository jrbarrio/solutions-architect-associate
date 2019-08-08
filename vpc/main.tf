terraform {
  backend "s3" {
    region = "eu-west-1"
    bucket = "jorgeroldanbarrio.terraform.state"
    key = "solutions-architect-associate-vpc/terraform.tfstate"
  }
}

provider "aws" {
  region = var.region
  profile = var.profile
}

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Project = "solutions-architect-associate-vpc"
  }
}