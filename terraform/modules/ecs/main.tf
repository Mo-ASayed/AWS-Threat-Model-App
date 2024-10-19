resource "aws_ecs_cluster" "tm_cluster" {
  name = var.cluster_name

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "tm_task" {
  family                   = var.task_family
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn

  container_definitions = jsonencode([{
    name      = var.container_name
    image     = var.container_image
    cpu       = 0
    essential = true

    portMappings = [{
      containerPort = var.container_port
      hostPort      = var.container_port
      protocol      = "tcp"
    }]
  }])

  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
}

resource "aws_ecs_service" "tm_service" {
  name            = var.service_name
  cluster         = aws_ecs_cluster.tm_cluster.id
  task_definition = aws_ecs_task_definition.tm_task.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = var.security_group_ids
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  deployment_controller {
    type = "ECS"
  }

  depends_on = [var.listener_http_arn, var.listener_https_arn]
}

resource "aws_iam_role" "ecs_task_execution_role" {
  count = var.create_iam_role ? 1 : 0 # Create the IAM role only if create_iam_role is true

  name = var.iam_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  count = var.create_iam_role ? 1 : 0 # Attach policy only if the IAM role is created

  role       = aws_iam_role.ecs_task_execution_role[count.index].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


