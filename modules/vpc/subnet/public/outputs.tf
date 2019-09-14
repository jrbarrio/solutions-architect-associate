output "ids" {
  value = aws_subnet.public_subnets[*].id
}

output "web_dmz_sg_id" {
  value = module.web_dmz_sg.id
}

output "nat_gateway_ids" {
  value = aws_nat_gateway.gws[*].id
}