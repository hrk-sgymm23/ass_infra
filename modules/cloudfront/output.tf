output "oai_identifiers" {
    value = aws_cloudfront_origin_access_identity.static-www.iam_arn
}