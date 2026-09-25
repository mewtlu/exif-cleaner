# Archive the source code for the function
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../src"
  output_path = "${path.module}/../outputs/lambda_function.zip"
}

# Deploy the function using the source archive
resource "aws_lambda_function" "exif_cleaner" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = var.lambda_function_name
  role             = aws_iam_role.lambda_role.arn
  handler          = "handler.handler"
  runtime          = "python3.13"
  memory_size      = 512
  timeout          = 5
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  environment {
    variables = {
      DESTINATION_BUCKET = aws_s3_bucket.destination_bucket.id
    }
  }

  tags = {
    Environment = var.environment
  }

  depends_on = [aws_iam_role_policy_attachment.lambda_logs]
}

# Allow bucket to trigger function execution
resource "aws_lambda_permission" "allow_s3_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.exif_cleaner.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.source_bucket.arn
}

# Register notification for trigger on any ObjectCreated event
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.source_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.exif_cleaner.arn
    events              = ["s3:ObjectCreated:*"]
    filter_suffix       = ".jpg"
  }

  depends_on = [aws_lambda_permission.allow_s3_bucket]
}