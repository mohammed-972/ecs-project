module "networking" {
  source       = "./module/vpc"
  project_name = var.project_name

}

module "security_groups" {
  source = "./module/security_groups"

  vpc_id       = module.networking.vpc_id
  project_name = var.project_name

}

module "acm" {
  source          = "./module/acm"
  route53_zone_id = data.aws_route53_zone.zone.id

}
