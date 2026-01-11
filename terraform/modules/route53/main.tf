resource "aws_route53_zone" "this" {
  name = var.zone_name
}

resource "aws_route53_record" "cname" {
  zone_id = aws_route53_zone.this.id
  name    = var.record_name
  type    = "CNAME"
  ttl     = var.ttl
  records = [var.alb_dns_name]
}
