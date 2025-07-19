variable "aws_region" {
  description = "AWS region for all resources"
  type        = string
  default     = "us-east-1"
}

variable "tf_state_bucket" {
  description = "Name for the S3 bucket to store Terraform state"
  type        = string
  default     = "tf-state-bucket"
}

variable "root_domain" {
  description = "Root domain for Route53 (e.g., yourdomain.com)"
  type        = string
}

variable "domain_name" {
  description = "Custom domain for API Gateway (e.g., api.yourdomain.com)"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
} 