output "s3_bucket_name" {
  value       = aws_s3_bucket.source_bucket.id
  description = "The deployed S3 storage identifier."
}

output "lambda_arn" {
  value       = module.lambda_function.lambda_function_arn
  description = "The full ARN of the EXIF cleaner Lambda function."
}