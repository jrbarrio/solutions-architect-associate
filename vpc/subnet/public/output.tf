output "id" {
  value = module.public_subnet.id
}

output "web_dmz_sg_id" {
  value = module.web_dmz_sg.id
}

output "nat_gateway_id" {
  value = aws_nat_gateway.gw.id
}