variable "environment" {
  description = "environment were the resources going to be created"
}
variable "organization" {
  description = "Entity or organization owner of the resource"
}
variable "project" {
  description = "Name of the project owner of the resource"
}
variable "resource" {
  description = "name of the resources or group o resources"
}
variable "vpc_id" {
  description = "vpc id where the resource will be created"
}
variable "public_subnet_ids" {
  type        = list(string)
  description = "list of public subnets id's"
}
variable "private_subnet_ids" {
  type        = list(string)
  description = "list of private subnets id's"
}
variable "private_subnet_cidrs" {
  type        = list(string)
  description = "private subnets CIDRS blocks"
}
variable "route_table_id" {
  description = "private route table id (privada)"
}
variable "image_id" {
  description = "AMI for NAT instance"
  type        = string
  default     = ""
}
variable "enabled" {
  description = "use low cost resources"
  type        = bool
  default     = true
}
variable "use_spot_instance" {
  description = "use spot or on-demand EC2 instance"
  type        = bool
  default     = true
}
variable "instance_types" {
  description = "Instence types for NAT Instance. This is used in the mixed instances policy"
  type        = list(any)
  default     = ["t2.micro", "t3a.nano"]
}
variable "key_name" {
  description = "key pair for NAT instance. you can put a variable to use a key pair"
  type        = string
  default     = ""
}
variable "user_data_write_files" {
  description = "write_files additional for cloud-init"
  type        = list(any)
  default     = []
}
variable "user_data_runcmd" {
  description = "runcmd additional for cloud-init"
  type        = list(any)
  default     = []
}
locals {
  common_tags = (tomap({
    Environment  = var.environment
    Organization = var.organization
    Project      = var.project
    Resource     = var.resource
  }))
}
