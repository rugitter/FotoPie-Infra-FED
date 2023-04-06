module "fed-s3" {
  source = "../../modules/s3"

  domain_name_dev = var.my_domain_name
}

module "fed-route53" {
  source = "../../modules/route53"

  domain_name = var.my_domain_name
}



module "fed-cdn" {
  source = "../../modules/cloudfront"

  s3_origin_id = "fotopie.ccdemo.link.s3-website-ap-southeast-2.amazonaws.com"

  bucket_regional_domain_name = module.fed-s3.mainbucket_regional_domain_name
}