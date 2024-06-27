data "archive_file" "test" {
  type        = "zip"
  source_dir  = "lambda_function/test/src"
  output_path = "lambda/test/src/test_terraform.zip"
}

module "natgateway_start_func" {
  enviroment    = var.environment
  common_name   = var.common_name
  source        = "../../../modules/lambda"
  file_name     = data.archive_file.test.output_path
  code_hash     = data.archive_file.test.output_base64sha256
  function_name = "${var.common_name}-test-func-${var.environment}"
  handler       = "main.handler"
}