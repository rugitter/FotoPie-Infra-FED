# S3 - hosting static website
resource "aws_s3_bucket" "main_bucket" {
  bucket = var.domain_name_dev
  acl    = "public-read"
  policy = file("${path.module}/policy.json")
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
