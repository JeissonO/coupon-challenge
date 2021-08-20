variable "environment" {
  description = "Ambiente en el cual se crea el recurso"
}
variable "organization" {
  description = "Entidad a la que pertenece el recurso"
}
variable "project" {
  description = "Proyecto para el cual se crea el recurso"
}
variable "ecs_low_threshold_per" {
  type        = string
  description = "Limite inferior de CPU"
}
variable "ecs_high_threshold_per" {
  type        = string
  description = "Limite Superior de CPU"
}
variable "ecs_cluster" {
  description = "Nombre del cluster ECS"
}
variable "ecs_service_microservice" {
  description = "Nombre del servicio en ECS"
}
variable "ecs_autoscale_max_instances" {
  description = "Numero maximo de instancias para autoescalar"
}
variable "ecs_autoscale_min_instances" {
  description = "Numero minimo de instancias para decrecer"
}
variable "aws_iam_role_ecs_execution_role" {
  description = "arn rol de perfil exs"
}
variable "vm_depends_on" {
  type    = any
  default = null
}
variable "metric_name" {
  description = "metrica utilizada para el escalamiento (CPUUtilization, MemoryUtilization)"
  default     = "CPUUtilization"
}
