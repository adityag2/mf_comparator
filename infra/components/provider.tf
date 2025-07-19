provider "aws" {
  region = "eu-west-1"
}

provider "aws" {
  region = "us-east-1"
  alias = "us_east_1"
}

terraform {
  required_version = ">= 1.11.0"
  backend "s3" {
    bucket         = "tf-state-parseit"         # <-- Change this to your S3 bucket name
    key            = "mf-comparator/terraform.tfstate"
    region         = "eu-west-1"                    # <-- Change if using a different region
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