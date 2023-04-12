terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"

  # Change the values here to your own backend
  backend "s3" {
    profile              = "fotopie-uat"
    encrypt              = true
    bucket               = "fotopie-statefile-fed"
    region               = "ap-southeast-2"
    key                  = "fotopie-fed.tfstate"
  }
}


provider "aws" {
  profile = "fotopie-uat"
  region  = "ap-southeast-2"
}