resource "aws_iam_user" "s3_user_b" {
  name = "s3-user-b"
}

data "aws_iam_policy_document" "s3_destination_bucket_read" {
  statement {
    sid    = "ListBucketContents"
    effect = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation"
    ]
    resources = [
      var.destination_bucket_arn
    ]
  }

  statement {
    sid    = "ReadPerms"
    effect = "Allow"
    actions = [
      "s3:GetObject"
    ]
    resources = [
      "${var.destination_bucket_arn}/*"
    ]
  }
}

resource "aws_iam_policy" "s3_destination_bucket_read_policy" {
  name        = "s3-read-dst-bucket-policy"
  description = "Provides a user read access to the destination S3 bucket for the EXIF cleaner service"
  policy      = data.aws_iam_policy_document.s3_destination_bucket_read.json
}

resource "aws_iam_policy_attachment" "user_b_policy_attachment" {
  name       = "s3-source-bucket-read"
  users      = [aws_iam_user.s3_user_b.name]
  policy_arn = aws_iam_policy.s3_destination_bucket_read_policy.arn
}