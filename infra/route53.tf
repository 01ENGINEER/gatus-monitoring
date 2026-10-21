# Create DNS records only when a domain and hosted zone are configured

locals {
  enable_dns = var.domain_name != "" && var.route53_zone_id != ""
}

# Point the Gatus domain to the Application Load Balancer
resource "aws_route53_record" "gatus" {
  count = local.enable_dns ? 1 : 0

  zone_id = var.route53_zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_lb.gatus.dns_name
    zone_id                = aws_lb.gatus.zone_id
    evaluate_target_health = true
  }
}

# Create DNS records to prove domain ownership to ACM
resource "aws_route53_record" "acm_validation" {
  for_each = local.enable_dns ? {
    for option in aws_acm_certificate.gatus[0].domain_validation_options :
    option.domain_name => {
      name   = option.resource_record_name
      record = option.resource_record_value
      type   = option.resource_record_type
    }
  } : {}

  zone_id         = var.route53_zone_id
  name            = each.value.name
  type            = each.value.type
  ttl             = 60
  records         = [each.value.record]
  allow_overwrite = true
}

# Wait until AWS validates the certificate
resource "aws_acm_certificate_validation" "gatus" {
  count = local.enable_dns ? 1 : 0

  certificate_arn = aws_acm_certificate.gatus[0].arn

  validation_record_fqdns = [
    for record in aws_route53_record.acm_validation :
    record.fqdn
  ]
}
