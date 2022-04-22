# Configure the AWS Provider

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      Name        = "DEVOPS16"
      Environment = var.environment
    }
  }

}

