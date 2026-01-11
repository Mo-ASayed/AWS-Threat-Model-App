output "route53_record" {
  description = "The created Route53 record"
  value       = aws_route53_record.cname.fqdn
}

output "zone_id" {
  description = "The ID of the created Route53 hosted zone"
  value       = aws_route53_zone.this.id
}