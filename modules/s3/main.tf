# Generate unique bucket name if not provided
resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}

# S3 Bucket
resource "aws_s3_bucket" "main" {
  bucket        = var.bucket_name != "" ? var.bucket_name : "${var.project_name}-${var.environment}-${random_string.bucket_suffix.result}"
  force_destroy = var.force_destroy

  tags = merge(
    {
      Name        = "${var.project_name}-${var.environment}-bucket"
      Project     = var.project_name
      Environment = var.environment
    },
    var.tags
  )
}

# Bucket Versioning
resource "aws_s3_bucket_versioning" "main" {
  bucket = aws_s3_bucket.main.id
  versioning_configuration {
    status = var.versioning_enabled ? "Enabled" : "Suspended"
  }
}

# Bucket Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "main" {
  count  = var.encryption_enabled ? 1 : 0
  bucket = aws_s3_bucket.main.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = var.kms_key_id != null ? "aws:kms" : "AES256"
      kms_master_key_id = var.kms_key_id
    }
  }
}

# Bucket Public Access Block
resource "aws_s3_bucket_public_access_block" "main" {
  bucket = aws_s3_bucket.main.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Lifecycle Rules
resource "aws_s3_bucket_lifecycle_configuration" "main" {
  count  = length(var.lifecycle_rules) > 0 ? 1 : 0
  bucket = aws_s3_bucket.main.id

  dynamic "rule" {
    for_each = var.lifecycle_rules
    content {
      id     = rule.value.id
      status = rule.value.enabled ? "Enabled" : "Disabled"

      dynamic "transition" {
        for_each = rule.value.transition != null ? rule.value.transition : []
        content {
          days          = transition.value.days
          storage_class = transition.value.storage_class
        }
      }

      dynamic "expiration" {
        for_each = rule.value.expiration != null ? [rule.value.expiration] : []
        content {
          days = expiration.value.days
        }
      }

      # Fixed Filter Block Logic
      filter {
        # If both prefix and tags exist, they must be wrapped in 'and'
        dynamic "and" {
          for_each = rule.value.prefix != null && length(rule.value.tags) > 0 ? [1] : []
          content {
            prefix = rule.value.prefix
            tags   = rule.value.tags
          }
        }

        # If ONLY prefix exists
        prefix = rule.value.prefix != null && length(rule.value.tags) == 0 ? rule.value.prefix : null

        # If ONLY tags exist (and only one tag is provided)
        # Note: If multiple tags, you MUST use the 'and' block above.
        dynamic "tag" {
          for_each = rule.value.prefix == null && length(rule.value.tags) == 1 ? rule.value.tags : {}
          content {
            key   = tag.key
            value = tag.value
          }
        }
      }
    }
  }
}