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
// INICIO - Definicion de APIs
module "vpc_link" {
  source       = "../../modules/application/apigateway/vpc-link"
  environment  = module.parameters.environment
  organization = module.parameters.organization
  project      = module.parameters.project
  resource     = "private"
  target_arns  = data.terraform_remote_state.resources.outputs.int_nlb_arn
}
module "api_proxy_coupon" {
  source                  = "../../modules/application/apigateway/api-proxy"
  environment             = module.parameters.environment
  organization            = module.parameters.organization
  project                 = module.parameters.project
  resource                = "coupon"
  endpoint_type           = ["REGIONAL"]
  path_part               = "couponManagement"
  nlb_dns_name            = data.terraform_remote_state.resources.outputs.int_nlb_dns_name
  app_port                = "10100"
  integration_http_method = "ANY"
  integration_input_type  = "HTTP_PROXY"
  api_gateway_vpc_link_id = module.vpc_link.id
  provider_arns           = [data.terraform_remote_state.resources.outputs.cognito_user_pool_arn]
  authorization_scopes    = ["coupon/v1"]
}
// FIN - Definicion de APIs
variable "api_poc_endpoint" {
  description = "Ingrese el valor de la variable API_ENDPOINT, la cual debe contener la api de integracion requerida por la solución"
}
// INICIO - ECS Service Definition
module "ecs_coupon_service" {
  source             = "../../modules/application/ecs/service"
  environment        = module.parameters.environment
  organization       = module.parameters.organization
  project            = module.parameters.project
  service_name       = "coupon"
  service_port       = 8080
  load_balancer_port = 10100
  ecr_repository_url = data.terraform_remote_state.resources.outputs.ecr_coupon
  load_balancer_arn  = data.terraform_remote_state.resources.outputs.int_nlb_arn
  vpc_id             = data.terraform_remote_state.networking.outputs.vpc_id
  dns_namespace_id   = data.terraform_remote_state.resources.outputs.dns_namespace_id
  ecs_cluster        = data.terraform_remote_state.resources.outputs.ecs_cluster_id
  ecs_cluster_name   = data.terraform_remote_state.resources.outputs.ecs_cluster_name
  sg_id              = [data.terraform_remote_state.resources.outputs.sg_ecs_id]
  private_subnet_id  = data.terraform_remote_state.networking.outputs.private_subnet_ids
  api_poc_endpoint   = var.api_poc_endpoint
}
// FIN - ECS Service Definition