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
    bucket               = "ccdemo-fotopie-tfstate"
    region               = "ap-southeast-2"
    key                  = "fotopie-fe.tfstate"
  }
}


provider "aws" {
  profile = "default"
  region  = "ap-southeast-2"
}