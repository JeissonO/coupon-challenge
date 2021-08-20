variable "environment" {
  description = "Ambiente en el cual se crea el recurso"
}
variable "organization" {
  description = "Entidad a la que pertenece el recurso"
}
variable "project" {
  description = "Proyecto para el cual se crea el recurso"
}
// -- START LOG Group
variable "retention_in_days_logs" {
  description = "tiempo que se retendran los logs en cloudwatch"
  type        = number
  default     = 5
}
variable "store_in_s3" {
  description = "se debe alamacenar en S3"
  type        = bool
  default     = true
}
// -- END LOG Group
// -- START TASK Definition
variable "service_name" {
  description = "nombre del servicio a desplegar"
}
variable "microservice_memory_reservation" {
  description = "memoria reservada por el microservicio default 256"
  default     = 256
}
variable "microservice_memory" {
  description = "memoria asignada al microservicio default 512"
  default     = 512
}
variable "microservice_cpu" {
  description = "CPU Asignada al microservicio default 256"
  default     = 256
}
variable "network_mode" {
  description = "Tipo de red que debe manejar la task"
  type        = string
  default     = "awsvpc"

}
variable "xray_repository" {
  description = "Repositorio desde el cual se descargara la imagen de Xray"
  default     = "amazon/aws-xray-daemon"
}
variable "ecr_repository_url" {
  description = "URL del repositorio ECR en el que se encuetra la imagen del microservicio a desplegar"
}
variable "service_port" {
  description = "Puerto del contenedor del servicio"
}
variable "load_balancer_protocol" {
  description = "Protocolo que se esa en el balanceador"
  type        = string
  default     = "tcp"
}
// -- END TASK Definition
// -- START Target Group for NLB
variable "target_type" {
  description = "target type del load balance"
  type        = string
  default     = "ip"
}
variable "vpc_id" {
  description = "id de la VPC donde esta al balanceador"
  type        = string
}
variable "load_balancer_port" {
  description = "id de la VPC donde esta al balanceador"
  type        = number
}
variable "load_balancer_arn" {
  description = "arn del balanceador de red donde se expondra el servicio"
  type        = string
}
variable "healthcheck_protocol" {
  description = "protocolo de healthcheck de balanceador"
  type        = string
  default     = "TCP"
}
variable "healthcheck_path" {
  description = "path en el cual se expone el servicio de health check"
  type        = string
  default     = "/health"
}
variable "healthcheck_interval" {
  description = "The approximate amount of time, in seconds, between health checks of an individual target. Minimum value 5 seconds, Maximum value 300 seconds. For lambda target groups, it needs to be greater as the timeout of the underlying lambda. Default 30 seconds"
  type        = number
  default     = 30
}
variable "healthcheck_port" {
  description = "Puerto healthcheck para target group"
  type        = number
  default     = 2000
}
variable "healthcheck_timeout" {
  description = "The amount of time, in seconds, during which no response means a failed health check. For Application Load Balancers, the range is 2 to 120 seconds, and the default is 5 seconds for the instance target type and 30 seconds for the lambda target type. For Network Load Balancers, you cannot set a custom value, and the default is 10 seconds for TCP and HTTPS health checks and 6 seconds for HTTP health checks."
  type        = number
  default     = 10
}
// -- END Target Group for NLB

// -- Service definition
variable "dns_namespace_id" {
  description = "dns namespace id utilizado para service discovery"
  type        = string
}
variable "ecs_cluster" {
  description = "ID del cluster de ecs donde se despliega el servicio"
  type        = string
}
variable "ecs_cluster_name" {
  description = "nombre del cluster de ecs donde se despliega el servicio"
  type        = string
}
variable "microservice_count" {
  description = "numero de instancias con las que arranca el microservicio"
  default     = 1
}
variable "ecs_capacity_provider_fargate_weight" {
  description = "peso asignado a instancias fargate 0 - 100"
  default     = 0
}
variable "ecs_capacity_provider_fargate_spot_weight" {
  description = "peso asignado a instancias spot 0-100"
  default     = 100
}
variable "sg_id" {
  description = "security group del cluster donde se desplegara la task"
  type        = list(string)
}
variable "private_subnet_id" {
  type        = list(string)
  description = "Lista de id de las subnets privadas"
}
// -- Autoscaling
variable "ecs_autoscale_max_instances" {
  description = "numero maximo de instancias en el autoscaling"
  default     = 2
}
variable "ecs_autoscale_min_instances" {
  description = "numero minimo de instancias en el autoscaling"
  default     = 1
}
variable "metric_name" {
  description = "metrica utilizada para el escalamiento (CPUUtilization, MemoryUtilization)"
  default     = "MemoryUtilization"
}
variable "ecs_high_threshold_per" {
  description = "valor que dispara alarma de escalamiento up"
  default     = 85
}
variable "ecs_low_threshold_per" {
  description = "valor que dispara alarma de escalamiento down"
  default     = 50
}
variable "service_namespace" {
  description = "service namespace usado en auto scaling group"
  type        = string
  default     = "ecs"
}
variable "evaluation_periods" {
  description = "Periodos de evaluacion del servicio"
  type        = string
  default     = "1"
}
variable "period" {
  description = "Periodos tiempo entre periodos"
  type        = string
  default     = "60"
}

variable "api_poc_endpoint" {
  description = "endpoint de la api destino con la cual se integrara el servicio de coupon"
  type        = string
}
locals {
  common_tags = (tomap({
    Environment  = var.environment
    Organization = var.organization
    Project      = var.project
  }))
}
