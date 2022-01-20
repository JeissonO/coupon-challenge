variable "environment" {
  description = "Ambiente en el cual se crea el recurso"
}
variable "organization" {
  description = "Entidad a la que pertenece el recurso"
}
variable "project" {
  description = "Proyecto para el cual se crea el recurso"
}
variable "ecs_task_family" {
  description = "Nombre que se le asignara al servicio"
}
variable "microservice_name" {
  description = "Nombre del microservicio a desplegar"
}
variable "microservice_memory_reservation" {
  description = "Memoria que se debe reservar para el microservicio"
}
variable "microservice_memory" {
  description = "Memoria asignada al microservicio"
}
variable "microservice_cpu" {
  description = "Asignacion de CPU del microservicio"
}
variable "ecs_execution_role_arn" {
  description = "ARN del rol con el que se ejecuta el microservicio"
}
variable "microservice_loggroup" {
  description = "Nombre del log group del microservicio"
}
variable "container_definitions" {
  description = "task definition file"
  default     = <<EOF
              [
                  {
                    "name": "redis",
                    "image": "redis",
                    "memoryReservation": 256,
                    "portMappings" : [
                        {
                            "containerPort": 6379,
                            "protocol": "udp",
                            "HostPort": 6379
                        }
                    ]
                  }
              ]
              EOF
}
