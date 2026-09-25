variable "aws_region" {
  type        = string
  default     = "eu-west-1"
  description = "The target AWS region."
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "The name of the deployment environment."
}

variable "source_bucket_name" {
  type        = string
  default     = "mewtlu-exif-cleaner-src-bucket"
  description = "The name to be used for the source/trigger S3 bucket."
}

variable "destination_bucket_name" {
  type        = string
  default     = "mewtlu-exif-cleaner-dst-bucket"
  description = "The name to be used for the destination S3 bucket."
}

variable "lambda_function_name" {
  type        = string
  default     = "exif-cleaner"
  description = "The name to be used for the Lambda function and related resources."
}