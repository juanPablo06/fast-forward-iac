terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.65"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      Owner       = "ftdevopsteam@ft-s.com"
      Project     = "ft"
      Environment = var.environment
    }
  }
}
