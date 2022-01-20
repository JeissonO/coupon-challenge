resource "aws_ecs_cluster" "cluster" {
  name = "${var.environment}_${var.project}_ecs"
  tags = {
    Name         = "${var.environment}_${var.project}_ecs"
    Environment  = var.environment
    Organization = var.organization
    Project      = var.project
  }
}
