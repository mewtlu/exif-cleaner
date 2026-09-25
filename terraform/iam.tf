resource "aws_iam_role" "lambda_role" {
  name = "${var.service_name}-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

}

# Give the function's role permission to read from the source bucket
resource "aws_iam_role_policy" "source_bucket_write_policy" {
  name = "source_bucket_write_policy"
  role = aws_iam_role.lambda_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "s3:GetObject"
        Effect = "Allow",
        Resource = "${aws_s3_bucket.source_bucket.arn}/*"
      }
    ]
  })
}

# Give the function's role permission to write to the destination bucket
resource "aws_iam_role_policy" "destination_bucket_write_policy" {
  name = "destination_bucket_write_policy"
  role = aws_iam_role.lambda_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "s3:PutObject"
        Effect = "Allow",
        Resource = "${aws_s3_bucket.destination_bucket.arn}/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}