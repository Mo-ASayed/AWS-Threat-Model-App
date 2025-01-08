resource "aws_lb" "tm_alb" {
  name                       = var.alb_name
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [var.security_group_id]
  subnets                    = var.subnet_ids
  drop_invalid_header_fields = true
  access_logs {
    bucket  = "threat-modeling-tool--tf"
    prefix  = "access-logs"
    enabled = true
  }
  # checkov:skip=CKV_AWS_150 Reason: Deletion protection is disabled for easier cleanup
  enable_deletion_protection = false

  tags = {
    Name = var.alb_name
  }
}

resource "aws_lb_target_group" "tm_target_group" {
  name        = var.target_group_name
  port        = var.target_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
    matcher             = "200"
  }
}

resource "aws_lb_listener" "tm_http" {
  load_balancer_arn = aws_lb.tm_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "tm_https" {
  load_balancer_arn = aws_lb.tm_alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn
  default_action {
    type = "forward"
    forward {
      target_group {
        arn    = aws_lb_target_group.tm_target_group.arn
        weight = 1
      }
      stickiness {
        enabled  = false
        duration = 1
      }

    }
  }
}

