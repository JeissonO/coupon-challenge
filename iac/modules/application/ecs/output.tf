output "ecs_cluster_id" {
  value = aws_ecs_cluster.cluster.id
}
output "ecs_cluster_name" {
  value = "${var.environment}_${var.project}_ecs"
}