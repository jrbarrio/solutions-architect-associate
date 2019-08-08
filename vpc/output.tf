output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "vpc_default_network_acl_id" {
  value = aws_vpc.vpc.default_network_acl_id
}

output "vpc_default_security_group_id" {
  value = aws_vpc.vpc.default_security_group_id
}

output "vpc_default_route_table_id" {
  value = aws_vpc.vpc.default_route_table_id
}

output "vpc_main_route_table_id" {
  value = aws_vpc.vpc.main_route_table_id
}

output "vpc_dhcp_options_id" {
  value = aws_vpc.vpc.dhcp_options_id
}