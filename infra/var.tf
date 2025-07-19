variable "aws_region" {
  default = "us-east-1"
}

variable "domain_name" {
  description = "Custom domain for API Gateway"
  type        = string
}

variable "certificate_arn" {
  description = "ACM certificate ARN for the domain"
  type        = string
}