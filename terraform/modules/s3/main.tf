# Create the S3 bucket for the www domain
resource "aws_s3_bucket" "bucket_www" {
  bucket = "www.${var.domain}"
}

resource "aws_s3_bucket_public_access_block" "bucket_www_public_access" {
  bucket = aws_s3_bucket.bucket_www.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Update www bucket policy resource
resource "aws_s3_bucket_policy" "bucket_www_policy" {
  bucket = aws_s3_bucket.bucket_www.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "arn:aws:s3:::${aws_s3_bucket.bucket_www.bucket}/*"
      }
    ]
  })
  depends_on = [aws_s3_bucket_public_access_block.bucket_www_public_access]
}

# Enable website hosting for the www bucket
resource "aws_s3_bucket_website_configuration" "bucket_www_website" {
  bucket = aws_s3_bucket.bucket_www.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

# Create the S3 bucket for the root domain
resource "aws_s3_bucket" "bucket_root" {
  bucket = var.domain
}

# Disable block public access for root bucket
resource "aws_s3_bucket_public_access_block" "bucket_root_public_access" {
  bucket = aws_s3_bucket.bucket_root.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Update root bucket policy resource
resource "aws_s3_bucket_policy" "bucket_root_policy" {
  bucket = aws_s3_bucket.bucket_root.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "arn:aws:s3:::${var.domain}/*"
      }
    ]
  })
  depends_on = [aws_s3_bucket_public_access_block.bucket_root_public_access]
}


# Configure website routing for the root domain bucket
resource "aws_s3_bucket_website_configuration" "bucket_root_website" {
  bucket = aws_s3_bucket.bucket_root.id

  redirect_all_requests_to {
    host_name = "www.${var.domain}"
    protocol  = "https"
  }
}


