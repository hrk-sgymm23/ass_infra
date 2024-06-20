# locals {
#   ass_cidr_block = "172.10.0.0/16"
# }

module "ass_vpc_stg" {
  source     = "../../../modules/vpc"
  cidr_block = "172.10.0.0/16"
}

module "ass_sbunet_stg" {
  source         = "../../../modules/subnet"
  vpc_id         = module.ass_vpc_stg.id
  vpc_cidr_block = module.ass_vpc_stg.cidr_block
}

# VPCエンドポイントリソース群
module "vpc_endpoint_security_group" {
  source              = "../../../modules/sg"
  security_group_name = "vpc-endpoint-security-group"
  vpc_id              = module.ass_vpc_stg.id
  cidr_blocks         = [module.ass_vpc_stg.cidr_block]
  port                = 443
}

# S3
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = module.ass_vpc_stg.id
  service_name      = "com.amazonaws.ap-northeast-1.s3"
  vpc_endpoint_type = "Gateway"
}

resource "aws_vpc_endpoint_route_table_association" "s3" {
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
  for_each        = toset(module.ass_sbunet_stg.private_route_table_ids)
  route_table_id  = each.value
}

#　DKR
resource "aws_vpc_endpoint" "dkr" {
  vpc_id            = module.ass_vpc_stg.id
  service_name      = data.aws_vpc_endpoint_service.dkr.service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = [module.vpc_endpoint_security_group.security_group_id]
  subnet_ids          = module.ass_sbunet_stg.private_subnet_ids
  private_dns_enabled = true
}

data "aws_vpc_endpoint_service" "dkr" {
  service = "ecr.dkr"
}

resource "aws_vpc_endpoint" "api" {
  vpc_id            = module.ass_vpc_stg.id
  service_name      = data.aws_vpc_endpoint_service.api.service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = [module.vpc_endpoint_security_group.security_group_id]
  subnet_ids          = module.ass_sbunet_stg.private_subnet_ids
  private_dns_enabled = true
}

data "aws_vpc_endpoint_service" "api" {
  service = "ecr.api"
}

# logs
resource "aws_vpc_endpoint" "logs" {
  vpc_id            = module.ass_vpc_stg.id
  service_name      = data.aws_vpc_endpoint_service.logs.service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = [module.vpc_endpoint_security_group.security_group_id]
  subnet_ids          = module.ass_sbunet_stg.private_subnet_ids
  private_dns_enabled = true
}

data "aws_vpc_endpoint_service" "logs" {
  service = "logs"
}

resource "aws_vpc_endpoint" "ssm" {
  vpc_id              = module.ass_vpc_stg.id
  service_name        = "com.amazonaws.ap-northeast-1.ssm"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids  = [module.vpc_endpoint_security_group.security_group_id]
  subnet_ids          = module.ass_sbunet_stg.private_subnet_ids
}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id              = module.ass_vpc_stg.id
  service_name        = "com.amazonaws.ap-northeast-1.ssmmessages"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids  = [module.vpc_endpoint_security_group.security_group_id]
  subnet_ids          = module.ass_sbunet_stg.private_subnet_ids
}
