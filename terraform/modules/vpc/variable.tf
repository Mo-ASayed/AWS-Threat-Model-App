variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "vpc_name" {
  type        = string
  description = "Name of the VPC"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for public subnets"
}

variable "availability_zones" {
  type        = list(string)
  description = "Availability zones for subnets"
}
