resource "aws_s3_bucket" "frontend" {
  bucket_prefix = "unitftrain"
}

resource "aws_s3_bucket_ownership_controls" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "frontend" {
  depends_on = [
    aws_s3_bucket_ownership_controls.frontend,
    aws_s3_bucket_public_access_block.frontend,
  ]

  bucket = aws_s3_bucket.frontend.id
  acl    = "public-read"
}

resource "aws_s3_bucket_website_configuration" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  index_document {
    suffix = aws_s3_object.index.key
  }

  error_document {
    key = aws_s3_object.error.key
  }
}

resource "aws_s3_object" "index" {
  depends_on = [
    aws_s3_bucket_acl.frontend
  ]

  bucket       = aws_s3_bucket.frontend.id
  key          = "index.html"       # remote
  content      = file("index.html") # local
  content_type = "text/html"

  acl = "public-read"
}

resource "aws_s3_object" "error" {
  depends_on = [
    aws_s3_bucket_acl.frontend
  ]

  bucket       = aws_s3_bucket.frontend.id
  key          = "error.html"       # remote
  content      = file("error.html") # local
  content_type = "text/html"

  acl = "public-read"
}
