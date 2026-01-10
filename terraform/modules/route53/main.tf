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

resource "aws_route53_record" "tm_cname_record" {
  zone_id = aws_route53_zone.tm_lab_zone.id
  name    = var.record_name       # "tm.lab.mohammedsayed.com"
  type    = "CNAME"
  ttl     = var.ttl
  records = [var.alb_dns_name]   # module.alb.alb_dns_name
}

