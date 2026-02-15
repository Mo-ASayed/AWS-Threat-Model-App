output "alb_url" {
  description = "The URL of the Application Load Balancer"
  value       = module.alb.alb_url
}

output "alb_arn" {
  description = "The ARN of the Application Load Balancer"
  value       = module.alb.alb_arn
}

output "target_group_arn" {
  description = "The ARN of the Target Group"
  value       = module.alb.target_group_arn
}

output "http_listener_arn" {
  description = "The ARN of the HTTP Listener"
  value       = module.alb.http_listener
}

output "https_listener_arn" {
  description = "The ARN of the HTTPS Listener"
  value       = module.alb.https_listener
}

output "ecs_cluster_id" {
  description = "The ID of the ECS Cluster"
  value       = module.ecs.ecs_cluster_id
}

output "route53_record" {
  description = "The Route53 record"
  value       = module.route53.route53_record
}