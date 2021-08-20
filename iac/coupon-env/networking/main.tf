/**
  @Autor: jeisson.osoriob@gmail.com
  @Date: Agosto 2021
  @Organization: Coupon-Challenge
  @Description: Template para la creacion de recursos de red  
  INFO: Validar uso de workspace para la implementacion de la presente plantilla
**/
module "parameters" {
  source = "../../parameters"
}
module "vpc" {
  source               = "../../modules/network/vpc"
  cidr_block           = module.parameters.vpc_cidr_block
  environment          = module.parameters.environment
  organization         = module.parameters.organization
  project              = module.parameters.project
  vpc_azs              = module.parameters.region_az
  public_subnet_cidrs  = module.parameters.public_subnet_cidrs
  private_subnet_cidrs = module.parameters.private_subnet_cidrs
}
module "nat_gateway" {
  source            = "../../modules/network/vpc/nat-gateway"
  environment       = module.parameters.environment
  organization      = module.parameters.organization
  project           = module.parameters.project
  public_subnet_ids = module.vpc.public_subnet_ids
  route_table_id    = module.vpc.private_route_table_id
}