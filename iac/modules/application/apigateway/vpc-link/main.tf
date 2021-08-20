resource "aws_api_gateway_vpc_link" "vpc_link" {
  name        = "${var.environment}-${var.project}-${var.resource}-vpc-link"
  target_arns = [var.target_arns]

  tags = {
    Name         = "${var.environment}-${var.project}-${var.resource}-vpc-link"
    Environment  = var.environment
    Organization = var.organization
    Project      = var.project
    Resource     = var.resource
  }
}