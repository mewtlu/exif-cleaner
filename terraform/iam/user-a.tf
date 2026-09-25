resource "aws_iam_user" "s3_user_a" {
  name = "s3-user-a"
}

data "aws_iam_policy_document" "s3_source_bucket_read_write" {
  statement {
    sid    = "ListBucketContents"
    effect = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation"
    ]
    resources = [
      var.source_bucket_arn
    ]
  }

  statement {
    sid    = "ReadWritePerms"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]
    resources = [
      "${var.source_bucket_arn}/*"
    ]
  }
}

resource "aws_iam_policy" "s3_source_bucket_read_write_policy" {
  name        = "s3-read-write-src-bucket-policy"
  description = "Provides a user read and write access to the source S3 bucket for the EXIF cleaner service"
  policy      = data.aws_iam_policy_document.s3_source_bucket_read_write.json
}

resource "aws_iam_policy_attachment" "user_a_policy_attachment" {
  name       = "s3-source-bucket-read-write"
  users      = [aws_iam_user.s3_user_a.name]
  policy_arn = aws_iam_policy.s3_source_bucket_read_write_policy.arn
}