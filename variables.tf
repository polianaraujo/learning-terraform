variable "bucket_name" {
  description = "Nome do bucket S3"
  type        = string
  default     = "polianaraujo-bucket-tf-teste"
}

variable "region" {
  description = "Região da AWS"
  type        = string
  default     = "us-east-1"
}