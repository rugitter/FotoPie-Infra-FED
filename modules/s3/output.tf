output "s3_bucket_arn" {
  value = aws_s3_bucket.main_bucket.arn
}

output "mainbucket_regional_domain_name" {
  value = aws_s3_bucket.main_bucket.bucket_regional_domain_name
}