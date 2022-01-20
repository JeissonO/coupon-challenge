variable "environment" {
  description = "Ambiente en el cual se crea el recurso"
}
variable "organization" {
  description = "Entidad a la que pertenece el recurso"
}
variable "project" {
  description = "Proyecto para el cual se crea el recurso"
}
variable "load_balancer_type" {
  description = "Tipo de balanceador"
}
variable "list_subnet_id" {
  type        = list(string)
  description = "Lista de id de las subnets asociadas"
}
variable "internal_alb" {
  description = "Tag para indicar si el balanceador es interno o externo"
}
variable "resource" {
  description = "Recurso al cual se le asignan los permisos"
}
