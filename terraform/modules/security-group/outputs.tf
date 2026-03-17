output "sg_id" {
  description = "The ID of the security group"
  value       = aws_security_group.tm_ecs_sg.id
}
output "twingate_connector_sg_id" {
  value = aws_security_group.twingate_connector_sg.id
}