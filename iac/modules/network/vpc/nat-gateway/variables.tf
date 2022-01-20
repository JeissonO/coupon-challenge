variable "environment" {
  description = "Environment were the resources going to be created"
}
variable "organization" {
  description = "Entity or organization owner of the resource"
}
variable "project" {
  description = "Name of the project owner of the resource"
}
variable "public_subnet_ids" {
  type        = list(string)
  description = "list of public subnets id's"
}
variable "route_table_id" {
  description = "private route table id (privada)"
}
locals {
  common_tags = (tomap({
    Environment  = var.environment
    Organization = var.organization
    Project      = var.project
  }))
}
