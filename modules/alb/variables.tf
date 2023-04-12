variable "application_name" {
  type          = string
  default       = "myapp"
}

variable "vpc_id" {
  type          = string
}

variable "public1_id" {
  type          = string
}

variable "public2_id" {
  type          = string
}

variable "tg_port" {
  type          = number          
}

variable "tg_healthcheck" {
  type          = string
}
