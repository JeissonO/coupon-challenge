output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "Identificador de la VPC"
}
output "private_route_table_id" {
  value       = module.vpc.private_route_table_id
  description = "Identificador de la Route Table Privada"
}
output "private_subnet_ids" {
  value       = module.vpc.private_subnet_ids
  description = "Lista de identificadores de las subnets privadas"
}
output "public_subnet_ids" {
  value       = module.vpc.public_subnet_ids
  description = "Lista de identificadores de las subnets publicas"
}
