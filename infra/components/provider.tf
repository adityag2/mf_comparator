provider "aws" {
  region = "us-east-1"
}

terraform {
  required_version = ">= 1.11.0"
  backend "s3" {
    bucket         = "tf-state-parseit-org"         # <-- Change this to your S3 bucket name
    key            = "mf-comparator/terraform.tfstate"
    region         = "us-east-1"                    # <-- Change if using a different region
    encrypt        = true
    use_lockfile   = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
} 