resource "aws_acm_certificate" "cert" {
  domain_name       = "tm.mohammedislam.uk"
  validation_method = "DNS"
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn = aws_acm_certificate.cert.arn
  validation_record_fqdns = [
    aws_route53_record.validate_cert.fqdn
  ]
}


