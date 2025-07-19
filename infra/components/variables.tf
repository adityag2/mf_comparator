variable "tf_state_bucket" {
  description = "Name for the S3 bucket to store Terraform state"
  type        = string
  default     = "tf-state-bucket"
}

variable "root_domain" {
  description = "Root domain for Route53 (e.g., yourdomain.com)"
  type        = string
  default     = "parseit.org"
}

variable "domain_name" {
  description = "Custom domain for API Gateway (e.g., api.yourdomain.com)"
  type        = string
  default     = "mf.parseit.org"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
} 