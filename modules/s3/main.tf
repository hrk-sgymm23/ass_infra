resource "aws_s3_bucket" "main" {
  bucket = var.common_name
}

resource "aws_s3_bucket_website_configuration" "main" {
  bucket = aws_s3_bucket.main.bucket
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "index.html"
  }
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.main.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}


resource "aws_s3_bucket_policy" "main" {
  bucket = aws_s3_bucket.main.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.main.arn}/*"
      }
    ]
  })
}

# resource "aws_s3_bucket_policy" "bucket" {
#   bucket = aws_s3_bucket.main.id
#   policy = data.aws_iam_policy_document.static-www.json
# }

# data "aws_iam_policy_document" "static-www" {
#   statement {
#     sid    = "Allow CloudFront"
#     effect = "Allow"
#     principals {
#       type        = "AWS"
#       identifiers = [var.oai_identifiers]
#     }
#     actions = [
#       "s3:GetObject"
#     ]

#     resources = [
#       "${aws_s3_bucket.main.arn}/*"
#     ]
#   }
# }
