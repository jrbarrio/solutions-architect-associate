variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "key_name" {
  type = string
}

variable "tags" {
  type = "map"
}