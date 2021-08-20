resource "aws_ecs_task_definition" "microservice" {
  family                   = var.ecs_task_family
  container_definitions    = var.container_definitions
  cpu                      = var.microservice_cpu
  memory                   = var.microservice_memory
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn       = var.ecs_execution_role_arn
  task_role_arn            = var.ecs_execution_role_arn
  tags = {
    Name         = "${var.environment}_${var.project}_${var.microservice_name}_ecs_task"
    Environment  = var.environment
    Organization = var.organization
    Project      = var.project
  }
}
