resource "aws_s3_bucket" "main" {
  bucket = var.bucket_name

  tags = var.bucket_tags
}

resource "aws_s3_bucket_ownership_controls" "main" {
  bucket = aws_s3_bucket.main.bucket

  rule {
    object_ownership = var.object_ownership
  }
}

resource "aws_s3_bucket_public_access_block" "main" {
  bucket = aws_s3_bucket.main.bucket

  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}

resource "aws_s3_bucket_acl" "main" {
  depends_on = [aws_s3_bucket_public_access_block.main,
  aws_s3_bucket_ownership_controls.main]

  bucket = aws_s3_bucket.main.bucket
  acl    = var.acl
}

resource "aws_s3_bucket_lifecycle_configuration" "main" {
  bucket = aws_s3_bucket.main.bucket

  dynamic "rule" {
    for_each = var.lifecycle_rules

    content {
      status = rule.value.status
      id     = rule.value.id

      dynamic "filter" {
        for_each = rule.value.filter

        content {
          prefix = filter.value.prefix
        }
      }

      dynamic "expiration" {
        for_each = rule.value.expiration

        content {
          days = expiration.value.days
        }
      }

      dynamic "transition" {
        for_each = rule.value.transition

        content {
          days          = transition.value.days
          storage_class = transition.value.storage_class
        }
      }
    }
  }
}

resource "aws_s3_bucket_versioning" "main" {
  bucket = aws_s3_bucket.main.bucket

  versioning_configuration {
    status = var.versioning_status
  }
}
