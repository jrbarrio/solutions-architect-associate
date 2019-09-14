output "ids" {
  value = aws_subnet.private_subnets[*].id
}

output "db_sg_id" {
  value = module.db_sg.id
}