locals {
  subnet_list         = tolist(module.ass_sbunet_stg.public_subnet_ids)
  route_table_id_list = tolist(module.ass_sbunet_stg.public_route_table_ids)
}

# IAM関連
resource "aws_iam_role" "lambda_role" {
  name               = "${var.common_name}-lambda-role"
  assume_role_policy = file("${path.module}/policies/lambda_assume_policy.json")
}

resource "aws_iam_policy" "lambda_policy" {
  name   = "${var.common_name}-lambda-policy"
  policy = file("${path.module}/policies/lambda_policy.json")
}

resource "aws_iam_role_policy_attachment" "name" {
  role       = aws_iam_role.lambda_role.id
  policy_arn = aws_iam_policy.lambda_policy.arn
}

# NATGW開始用lambda
data "archive_file" "natgw_start" {
  type        = "zip"
  source_dir  = "lambda_function/natgw_start/src"
  output_path = "lambda/natgw_start/src/test_terraform.zip"
}

module "natgateway_start_func" {
  environment   = var.environment
  common_name   = var.common_name
  source        = "../../../modules/lambda"
  file_name     = data.archive_file.natgw_start.output_path
  code_hash     = data.archive_file.natgw_start.output_base64sha256
  function_name = "${var.common_name}-natgw-start-func-${var.environment}"
  handler       = "main.handler"
  iam_role_arn  = aws_iam_role.lambda_role.arn
  environments_variables = {
    SubnetId1       = local.subnet_list[0],
    SubnetId2       = local.subnet_list[1],
    RouteTableId1   = local.route_table_id_list[0],
    RouteTableId2   = local.route_table_id_list[1],
    NatGatewayName1 = "${var.common_name}-Nat-GW-${var.environment}-1"
    NatGatewayName2 = "${var.common_name}-Nat-GW-${var.environment}-2"
  }
}

# NATGW終了用lambda
data "archive_file" "natgw_stop" {
  type        = "zip"
  source_dir  = "lambda_function/natgw_stop/src"
  output_path = "lambda/natgw_stop/src/natgw_stop_terraform.zip"
}

module "natgateway_stop_func" {
  environment   = var.environment
  common_name   = var.common_name
  source        = "../../../modules/lambda"
  file_name     = data.archive_file.natgw_stop.output_path
  code_hash     = data.archive_file.natgw_stop.output_base64sha256
  function_name = "${var.common_name}-natgw-stop-func-${var.environment}"
  handler       = "main.handler"
  iam_role_arn  = aws_iam_role.lambda_role.arn
  environments_variables = {
    SubnetId1       = local.subnet_list[0],
    SubnetId2       = local.subnet_list[1],
    RouteTableId1   = local.route_table_id_list[0],
    RouteTableId2   = local.route_table_id_list[1],
    NatGatewayName1 = "${var.common_name}-Nat-GW-${var.environment}-1"
    NatGatewayName2 = "${var.common_name}-Nat-GW-${var.environment}-2"
  }
}

# NATGW用EventBridgeリソース群
# 開始、終了時刻をlocalsで定義
locals {
  stop_nat_schedule  = "cron(0 15 * * ? *)"  // 00:00 JST
  start_nat_schedule = "cron(30 10 * * ? *)" // 19:30 JST
}

# Scheduler用IAMリソース
resource "aws_iam_role" "scheduler_assume_role" {
  name               = "${var.common_name}-lambda-scheduler-assume-role"
  assume_role_policy = file("${path.module}/policies/scheduler_assume_policy.json")
}


# 終了
# resource "aws_scheduler_schedule" "nat_stop_stg" {
#   name                = "${var.common_name}-nat-stop-scheduler-${var.environment}"
#   schedule_expression = local.stop_nat_schedule
#   flexible_time_window {
#     mode = "OFF"
#   }

#   target {
#     arn      = module.natgateway_stop_func.lambda_arn
#     role_arn = aws_iam_role.scheduler_assume_role.arn
#   }
# }

# 開始
# resource "aws_scheduler_schedule" "nat_start_stg" {
#   name                = "${var.common_name}-nat-start-scheduler-${var.environment}"
#   schedule_expression = local.start_nat_schedule
#   flexible_time_window {
#     mode = "OFF"
#   }

#   target {
#     arn      = module.natgateway_start_func.lambda_arn
#     role_arn = aws_iam_role.scheduler_assume_role.arn
#   }
# }