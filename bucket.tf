resource "aws_s3_bucket" "bucket-tf-test" {
  bucket = var.bucket_name

  # Não é necessário definir tags aqui, pois já estão definidas no provider
}