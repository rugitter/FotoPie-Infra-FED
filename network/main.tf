terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "ap-southeast-2"
}

# Hosted zone and DNS records
resource "aws_route53_zone" "fotopie_zone" {
  name = var.domain_name_dev
}

resource "aws_route53_record" "fotopie_net" {
  zone_id = aws_route53_zone.fotopie_zone.id
  name    = var.domain_name_dev
  type    = "A"

  alias {
    name    = "uat.fotopie.net.s3-website-ap-southeast-2.amazonaws.com"
    # mapping "ap-southeast-2": "Z1WCIGYICN2BYD",
    zone_id = "Z1WCIGYICN2BYD"
    evaluate_target_health = false
  }
}