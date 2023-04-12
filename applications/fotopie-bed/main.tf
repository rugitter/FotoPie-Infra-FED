module "fotopie-bed-vpc" {
  source = "../../modules/vpc"

  application_name = var.application_name
}

module "fotopie-bed-alb" {
  source = "../../modules/alb"

  application_name  = var.application_name
  vpc_id            = module.fotopie-bed-vpc.vpc_id
  public1_id        = module.fotopie-bed-vpc.public1_id
  public2_id        = module.fotopie-bed-vpc.public2_id
  tg_port           = 3000
  tg_healthcheck    = "/api/user"
}

module "fotopie-bed-ecs" {
  source = "../../modules/ecs"

  application_name  = var.application_name
  task_desired_count= var.task_desired_count

  vpc_id            = module.fotopie-bed-vpc.vpc_id
  private1_id       = module.fotopie-bed-vpc.private1_id
  # private2_id       = module.fotopie-bed-vpc.private2_id
  alb_sg_id         = module.fotopie-bed-alb.alb_sg_id
  alb_tg_arn        = module.fotopie-bed-alb.alb_tg_arn
}