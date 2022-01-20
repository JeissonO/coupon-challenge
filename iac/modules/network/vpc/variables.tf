variable "cidr_block" {
  description = "CIDR block to VPC"
}
variable "environment" {
  description = "environment were the resources going to be created"
}
variable "organization" {
  description = "Entity or organization owner of the resource"
}
variable "project" {
  description = "Name of the project owner of the resource"
}
variable "public_subnet_cidrs" {
  type        = list(string)
  description = "CIDRS blocks for public subnets"
}
variable "private_subnet_cidrs" {
  type        = list(string)
  description = "CIDRS blocks for private subnets"
}
variable "vpc_azs" {
  type        = list(string)
  description = "availability zones of the region"
}
locals {
  common_tags = (tomap({
    Environment  = var.environment
    Organization = var.organization
    Project      = var.project
  }))
}
