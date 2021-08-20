variable "environment" {
  description = "Ambiente en el cual se crea el recurso"
}
variable "organization" {
  description = "Entidad a la que pertenece el recurso"
}
variable "project" {
  description = "Proyecto para el cual se crea el recurso"
}
variable "resource" {
  description = "Recurso al cual se le asignan los permisos"
}
variable "vpc_id" {
  description = "VPC sobre la cual se crea el Security Group"
}
