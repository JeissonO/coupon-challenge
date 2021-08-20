resource "aws_service_discovery_private_dns_namespace" "dns_namespace" {
  name        = "${var.environment}.${var.organization}.${var.project}"
  description = "${var.environment}.${var.organization}.${var.project} DNS Namespace para el service Discovery"
  vpc         = var.vpc_id

  tags = {
    Name         = "${var.environment}.${var.organization}.${var.project}"
    Environment  = var.environment
    Organization = var.organization
    Project      = var.project
  }
}