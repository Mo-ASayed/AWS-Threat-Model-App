output "route53_record" {
  description = "The created Route53 record"
  value       = aws_route53_record.tm_cname_record.fqdn
}
