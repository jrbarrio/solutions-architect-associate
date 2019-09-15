variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "tags" {
  type = "map"
}

variable "web_server_security_group_id" {
  type = string
}