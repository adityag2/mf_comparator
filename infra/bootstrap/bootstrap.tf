resource "aws_s3_bucket" "tf_state" {
  bucket = "tf-state-parseit"

  tags = {
    Name        = "Terraform State Bucket"
  }
}

resource "aws_s3_bucket_versioning" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

output "tf_state_bucket" {
  value = aws_s3_bucket.tf_state.bucket
  description = "The S3 bucket for Terraform state storage. Use this in your backend.tf."
} 