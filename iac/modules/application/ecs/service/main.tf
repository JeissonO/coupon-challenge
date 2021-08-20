
/**
  @Autor: jeisson.osoriob@gmail.com
  @Date: Agosto 2021
  @Description: Template de configuracion de servicio de ECS
**/
data "aws_region" "current" {}

// ECS Role
resource "aws_iam_role" "ecs_execution_role" {
  name               = "${var.environment}_${var.project}_${var.service_name}_role_service"
  assume_role_policy = file("${path.module}/policies/ecs-task-execution-role.json")
  tags               = merge({ Name = "${var.environment}_${var.project}_${var.service_name}_role_service" }, local.common_tags, )
}
resource "aws_iam_role_policy" "ecs_execution_role_policy" {
  name   = "${var.environment}_${var.project}_${var.service_name}_role_policy_service"
  policy = file("${path.module}/policies/ecs-execution-role-policy.json")
  role   = aws_iam_role.ecs_execution_role.id
}

// Log Group 
resource "aws_cloudwatch_log_group" "log_name" {
  name              = "${var.environment}_${var.project}_${var.service_name}_log_group"
  retention_in_days = var.retention_in_days_logs
  tags = merge({ Name = "${var.environment}_${var.project}_${var.service_name}_log_group",
  StoreInS3 = var.store_in_s3, }, local.common_tags, )
}

// Task Definition
resource "aws_ecs_task_definition" "microservice" {
  family                   = var.service_name
  container_definitions    = <<EOF
                            [    
                                {
                                  "name": "xray-daemon",
                                  "image": "${var.xray_repository}",
                                  "cpu": 32,
                                  "memoryReservation": 256,
                                  "portMappings" : [
                                      {
                                          "containerPort": 2000,
                                          "protocol": "udp"
                                      }
                                  ]
                                },
                                {
                                    "Name":  "${var.service_name}",
                                    "Image": "${var.ecr_repository_url}",
                                    "PortMappings": [
                                        {
                                        "ContainerPort": ${var.service_port},
                                        "Protocol": "${var.load_balancer_protocol}",
                                        "HostPort": ${var.service_port}
                                        }
                                    ],
                                    "Environment" :[
                                      { "Name"  : "AWS_XRAY_CONTEXT_MISSING","Value" : "LOG_ERROR" },        
                                      { "Name"  : "ENV_APP","Value" : "${var.environment}" }
                                    ],
                                    "MemoryReservation": ${var.microservice_memory_reservation},
                                    "Memory": ${var.microservice_memory},
                                    "Essential": true,
                                    "logConfiguration": {
                                        "logDriver": "awslogs",
                                        "options": {
                                        "awslogs-group": "${aws_cloudwatch_log_group.log_name.name}",
                                        "awslogs-region": "${data.aws_region.current.name}",
                                        "awslogs-stream-prefix": "fargate"
                                        }
                                    }
                                }
                            ]
                            EOF
  cpu                      = var.microservice_cpu
  memory                   = var.microservice_memory
  requires_compatibilities = ["FARGATE"]
  network_mode             = var.network_mode
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_execution_role.arn
  tags                     = merge({ Name = "${var.environment}_${var.project}_${var.service_name}_ecs_task" }, local.common_tags, )
}

// Definicino target group del balanceador
resource "aws_lb_target_group" "target_alb_microservice" {
  name        = "${var.environment}-${var.project}-${var.service_name}-tg"
  port        = var.service_port
  protocol    = upper(var.load_balancer_protocol)
  vpc_id      = var.vpc_id
  target_type = var.target_type

  health_check {
    interval = var.healthcheck_interval
    port     = var.healthcheck_port
    protocol = upper(var.healthcheck_protocol)
  }
  lifecycle {
    create_before_destroy = true
  }
  tags = merge({ Name = "${var.environment}-${var.project}-${var.service_name}-tg" }, local.common_tags, )
}
// Listerner definition to expose service in nlb
resource "aws_lb_listener" "listener_alb_microservice" {
  load_balancer_arn = var.load_balancer_arn
  port              = var.load_balancer_port
  protocol          = upper(var.load_balancer_protocol)
  default_action {
    target_group_arn = aws_lb_target_group.target_alb_microservice.arn
    type             = "forward"
  }
}

// Service definition
resource "aws_service_discovery_service" "service_discovery" {
  name = var.service_name
  dns_config {
    namespace_id = var.dns_namespace_id
    dns_records {
      ttl  = 10
      type = "A"
    }
    routing_policy = "MULTIVALUE"
  }
  health_check_custom_config {
    failure_threshold = 1
  }
}
resource "aws_ecs_service" "microservice_service" {
  name            = "${var.environment}_${var.project}_${var.service_name}_service"
  task_definition = aws_ecs_task_definition.microservice.family
  desired_count   = var.microservice_count
  cluster         = var.ecs_cluster
  capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = var.ecs_capacity_provider_fargate_weight
  }
  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = var.ecs_capacity_provider_fargate_spot_weight
  }
  lifecycle {
    ignore_changes = [desired_count, task_definition]
  }
  network_configuration {
    security_groups  = var.sg_id
    subnets          = var.private_subnet_id
    assign_public_ip = false
  }
  service_registries {
    registry_arn = aws_service_discovery_service.service_discovery.arn
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.target_alb_microservice.arn
    container_name   = var.service_name
    container_port   = var.service_port
  }
  tags = merge({ Name = "${var.environment}_${var.project}_${var.service_name}_service" }, local.common_tags, )
}
// Definicion del Autoscaling
resource "aws_appautoscaling_target" "app_scale_target" {
  service_namespace  = var.service_namespace
  resource_id        = "service/${var.ecs_cluster_name}/${var.environment}_${var.project}_${var.service_name}_service"
  scalable_dimension = "ecs:service:DesiredCount"
  max_capacity       = var.ecs_autoscale_max_instances
  min_capacity       = var.ecs_autoscale_min_instances
  role_arn           = aws_iam_role.ecs_execution_role.arn
}
resource "aws_cloudwatch_metric_alarm" "utilization_high" {
  alarm_name          = "${var.environment}_${var.project}_${var.service_name}_service_${lower(var.metric_name)}_high_${var.ecs_high_threshold_per}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.evaluation_periods
  metric_name         = var.metric_name
  namespace           = "AWS/ECS"
  period              = var.period
  statistic           = "Average"
  threshold           = var.ecs_high_threshold_per
  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = "${var.environment}_${var.project}_${var.service_name}_service"
  }
  alarm_actions = [aws_appautoscaling_policy.app_up.arn]
  depends_on = [
    aws_ecs_service.microservice_service
  ]
}
resource "aws_cloudwatch_metric_alarm" "utilization_low" {
  alarm_name          = "${var.environment}_${var.project}_${var.service_name}_service_${lower(var.metric_name)}_low_${var.ecs_low_threshold_per}"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = var.evaluation_periods
  metric_name         = var.metric_name
  namespace           = "AWS/ECS"
  period              = var.period
  statistic           = "Average"
  threshold           = var.ecs_low_threshold_per
  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = "${var.environment}_${var.project}_${var.service_name}_service"
  }
  alarm_actions = [aws_appautoscaling_policy.app_down.arn]
  depends_on = [
    aws_ecs_service.microservice_service
  ]
}
resource "aws_appautoscaling_policy" "app_up" {
  name               = "app-scale-up"
  service_namespace  = aws_appautoscaling_target.app_scale_target.service_namespace
  resource_id        = aws_appautoscaling_target.app_scale_target.resource_id
  scalable_dimension = aws_appautoscaling_target.app_scale_target.scalable_dimension

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }
}
resource "aws_appautoscaling_policy" "app_down" {
  name               = "app-scale-down"
  service_namespace  = aws_appautoscaling_target.app_scale_target.service_namespace
  resource_id        = aws_appautoscaling_target.app_scale_target.resource_id
  scalable_dimension = aws_appautoscaling_target.app_scale_target.scalable_dimension

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 300
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }
}
