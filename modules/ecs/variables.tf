variable "application_name" {
  type          = string
  default       = "myapp"
}

variable "vpc_id" {
  type          = string
}

variable "private1_id" {
  type          = string
}

# variable "private2_id" {
#   type          = string
# }

variable "alb_sg_id" {
  type          = string
}

variable "alb_tg_arn" {
  type          = string
}

variable "task_desired_count" {
  type          = number
}
