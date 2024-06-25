# module "alb_stg" {
#   source            = "../../../modules/alb"
#   common_name       = var.common_name
#   vpc_id            = module.ass_vpc_stg.id
#   public_subnet_ids = module.ass_sbunet_stg.public_subnet_ids
#   environment       = var.environment
# }