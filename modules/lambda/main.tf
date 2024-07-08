resource "aws_lambda_function" "main" {
  filename         = var.file_name
  source_code_hash = var.code_hash
  function_name    = var.function_name
  role             = var.iam_role_arn
  runtime          = "python3.9"
  handler          = var.handler
  timeout          = 300
  environment {
    variables = var.environments_variables
  }
}