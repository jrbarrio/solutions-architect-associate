variable "vpc_id" {
  type = string
}

variable "nat_gateway_ids" {
  type = list(string)
}

variable "tags" {
  type = "map"
}