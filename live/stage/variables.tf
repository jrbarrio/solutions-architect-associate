variable "region" {
  type    = string
  default = "eu-west-1"
}

variable "public_key_name" {
  type    = string
  default = "deployer-key"
}

variable "tags" {
  type = "map"
  default = {
    Project = "solutions-architect-associate-vpc"
  }
}