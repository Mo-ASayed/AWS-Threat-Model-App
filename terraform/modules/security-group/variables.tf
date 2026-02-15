variable "sg_name" {
  type        = string
  description = "Security group name"
}

variable "vpc_id" {
  type        = string
  description = "The VPC ID where the security group will be created"
}

variable "connector_sg_id" {
  type        = string
  description = "Security group ID of Twingate connector for private ALB access"
}
