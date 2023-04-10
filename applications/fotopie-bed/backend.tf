terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"

  backend "s3" {
    # profile              = "fotopie-uat"            # change to your AWS profile
    encrypt              = true
    bucket               = "ccdemo-fotopie-tfstate"   # change to your tfstate file bucket
    region               = "ap-southeast-2"
    key                  = "fotopie-bed.tfstate"
  }
}


provider "aws" {
  # profile = "fotopie-uat"         # change to your AWS profile
  region  = "ap-southeast-2"
}