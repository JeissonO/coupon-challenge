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
  description = "Datos del recurso a crear"
}
variable "callback_urls" {
  type        = list(string)
  description = "lista de urls de callback"
  default     = ["http://localhost:4200"]
}
variable "logout_urls" {
  type        = list(string)
  description = "lista de urls de logout"
  default     = ["http://localhost:4200"]
}
variable "supported_identity_providers" {
  type        = list(string)
  description = "value"
  default     = ["COGNITO"]
}
variable "prevent_user_existence_errors" {
  default     = "ENABLED"
  description = "previene que se indiquen valores de error si usuario ingresa mal datos"
}
variable "allowed_oauth_scopes" {
  type        = list(string)
  default     = ["email", "openid"]
  description = "scopes permitidos en el flujo de oauth"
}
variable "allowed_oauth_flows" {
  type        = list(string)
  default     = ["code"]
  description = "Flujos de autenticacion permitidos"
}
