# module "fed-s3" {
#   source = "../../modules/s3"

#   domain_name_dev = var.my_domain_name
# }

module "fed-route53" {
  source = "../../modules/route53"

  domain_name = var.my_domain_name
}
