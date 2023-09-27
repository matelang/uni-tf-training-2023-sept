resource "aws_s3_bucket" "frontend" {
  bucket_prefix = "unitraining"
}

resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.frontend.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.frontend.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "example" {
  depends_on = [
    aws_s3_bucket_ownership_controls.example,
    aws_s3_bucket_public_access_block.example,
  ]

  bucket = aws_s3_bucket.frontend.id
  acl    = "public-read"
}

resource "aws_s3_object" "index" {
  depends_on = [
    aws_s3_bucket_acl.example
  ]

  bucket       = aws_s3_bucket.frontend.id
  key          = "index.html"
  content      = file("index.html")
  content_type = "text/html"

  acl = "public-read"
}

resource "aws_s3_object" "error" {
  depends_on = [
    aws_s3_bucket_acl.example
  ]

  bucket       = aws_s3_bucket.frontend.id
  key          = "error.html"
  content      = file("error.html")
  content_type = "text/html"

  acl = "public-read"
}

resource "aws_s3_bucket_website_configuration" "example" {
  bucket = aws_s3_bucket.frontend.id

  index_document {
    suffix = aws_s3_object.index.key
  }

  error_document {
    key = aws_s3_object.error.key
  }
}
