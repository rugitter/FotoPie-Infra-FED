terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"

  backend "s3" {
    encrypt              = true
    bucket               = "fotopie-tfstate"
    region               = "ap-southeast-2"
    key                  = "fotopie-fe.tfstate"
  }
}


provider "aws" {
  region = "ap-southeast-2"
}

# S3 - hosting static website
resource "aws_s3_bucket" "main_bucket" {
  bucket = var.domain_name_dev
  acl    = "public-read"
  policy = file("policy.json")
}

resource "aws_s3_bucket_website_configuration" "config" {
  bucket = aws_s3_bucket.main_bucket.id

  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "index.html"
  }
}

resource "aws_s3_bucket" "log_bucket" {
  bucket = "log.${var.domain_name_dev}"
}

resource "aws_s3_bucket_acl" "log_bucket_acl" {
  bucket = aws_s3_bucket.log_bucket.id
  acl    = "log-delivery-write"
}

resource "aws_s3_bucket_logging" "logging" {
  bucket = aws_s3_bucket.main_bucket.id

  target_bucket = aws_s3_bucket.log_bucket.id
  target_prefix = "logs/"
}

# Networking
# Hosted zone and DNS records
resource "aws_route53_zone" "fotopie_zone" {
  name = var.domain_name_dev
}

resource "aws_route53_record" "fotopie_net" {
  zone_id = aws_route53_zone.fotopie_zone.id
  name    = var.domain_name_dev
  type    = "A"

  alias {
    name    = "s3-website-ap-southeast-2.amazonaws.com"
    # mapping "ap-southeast-2": "Z1WCIGYICN2BYD",
    zone_id = "Z1WCIGYICN2BYD"
    evaluate_target_health = false
  }
}