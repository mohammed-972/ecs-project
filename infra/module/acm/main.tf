resource "aws_acm_certificate" "cert" {
  domain_name       = var.certificate_domain_name
  validation_method = "DNS"
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn = aws_acm_certificate.cert.arn
  validation_record_fqdns = [
    aws_route53_record.validate_cert.fqdn
  ]
}

resource "aws_route53_record" "validate_cert" {
  zone_id = var.route53_zone_id
  name    = one(aws_acm_certificate.cert.domain_validation_options).resource_record_name
  type    = one(aws_acm_certificate.cert.domain_validation_options).resource_record_type
  records = [
    one(aws_acm_certificate.cert.domain_validation_options).resource_record_value

  ]

  ttl = 300

}
