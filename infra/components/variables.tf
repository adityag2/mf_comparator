variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "s3_bucket_name" {
  description = "Name for the S3 bucket to host the frontend static site"
  type        = string
  default     = "mf-comparator-frontend-bucket"
}

variable "domain_name" {
  description = "Custom domain for the frontend (e.g., mf.parseit.org)"
  type        = string
  default     = "mf.parseit.org"
}

variable "acm_certificate_domain" {
  description = "Domain name for the ACM certificate (e.g., *.parseir.org)"
  type        = string
  default     = "*.parseit.org"
}

variable "cloudfront_aliases" {
  description = "List of domain aliases for the CloudFront distribution (e.g., [\"mf.parseit.org\"])"
  type        = list(string)
  default     = ["mf.parseit.org"]
} 