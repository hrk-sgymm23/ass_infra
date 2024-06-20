output "arn" {
  value = aws_ecr_repository.main.arn
}

output "image_uri" {
  value = aws_ecr_repository.main.repository_url
}