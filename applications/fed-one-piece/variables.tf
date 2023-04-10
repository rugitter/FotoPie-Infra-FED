variable "my_domain_name" {
  description = "Specify the domain name you want to work on"
  type        = string
  default     = "uat.fotopie.net"
}

# variable "my_tfstate_bucket" {
#   description = "Specify the S3 bucket where your tfstate file will be"
#   type        = string
#   default     = "fotopie-statefile-fed"
# }