output "ecs_cluster_id" {
  description = "The ID of the ECS Cluster"
  value       = aws_ecs_cluster.tm_cluster.id
}

output "ecs_service_arn" {
  description = "The ARN of the ECS Service"
  value       = aws_ecs_service.tm_service.id
}
