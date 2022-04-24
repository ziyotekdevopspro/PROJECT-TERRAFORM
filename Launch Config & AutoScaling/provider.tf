# Configure the AWS Provider
# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 3.45"
#     }
#   }
# }

provider "aws" {
  region = "us-east-1"

    default_tags {
    tags = {
      Name        = "DEVOPS16 project"
      Environment = var.environment
    }
  }
}

