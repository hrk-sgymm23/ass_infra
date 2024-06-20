resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.name_tag
  }
}

# module "vpc_endpoint_security_group" {
#   source              = "../sg"
#   security_group_name = "vpc-endpoint-security-group"
#   vpc_id              = module.ass_vpc_stg.id
#   cidr_blocks         = [module.ass_vpc_stg.cidr_block]
#   port                = 443
# }