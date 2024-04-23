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

# resource "aws_s3_bucket_policy" "bucket" {
#     bucket = aws_s3_bucket.main.id
#     policy = data.aws_iam_policy_document.static-www.json
# }

# data "aws_iam_policy_document" "static-www" {
#     statement {
#         sid    = "Allow CloudFront"
#         effect = "Allow"
#         principals {
#             type        = "AWS"
#             identifiers = [aws_cloudfront_origin_access_identity.static-www.iam_arn]
#         }
#         actions = [
#             "s3:GetObject"
#         ]

#         resources = [
#             "${aws_s3_bucket.main.arn}/*"
#         ]
#     }
# }
