// Application  Load Balancer
resource "aws_lb" "load_balancer" {
  name               = "${var.environment}-${var.project}-${var.resource}-nlb" #can also be obtained from the variable nlb_config
  load_balancer_type = var.load_balancer_type
  subnets            = var.list_subnet_id
  internal           = var.internal_alb
  tags = {
    Name         = "${var.environment}-${var.project}-nlb"
    Environment  = var.environment
    Organization = var.organization
    Project      = var.project
    Resource     = var.resource
  }
}
