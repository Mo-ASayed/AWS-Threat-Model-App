variable "alb_name" {
  type        = string
  description = "Name of the ALB"
}

variable "security_group_id" {
  type        = string
  description = "Security group ID attached to the ALB"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnets for the ALB"
}

variable "target_group_name" {
  type        = string
  description = "Name of the target group"
}

variable "target_port" {
  type        = number
  description = "Port for the target group"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID for the target group"
}

variable "certificate_arn" {
  type        = string
  description = "ARN of the SSL certificate"
}
