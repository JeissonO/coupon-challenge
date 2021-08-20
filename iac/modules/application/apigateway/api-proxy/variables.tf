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
variable "endpoint_type" {
  type        = list(string)
  description = "Tipo endpoint que expondra el API (EDGE, REGIONAL or PRIVATE)"
}
variable "proxy_part" {
  description = "path del api - enviar {proxy+} para incluir proxy"
  default     = "{proxy+}"
}
variable "path_part" {
  description = "path root del api - enviar nonbre api"
}
variable "integration_input_type" {
  description = "Tipo de integracion: HTTP (for HTTP backends), MOCK, AWS (for AWS services), AWS_PROXY (for Lambda proxy integration) and HTTP_PROXY (HTTP proxy integration). VPC_LINK"
}
variable "nlb_dns_name" {
  description = "dns del balanceador NLB que resolvera los llamados"
}
variable "app_port" {
  description = "puerto del balanceador de carga donde esta expuesto el servicio (puerto del listener asociado al servicio)"
}
variable "integration_http_method" {
  description = "Metodo de integracion a realizar (ANY, GET, POST, PUT, OPTION, DELETE)"
}
variable "api_gateway_vpc_link_id" {
  description = "id del vpc link para conexion segura al balanceador"
}
variable "provider_arns" {
  type        = list(string)
  description = "arn del provider de congnito"
}
variable "authorization_scopes" {
  type        = list(string)
  description = "scopes configurados para la autorizacion de cognito"
}
