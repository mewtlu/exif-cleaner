# Archive the source code for the function
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../src"
  output_path = "${path.module}/../outputs/lambda_function.zip"
}

## IAM module
module "iam" {
  source = "./iam"
  aws_region = var.aws_region
  environment = var.environment
  source_bucket_arn = aws_s3_bucket.source_bucket.arn
  destination_bucket_arn = aws_s3_bucket.destination_bucket.arn
  service_name = var.service_name
}

## Lambda function module
module "lambda_function" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 7.0" # Use the latest stable version

  # Lambda function options
  function_name    = var.service_name
  handler          = "handler.handler"
  runtime          = var.python_runtime
  memory_size      = 2048
  timeout          = 15 
  architectures    = ["x86_64"]

  # Module options
  source_path       = "${path.module}/../src" 
  lambda_role       = module.iam.lambda_role_arn
  create_role       = false
  build_in_docker   = true
  docker_image      = "public.ecr.aws/sam/build-${var.python_runtime}:latest"
  docker_file       = "${path.module}/../Dockerfile"
  docker_build_root = "${path.module}/../src"
  use_existing_cloudwatch_log_group = true

  environment_variables = {
    DESTINATION_BUCKET = aws_s3_bucket.destination_bucket.id
  }

  tags = {
    Environment = var.environment,
    Service = var.service_name,
  }
}

# Allow bucket to trigger function execution
resource "aws_lambda_permission" "allow_s3_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = var.service_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.source_bucket.arn
}

# Register notification for trigger on any ObjectCreated event
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.source_bucket.id

  # for both jpg and jpeg file extensions
  lambda_function {
    lambda_function_arn = module.lambda_function.lambda_function_arn
    events              = ["s3:ObjectCreated:*"]
    filter_suffix       = ".jpg"
  }

  lambda_function {
    lambda_function_arn = module.lambda_function.lambda_function_arn
    events              = ["s3:ObjectCreated:*"]
    filter_suffix       = ".jpeg"
  }

  depends_on = [aws_lambda_permission.allow_s3_bucket]
}
