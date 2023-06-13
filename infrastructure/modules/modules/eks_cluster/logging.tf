resource "aws_kms_key" "logging" {
  description             = "This key is used to encrypt logging bucket objects"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket" "logging" {
  bucket = "${var.project}-${var.environment}-logs-test"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "logging" {
  bucket = aws_s3_bucket.logging.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.logging.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_acl" "logging" {
  bucket = aws_s3_bucket.logging.id
  acl    = "private"
}

resource "aws_s3_bucket_ownership_controls" "logging" {
  bucket = aws_s3_bucket.logging.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "logging" {
  bucket = aws_s3_bucket.logging.bucket

  rule {
    id = "log"

    expiration {
      days = 395
    }

    status = "Enabled"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 60
      storage_class = "GLACIER"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "logging" {
  bucket = aws_s3_bucket.logging.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_iam_policy" "logging" {
  name        = "${var.project}-${var.environment}-logging-policy"
  path        = "/"
  description = "Policy used to give access to our S3 bucket from EKS."

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "",
        "Effect" : "Allow",
        "Action" : [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucketVersions",
          "kms:Decrypt",
          "kms:Encrypt",
          "kms:GenerateDataKey",
          "s3:ListBucket"
        ],
        "Resource" : [
          aws_kms_key.logging.arn,
          aws_s3_bucket.logging.arn,
          "${aws_s3_bucket.logging.arn}/*"
        ]
      }
    ]
  })
}
