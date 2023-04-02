variable "domain_name_dev" {
  description = "FotoPie UAT Domain Name"
  type        = string
  default     = "uat.fotopie.net"
}

variable "s3_arn_uat" {
  description = "FotoPie UAT S3 Arn"
  type        = string
  default     = "arn:aws:s3:::uat.fotopie.net/*"
}

