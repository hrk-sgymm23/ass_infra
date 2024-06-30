# IAMリソース群
resource "aws_iam_role" "lambda_role" {
  name               = "${var.common_name}-lambda-role"
  assume_role_policy = file("${path.module}/assume_policy.json")
}

resource "aws_iam_policy" "lambda_policy" {
  name   = "${var.common_name}-lambda-policy"
  policy = file("${path.module}/lambda_policy.json")
}

resource "aws_iam_role_policy_attachment" "name" {
  role       = aws_iam_role.lambda_role.id
  policy_arn = aws_iam_policy.lambda_policy.arn
}

resource "aws_lambda_function" "main" {
  filename         = var.file_name
  source_code_hash = var.code_hash
  function_name    = var.function_name
  role             = aws_iam_role.lambda_role.arn
  runtime          = "python3.9"
  handler          = var.handler
}