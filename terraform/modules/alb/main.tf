resource "aws_lb" "tm_alb" {
  name                       = var.alb_name
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [var.security_group_id]
  subnets                    = var.subnet_ids
  drop_invalid_header_fields = true
  # access_logs {
  #   bucket  = aws_s3_bucket.access_logs_bucket.bucket
  #   prefix  = "access-logs"
  #   enabled = true
  # }
  
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
    port                = 3000
    interval            = 300
    timeout             = 60
    healthy_threshold   = 2
    unhealthy_threshold = 3
    matcher             = "200-499"
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

resource "aws_acm_certificate" "tm_cert" {
  domain_name       = "tm.lab.mohammedsayed.com"
  validation_method = "DNS"
}

resource "aws_route53_record" "tm_cert_validation" {
  name    = aws_acm_certificate.tm_cert.domain_validation_options[0].resource_record_name
  type    = aws_acm_certificate.tm_cert.domain_validation_options[0].resource_record_type
  zone_id = aws_route53_zone.this.id 
  records = [aws_acm_certificate.tm_cert.domain_validation_options[0].resource_record_value]
  ttl     = 300
}

resource "aws_acm_certificate_validation" "tm_cert_validation" {
  certificate_arn         = aws_acm_certificate.tm_cert.arn
  validation_record_fqdns = [aws_route53_record.tm_cert_validation.fqdn]
}


# resource "aws_s3_bucket" "access_logs_bucket" {
#   bucket = "threat-modeling-tool--tf"
# }

# resource "aws_s3_bucket_policy" "access_logs_policy" {
#   bucket = aws_s3_bucket.access_logs_bucket.id

#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Effect = "Allow",
#         Principal = {
#           Service = "elasticloadbalancing.amazonaws.com"
#         },
#         Action = "s3:PutObject",
#         Resource = "arn:aws:s3:::threat-modeling-tool--tf/access-logs/*",
#         Condition = {
#           StringEquals = {
#             "aws:SourceAccount" = "767398132018"
#           },
#           ArnLike = {
#             "aws:SourceArn" = "arn:aws:elasticloadbalancing:us-east-1:767398132018:loadbalancer/*"
#           }
#         }
#       }
#     ]
#   })
# }