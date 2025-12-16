variable "bucket_name" {
  description = "Nome do bucket S3"
  type        = string
  default     = "meu-bucket-exemplo"
}

variable "region" {
  description = "Região da AWS"
  type        = string
}