terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.5.0"
    }
  }
  required_version = ">= 1.0.0"
  backend "s3" {
    bucket  = "terraform-yossi-state"
    key     = "global/s3/apache/terraform.tfstate"
    region  = "eu-west-3"
    encrypt = true
  }
}

provider "aws" {
  region = "eu-central-1"
}