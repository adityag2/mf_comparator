# Data sources for Route53

data "aws_route53_zone" "root" {
  name = var.root_domain
} 

data "aws_acm_certificate" "wildcard" {
  domain   = "*.${var.root_domain}"
  statuses = ["ISSUED"]
  most_recent = true
}