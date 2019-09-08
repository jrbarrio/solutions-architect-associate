variable "subnet_ids" {
  type = list(string)
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "vpc_security_group_id" {
  type = string
}

variable "key_name" {
  type = string
}

variable "tags" {
  type = "map"
}