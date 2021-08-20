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
  description = "Recurso asociado"
}
variable "target_arns" {
  description = "arn del balanceador asociado al vpc link"
}