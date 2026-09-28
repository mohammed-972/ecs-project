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
  route53_zone_id = data.aws_route53_zone.zone.zone_id

}

module "alb" {
  source                = "./module/alb"
  project_name          = var.project_name
  vpc_id                = module.networking.vpc_id
  alb_security_group_id = module.security_groups.alb_security_group_id
  public_subnet_1       = module.networking.public_subnet_1
  public_subnet_2       = module.networking.public_subnet_2
  certificate_arn       = module.acm.certificate_arn

}

module "ecs" {
  source                      = "./module/ecs"
  project_name                = var.project_name
  public_subnet_1             = module.networking.public_subnet_1
  public_subnet_2             = module.networking.public_subnet_2
  ecs_security_group_id       = module.security_groups.ecs_security_group_id
  target_group_arn            = module.alb.target_group_arn
  ecs_task_execution_role_arn = module.iam.ecs_task_execution_role_arn
  depends_on                  = [module.alb]

}

module "iam" {
  source = "./module/iam"
}