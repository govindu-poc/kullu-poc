#######################################
# 1. S3 Bucket for CloudTrail Logs
#######################################
resource "aws_s3_bucket" "cloudtrail_bucket" {
  bucket = "${var.cluster_name}-${var.environment}-cloudtrail-logs"

  tags = {
    Name        = "${var.cluster_name}-${var.environment}-cloudtrail-logs"
    Environment = var.environment
    Project     = "poc-demo"
    Owner       = "govindu"
  }
}

# Ensure S3 bucket has secure settings
resource "aws_s3_bucket_public_access_block" "cloudtrail_bucket_block" {
  bucket                  = aws_s3_bucket.cloudtrail_bucket.id
  block_public_acls        = true
  block_public_policy      = true
  ignore_public_acls       = true
  restrict_public_buckets  = true
}

#######################################
# 2. IAM Policy for CloudTrail to write logs
#######################################
data "aws_iam_policy_document" "cloudtrail_s3_policy" {
  statement {
    sid = "AWSCloudTrailAclCheck"
    actions = ["s3:GetBucketAcl"]
    resources = [aws_s3_bucket.cloudtrail_bucket.arn]
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }

  statement {
    sid = "AWSCloudTrailWrite"
    actions = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.cloudtrail_bucket.arn}/AWSLogs/*"]
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
}

resource "aws_s3_bucket_policy" "cloudtrail_s3_policy" {
  bucket = aws_s3_bucket.cloudtrail_bucket.id
  policy = data.aws_iam_policy_document.cloudtrail_s3_policy.json
}

#######################################
# 3. CloudWatch Log Group for real-time monitoring (optional)
#######################################
resource "aws_cloudwatch_log_group" "cloudtrail_log_group" {
  name              = "/aws/cloudtrail/${var.cluster_name}-${var.environment}"
  retention_in_days = 90

  tags = {
    Environment = var.environment
  }
}

#######################################
# 4. CloudTrail Setup
#######################################
resource "aws_cloudtrail" "eks_trail" {
  name                          = "${var.cluster_name}-${var.environment}-trail"
  s3_bucket_name                = aws_s3_bucket.cloudtrail_bucket.id
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true
  cloud_watch_logs_group_arn    = "${aws_cloudwatch_log_group.cloudtrail_log_group.arn}:*"
  cloud_watch_logs_role_arn     = aws_iam_role.cloudtrail_cw_role.arn

  event_selector {
    read_write_type           = "All"
    include_management_events = true
    # Remove the invalid data_resource block
  }

  tags = {
    Name        = "${var.cluster_name}-${var.environment}-trail"
    Environment = var.environment
    Project     = "poc-demo"
  }

  depends_on = [
    aws_s3_bucket_policy.cloudtrail_s3_policy
  ]
}

#######################################
# 5. IAM Role for CloudTrail to send logs to CloudWatch
#######################################
data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "cloudtrail_cw_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "cloudtrail_cw_role" {
  name               = "${var.cluster_name}-${var.environment}-cloudtrail-cw-role"
  assume_role_policy = data.aws_iam_policy_document.cloudtrail_cw_assume.json
}

resource "aws_iam_role_policy" "cloudtrail_cw_policy" {
  name = "${var.cluster_name}-${var.environment}-cloudtrail-cw-policy"
  role = aws_iam_role.cloudtrail_cw_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:PutLogEvents",
          "logs:CreateLogStream"
        ]
        Resource = "${aws_cloudwatch_log_group.cloudtrail_log_group.arn}:*"
      }
    ]
  })
}