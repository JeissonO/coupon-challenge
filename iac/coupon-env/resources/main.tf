/**
  @Autor: jeisson.osoriob@gmail.com
  @Date: Agosto 2021
  @Organization: Coupon-Challenge
  @Description: Template para la creacion de recursos de infraestructura  
  INFO: Validar uso de workspace para la implementacion de la presente plantilla
**/

module "parameters" {
  source = "../../parameters"
}
// -- INICIO Definicion de RepositoriosECR 
module "ecr_coupon" {
  source          = "../../modules/application/ecr"
  repository_name = "coupon"
  environment     = module.parameters.environment
  organization    = module.parameters.organization
  project         = module.parameters.project
}
// -- FIN Definicion de RepositoriosECR 

// -- INICIO Definicion ECS (Cluster ECS y Security Group del cluster)
module "sg_ecs" {
  source       = "../../modules/network/security_groups"
  environment  = module.parameters.environment
  organization = module.parameters.organization
  project      = module.parameters.project
  resource     = "ecs"
  vpc_id       = data.terraform_remote_state.networking.outputs.vpc_id
}
module "ecs" {
  source       = "../../modules/application/ecs"
  environment  = module.parameters.environment
  organization = module.parameters.organization
  project      = module.parameters.project
}
// -- FIN Definicion ECS (Cluster ECS y Security Group del cluster)

// -- INICIO DNS Namespace para el service discovery (Route 53)
module "dns_namespace" {
  source       = "../../modules/network/route_53"
  environment  = module.parameters.environment
  organization = module.parameters.organization
  project      = module.parameters.project
  vpc_id       = data.terraform_remote_state.networking.outputs.vpc_id
}
// -- FIN DNS Namespace para el service discovery (Route 53)

// -- INICIO Definicion balanceador NLB interno
module "internal_nlb" {
  source             = "../../modules/application/nlb"
  environment        = module.parameters.environment
  organization       = module.parameters.organization
  project            = module.parameters.project
  load_balancer_type = "network"
  list_subnet_id     = data.terraform_remote_state.networking.outputs.private_subnet_ids
  internal_alb       = true
  resource           = "internal"
}
// -- FIN Definicion balanceador NLB interno

// -- INICIO definicion de UserPool de Cognito
module "cognito_user_pool" {
  source       = "../../modules/application/cognito"
  environment  = module.parameters.environment
  organization = module.parameters.organization
  project      = module.parameters.project
  resource     = "cognito_ad_pool"
}
/* -- FIN definicion de UserPool de Cognito*/
