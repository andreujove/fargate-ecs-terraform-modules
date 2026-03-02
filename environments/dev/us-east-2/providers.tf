terraform {
  required_version = "~> 1.14.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  # Missing: Add a remote backend here (S3 + DynamoDB) 
}

provider "aws" {
  region  = "eu-west-2"
  profile = var.aws_profile # Use a variable instead of a hardcoded string

  default_tags {
    tags = {
      Project     = var.name_prefix
      Environment = var.environment
      ManagedBy   = "Terraform"
      Owner       = "DevOps-Team"
    }
  }
}

