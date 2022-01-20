resource "aws_security_group" "resource_sg" {
  name   = "${var.environment}_${var.project}_${var.resource}_sg"
  vpc_id = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name         = "${var.environment}_${var.project}_${var.resource}_sg"
    Environment  = var.environment
    Organization = var.organization
    Project      = var.project
    Resource     = var.resource
  }
}
