output "int_nlb_arn" {
  value       = module.internal_nlb.alb_arn
  description = "ARN del balanceador NLB interno"
}
output "int_nlb_dns_name" {
  value       = module.internal_nlb.dns_name
  description = "DNS del balanceador NLB interno"
}
output "cognito_user_pool_id" {
  value       = module.cognito_user_pool.id
  description = "ID del user pool creado"
}
output "cognito_user_pool_arn" {
  value       = module.cognito_user_pool.arn
  description = "arn de cognito user pool"
}
output "cognito_user_pool_endpoint" {
  value       = module.cognito_user_pool.endpoint
  description = "Cognito endpoint"
}
output "sg_ecs_id" {
  value       = module.sg_ecs.sg_id
  description = "Identificador del security group asociado al cluster de ECS"
}
output "ecs_cluster_id" {
  value       = module.ecs.ecs_cluster_id
  description = "Identificador del cluster de ECS generado"
}
output "ecs_cluster_name" {
  value       = module.ecs.ecs_cluster_name
  description = "nombre del cluster de ECS generado"
}
output "dns_namespace_id" {
  value       = module.dns_namespace.dns_namespace_id
  description = "DNS privado generado para uso de Service Discovery con Route53"
}
output "ecr_coupon" {
  value       = module.ecr_coupon.repository_url
  description = "url del repositorio del servicio creado"
}
