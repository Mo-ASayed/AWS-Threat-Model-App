output "alb_arn" {
  description = "The ARN of the Application Load Balancer"
  value       = aws_lb.tm_alb.arn
}

output "alb_url" {
  description = "The URL of the Application Load Balancer"
  value       = aws_lb.tm_alb.dns_name
}

output "target_group_arn" {
  description = "The ARN of the target group"
  value       = aws_lb_target_group.tm_target_group.arn
}

output "http_listener" {
  description = "The ID of the HTTP Listener"
  value       = aws_lb_listener.tm_http.id
}

output "https_listener" {
  description = "The ID of the HTTPS Listener"
  value       = aws_lb_listener.tm_https.id
}

output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer"
  value       = aws_lb.tm_alb.dns_name
}