output "backend_state_bucket_details" {
  value = aws_s3_bucket.backend_state
}

output "backend_lock_dynamodb_details" {
  value = aws_dynamodb_table.backend_lock
}
