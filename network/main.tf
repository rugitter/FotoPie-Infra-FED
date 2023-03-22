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

resource "aws_route53_zone" "fotopie_zone" {
  name = var.domain_name_dev
}

resource "aws_route53_record" "fotopie_net" {
  zone_id = aws_route53_zone.fotopie_zone.id
  name    = var.domain_name_dev
  type    = "A"
  ttl     = "300"
  alias {
    name    = 
  }

  records = ["10.0.0.1"]
  bucket = aws_s3_bucket.main_bucket.id

  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "index.html"
  }
}

resource "aws_s3_bucket" "log_bucket" {
  bucket = "logs.fotopie-tf.ccdemo.link"
}

resource "aws_s3_object" "log_folder" {
    bucket = aws_s3_bucket.log_bucket.id
    key    = "logs/"
    source = "/dev/null"
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