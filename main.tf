provider "aws" {
  region  = "ap-southeast-1"
  profile = "wkh"
}

//Backend S3 bucket
resource "aws_s3_bucket" "backend_state" {
  bucket = var.backend_bucket_name

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_acl" "backend_state_acl" {
  bucket = aws_s3_bucket.backend_state.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "backend_state_public_block" {
  bucket = aws_s3_bucket.backend_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

// Bucket Versioning
resource "aws_s3_bucket_versioning" "backend_state_bucket_versioning" {
  bucket = aws_s3_bucket.backend_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

// Server Side Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "backend_state_bucket_encryption" {
  bucket = aws_s3_bucket.backend_state.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

//Locking - Dynamo DB
resource "aws_dynamodb_table" "backend_lock" {
  name         = "terraform_state_locks"
  billing_mode = "PAY_PER_REQUEST"

  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

}
