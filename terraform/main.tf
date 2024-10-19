module "vpc" {
  source              = "./modules/vpc"
  vpc_cidr            = "10.0.0.0/16"
  vpc_name            = "tm-vpc"
  public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
  availability_zones  = ["us-east-1a", "us-east-1b"]
}

module "security_group" {
  source  = "./modules/security-group"
  sg_name = "tm-ecs-sg"
  vpc_id  = module.vpc.vpc_id
}

module "alb" {
  source            = "./modules/alb"
  alb_name          = "tm-alb"
  security_group_id = module.security_group.sg_id
  subnet_ids        = module.vpc.public_subnets
  target_group_name = "tm-target-group"
  target_port       = 3000
  vpc_id            = module.vpc.vpc_id
  certificate_arn   = "arn:aws:acm:us-east-1:767398132018:certificate/f09d2fe3-f013-4e45-8458-fdbc292d06f1"
}

module "ecs" {
  source             = "./modules/ecs"
  cluster_name       = "tm-cluster"
  task_family        = "tm-task"
  task_cpu           = "1024"
  task_memory        = "3072"
  container_name     = "tm-container"
  container_image    = "767398132018.dkr.ecr.us-east-1.amazonaws.com/mohammedsayed/threat-composer"
  container_port     = 3000
  service_name       = "tm-service"
  desired_count      = 1
  subnet_ids         = module.vpc.public_subnets
  security_group_ids = [module.security_group.sg_id]
  target_group_arn   = module.alb.target_group_arn
  listener_http_arn  = module.alb.http_listener
  listener_https_arn = module.alb.https_listener

  create_iam_role    = false
  execution_role_arn = "arn:aws:iam::767398132018:role/ecsTaskExecutionRole"
  task_role_arn      = "arn:aws:iam::767398132018:role/ecsTaskExecutionRole"
  iam_role_name      = "ecsTaskExecutionRole"
}



module "route53" {
  source       = "./modules/route53"
  zone_name    = "lab.mohammedsayed.com"
  record_name  = "tm.lab.mohammedsayed.com"
  ttl          = 300
  alb_dns_name = module.alb.alb_dns_name
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"

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
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}