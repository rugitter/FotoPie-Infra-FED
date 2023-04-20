variable "my_domain_name" {
  description = "Specify the domain name you want to work on"
  type        = string
  default     = "uat.fotopie.net"
}

variable "application_name" {
  description = "Specify the application name this resource belongs to. e.g. fotopie-fed or bed"
  type        = string
  default     = "fotopie-bed"
}

variable "task_desired_count" {
  description = "Specify the desired amount of tasks when creating an ecs service"
  type        = number
  default     = 1
}

variable "ecr_uri"  {
  description = "Specify the url for your ECR"
  type        = string
  default     = "ecr_uri"
}