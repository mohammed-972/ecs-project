data "aws_route53_zone" "zone" {
  name         = "mohammedislam.uk"
  private_zone = false
}

resource "aws_route53_record" "record" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = module.acm.domain_name
  type    = "A"


  alias {
    name                   = module.alb.alb_dns_name
    zone_id                = module.alb.alb_zone_id
    evaluate_target_health = false
  }


}