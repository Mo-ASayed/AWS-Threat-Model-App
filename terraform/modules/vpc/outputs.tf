output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.tm_vpc.id
}

output "public_subnets" {
  description = "The IDs of the public subnets"
  value       = aws_subnet.tm_public_subnet[*].id
}

output "internet_gateway_id" {
  description = "The ID of the internet gateway"
  value       = aws_internet_gateway.tm_igw.id
}