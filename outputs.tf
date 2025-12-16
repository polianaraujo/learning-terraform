output "bucket_id" {
  description = "ID do bucket S3 criado"
  value       = aws_s3_bucket.bucket-tf-test.id
}

output "bucket_arn" {
  description = "ARN (Amazon Resource Name) do bucket S3 criado"
  value       = aws_s3_bucket.bucket-tf-test.arn
}