# Create the source bucket and restrict public access
resource "aws_s3_bucket" "source_bucket" {
  bucket        = var.source_bucket_name
  force_destroy = true

  tags = {
    Environment = var.environment,
    Service = var.service_name,
  }
}

resource "aws_s3_bucket_public_access_block" "source_bucket_block_public" {
  bucket = aws_s3_bucket.source_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


# Create the destination bucket and restrict public access
resource "aws_s3_bucket" "destination_bucket" {
  bucket        = var.destination_bucket_name
  force_destroy = true

  tags = {
    Environment = var.environment,
    Service = var.service_name,
  }
}


resource "aws_s3_bucket_public_access_block" "destination_bucket_block_public" {
  bucket = aws_s3_bucket.destination_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}