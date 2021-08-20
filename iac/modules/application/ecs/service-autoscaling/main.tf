resource "aws_appautoscaling_target" "app_scale_target" {
  service_namespace  = "ecs"
  resource_id        = "service/${var.ecs_cluster}/${var.ecs_service_microservice}"
  scalable_dimension = "ecs:service:DesiredCount"
  max_capacity       = var.ecs_autoscale_max_instances
  min_capacity       = var.ecs_autoscale_min_instances
  role_arn           = var.aws_iam_role_ecs_execution_role
}
resource "aws_cloudwatch_metric_alarm" "utilization_high" {
  alarm_name          = "${var.ecs_service_microservice}_${lower(var.metric_name)}_high_${var.ecs_high_threshold_per}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = var.metric_name
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = var.ecs_high_threshold_per
  dimensions = {
    ClusterName = var.ecs_cluster
    ServiceName = var.ecs_service_microservice
  }
  alarm_actions = [aws_appautoscaling_policy.app_up.arn]

  depends_on = [
    var.vm_depends_on
  ]
}

resource "aws_cloudwatch_metric_alarm" "utilization_low" {
  alarm_name          = "${var.ecs_service_microservice}_${lower(var.metric_name)}_low_${var.ecs_low_threshold_per}"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = var.metric_name
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = var.ecs_low_threshold_per

  dimensions = {
    ClusterName = var.ecs_cluster
    ServiceName = var.ecs_service_microservice
  }

  alarm_actions = [aws_appautoscaling_policy.app_down.arn]
  depends_on = [
    var.vm_depends_on
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
