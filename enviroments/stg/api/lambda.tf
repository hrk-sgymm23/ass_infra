locals {
  subnet_list = tolist(module.ass_sbunet_stg.public_subnet_ids)
}

# NATGW開始用lambda
data "archive_file" "natgw_start" {
  type        = "zip"
  source_dir  = "lambda_function/natgw_start/src"
  output_path = "lambda/natgw_start/src/test_terraform.zip"
}

module "natgateway_start_func" {
  enviroment    = var.environment
  common_name   = var.common_name
  source        = "../../../modules/lambda"
  file_name     = data.archive_file.natgw_start.output_path
  code_hash     = data.archive_file.natgw_start.output_base64sha256
  function_name = "${var.common_name}-natgw-start-func-${var.environment}"
  handler       = "main.handler"
  environments_variables = {
    SubnetId1       = local.subnet_list[0],
    SubnetId2       = local.subnet_list[1],
    RouteTableId    = module.ass_sbunet_stg.public_route_table_id
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
  enviroment    = var.environment
  common_name   = var.common_name
  source        = "../../../modules/lambda"
  file_name     = data.archive_file.natgw_stop.output_path
  code_hash     = data.archive_file.natgw_stop.output_base64sha256
  function_name = "${var.common_name}-natgw-stop-func-${var.environment}"
  handler       = "main.handler"
  environments_variables = {
    SubnetId1       = local.subnet_list[0],
    SubnetId2       = local.subnet_list[1],
    RouteTableId    = module.ass_sbunet_stg.public_route_table_id
    NatGatewayName1 = "${var.common_name}-Nat-GW-${var.environment}-1"
    NatGatewayName2 = "${var.common_name}-Nat-GW-${var.environment}-2"
  }
}

# NATGW用EventBridge用IAMリソース群


# NATGW用EventBridgeリソース群
# 開始、終了時刻をlocalsで定義

# 開始


# 終了