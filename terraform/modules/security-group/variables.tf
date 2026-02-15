variable "sg_name" {
  type        = string
  description = "Security group name"
}

variable "vpc_id" {
  type        = string
  description = "The VPC ID where the security group will be created"
}
