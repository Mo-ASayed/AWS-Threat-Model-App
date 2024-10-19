variable "cluster_name" {
  type        = string
  description = "ECS cluster name"
}

variable "task_family" {
  type        = string
  description = "ECS task family name"
}

variable "task_cpu" {
  type        = string
  description = "ECS task CPU units"
}

variable "task_memory" {
  type        = string
  description = "ECS task memory"
}

variable "container_name" {
  type        = string
  description = "ECS container name"
}

variable "container_image" {
  type        = string
  description = "ECS container image"
}

variable "container_port" {
  type        = number
  description = "Port the container listens on"
}

variable "execution_role_arn" {
  type        = string
  description = "ARN of the ECS execution role"
}

variable "task_role_arn" {
  type        = string
  description = "ARN of the ECS task role"
}

variable "service_name" {
  type        = string
  description = "ECS service name"
}

variable "desired_count" {
  type        = number
  description = "Number of ECS tasks to run"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnets for ECS service"
}

variable "security_group_ids" {
  type        = list(string)
  description = "Security groups for ECS service"
}

variable "target_group_arn" {
  type        = string
  description = "ARN of the target group for the load balancer"
}

variable "listener_http_arn" {
  type        = string
  description = "ARN of the HTTP listener"
}

variable "listener_https_arn" {
  type        = string
  description = "ARN of the HTTPS listener"
}

variable "iam_role_name" {
  type        = string
  description = "IAM Role name for ECS task execution"
}

variable "create_iam_role" {
  description = "Flag to determine whether to create a new IAM role or use an existing one"
  type        = bool
  default     = true
}
