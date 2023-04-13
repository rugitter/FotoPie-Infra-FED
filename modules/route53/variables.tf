variable "domain_name" {
  description = "A specified domain name for FotoPie"
  type        = string
  default     = "example.com"
}

variable "fed_alb_dns" {
  description = "The dns address for FotoPie FED ALB"
  type        = string
  default     = "example.com"
}

variable "fed_alb_zone_id" {
  description = "The dns address for FotoPie FED ALB"
  type        = string
  default     = "AAABBB"      # "Z1WCIGYICN2BYD"    # mapping "ap-southeast-2"
}