terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.AWS_REGION

  assume_role {
    role_arn = "arn:aws:iam::342652145440:role/Engineer"
  }
}