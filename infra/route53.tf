data "aws_route53_zone" "zone" {
  name         = "mohammedislam.uk"
  private_zone = false
}

resource "aws_route53_record" "record" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = "tm.mohammedislam.uk"
  type    = "A"


  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = false
  }
}