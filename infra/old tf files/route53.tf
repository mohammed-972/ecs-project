data "aws_route53_zone" "zone" {
  name         = "mohammedislam.uk"
  private_zone = false
}

resource "aws_route53_record" "record" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = aws_acm_certificate.cert.domain_name
  type    = "A"


  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = false
  }


}

resource "aws_route53_record" "validate_cert" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = one(aws_acm_certificate.cert.domain_validation_options).resource_record_name
  type    = one(aws_acm_certificate.cert.domain_validation_options).resource_record_type
  records = [
    one(aws_acm_certificate.cert.domain_validation_options).resource_record_value

  ]

  ttl = 300

}
