module "fed-route53" {
  source = "../../modules/route53"

  domain_name     = var.my_domain_name
  fed_alb_dns     = module.fed-alb.alb_dns
  fed_alb_zone_id = module.fed-alb.alb_zone_id
}

module "fed-vpc" {
  source = "../../modules/vpc"

  application_name = var.application_name
}

module "fed-alb" {
  source = "../../modules/alb"

  application_name  = var.application_name
  vpc_id            = module.fed-vpc.vpc_id
  public1_id        = module.fed-vpc.public1_id
  public2_id        = module.fed-vpc.public2_id
  tg_port           = 3000          # 3000
  tg_healthcheck    = "/"
}

module "fed-ecr" {
  source = "../../modules/ecr"

  application_name  = var.application_name
}


module "fed-ecs" {
  source = "../../modules/ecs"

  application_name  = var.application_name
  task_desired_count= var.task_desired_count
  tf_container_port = 3000
  ecr_uri           = module.fed-ecr.repo_url

  vpc_id            = module.fed-vpc.vpc_id
  private1_id       = module.fed-vpc.private1_id
  # private2_id       = module.fotopie-bed-vpc.private2_id
  alb_sg_id         = module.fed-alb.alb_sg_id
  alb_tg_arn        = module.fed-alb.alb_tg_arn
}
