data "aws_caller_identity" "current" {}

#Create s3 Bucket for website hosting
resource "aws_s3_bucket" "bucket" {
  bucket        = "${var.bucketname}-${data.aws_caller_identity.current.account_id}"
  force_destroy = var.force_destroy
}

resource "aws_s3_bucket_public_access_block" "bucket_acl" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

#Create s3 bucket website configuration
resource "aws_s3_bucket_website_configuration" "static_website" {
  bucket = aws_s3_bucket.bucket.id

  index_document {
    suffix = "index.html"
  }
}
#create s3 bucket policy
resource "aws_s3_bucket_policy" "allow_access_cloudfront" {
  bucket = aws_s3_bucket.bucket.id
  policy = data.aws_iam_policy_document.s3_policy.json
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = [
      aws_s3_bucket.bucket.arn,
      "${aws_s3_bucket.bucket.arn}/*",
    ]
  }
}

resource "aws_s3_bucket" "pipeline_bucket" {
  bucket        = "${var.codepipeline_bucket_name}-${data.aws_caller_identity.current.account_id}" 
  force_destroy = var.force_destroy 
}

resource "aws_s3_bucket_public_access_block" "pipeline_bucket_acl" {
  bucket = aws_s3_bucket.pipeline_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}