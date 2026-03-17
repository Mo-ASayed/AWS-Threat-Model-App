# SG for ECS/ALB — only accepts traffic from the Twingate connector
resource "aws_security_group" "tm_ecs_sg" {
  name   = var.sg_name
  vpc_id = var.vpc_id

  # No ingress rules here — added via sg rules referencing connector SG

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = var.sg_name
  }
}

# SG for the Twingate connector EC2 instance
resource "aws_security_group" "twingate_connector_sg" {
  name   = "${var.sg_name}-twingate-connector"
  vpc_id = var.vpc_id

  # No inbound needed — connector initiates outbound to Twingate cloud
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow connector to reach Twingate cloud"
  }

  tags = {
    Name = "${var.sg_name}-twingate-connector"
  }
}

# Allow connector → ECS on port 3000
resource "aws_security_group_rule" "ecs_ingress_from_connector" {
  type                     = "ingress"
  from_port                = 3000
  to_port                  = 3000
  protocol                 = "tcp"
  security_group_id        = aws_security_group.tm_ecs_sg.id
  source_security_group_id = aws_security_group.twingate_connector_sg.id
  description              = "Only Twingate connector can reach ECS"
}