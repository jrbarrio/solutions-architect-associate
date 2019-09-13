output "id" {
  value = aws_vpc.vpc.id
}

output "public_subnet_ids" {
  value = module.public_subnet.ids
}

output "web_dmz_sg_id" {
  value = module.public_subnet.web_dmz_sg_id
}

output "private_subnet_ids" {
  value = module.private_subnet.ids
}

//output "db_sg_id" {
//  value = module.private_subnet.db_sg_id
//}