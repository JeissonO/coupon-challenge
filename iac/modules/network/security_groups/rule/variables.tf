variable "sg_id" {
  type        = string
  description = "Identificador de Security Group al que se le aplicara la regla"
}
variable "source_sg_id" {
  type        = string
  description = "Identificador de Security Group Origen"
  default     = "false"
}
variable "from_port" {
  type        = string
  description = "Puerto inicio de exposición en la regla"
  default     = 0
}
variable "to_port" {
  type        = string
  description = "Puerto fin de exposición en la regla"
  default     = 65000
}
variable "description_rule" {
  type        = string
  description = "Nombre de microservicio"
}
variable "cidr_blocks_ingress" {
  type        = list(string)
  description = "Bloque CIDRS Ingress"
  default     = ["false"]
}
variable "protocol" {
  description = "Protocolo de permisos asignados"
  default     = "all"
}
