module "bed-vpc" {
  source = "../../modules/vpc"

  application_name = var.application_name
}

module "bed-alb" {
  source = "../../modules/alb"

  application_name  = var.application_name
  vpc_id            = module.bed-vpc.vpc_id
  public1_id        = module.bed-vpc.public1_id
  public2_id        = module.bed-vpc.public2_id
  tg_port           = 9090
  tg_healthcheck    = "/api/user"
}

module "bed-ecr" {
  source = "../../modules/ecr"

  application_name  = var.application_name
}

module "bed-ecs" {
  source = "../../modules/ecs"

  application_name  = var.application_name
  task_desired_count= var.task_desired_count
  tf_container_port = 9090
  ecr_uri           = var.ecr_uri

  vpc_id            = module.bed-vpc.vpc_id
  private1_id       = module.bed-vpc.private1_id
  # private2_id       = module.bed-vpc.private2_id
  alb_sg_id         = module.bed-alb.alb_sg_id
  alb_tg_arn        = module.bed-alb.alb_tg_arn
}

# An Extra step to add A record for back-end ALB
# Assume the specified hosted zone aleady been create by fed terraform on AWS
data "aws_route53_zone" "fotopie_zone" {
  name = var.my_domain_name
}

resource "aws_route53_record" "bed_alb_record" {
  zone_id = data.aws_route53_zone.fotopie_zone.id
  name    = "api.${var.my_domain_name}"
  type    = "A"

  alias {
    name    = module.bed-alb.alb_dns
    # zone_id = "Z1WCIGYICN2BYD"    # mapping "ap-southeast-2": 
    zone_id = module.bed-alb.alb_zone_id
    evaluate_target_health = false
  }
}