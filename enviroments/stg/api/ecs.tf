module "ecs_stg" {
  source                    = "../../../modules/ecs"
  common_name               = var.common_name
  vpc_id                    = module.ass_vpc_stg.id
  cidr_blocks               = [module.ass_vpc_stg.cidr_block]
  private_subnet_ids        = module.ass_sbunet_stg.private_subnet_ids
  target_group_arn          = module.alb_stg.target_group_arn
  desired_count             = 1
  cpu                       = 256
  memory                    = 512
  ecs_nginx_tag             = "LATEST"
  ecs_rails_tag             = "LATEST"
  rails_ecr_arn             = module.rails_ecr_stg.arn
  nginx_ecr_arn             = module.nginx_ecr_stg.arn
  ssm_db_password_path      = module.ssm_db_password_path
  ssm_db_username_path      = module.ssm_db_user_name_path
  ssm_db_name_path          = module.ssm_db_name_path
  ssm_db_host_path          = module.ssm_db_host_path
  ssm_db_port_path          = module.ssm_db_port_path
  ssm_rails_master_key_path = data.aws_ssm_paramater.rails_master_key
  enviroment                = var.environment
}

data "aws_ssm_paramater" "rails_master_key" {
  name = "/${var.common_name}-${var.enviroment}/rails-master-key"
}