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
  ecs_nginx_tag             = "stg"
  ecs_rails_tag             = "stg"
  rails_ecr_uri             = module.rails_ecr_stg.image_uri
  nginx_ecr_uri             = module.nginx_ecr_stg.image_uri
  ssm_db_password_path      = module.ass_rds_stg.ssm_db_password_path
  ssm_db_username_path      = module.ass_rds_stg.ssm_db_username_path
  ssm_db_name_path          = module.ass_rds_stg.ssm_db_name_path
  ssm_db_host_path          = module.ass_rds_stg.ssm_db_host_path
  ssm_db_port_path          = module.ass_rds_stg.ssm_db_port_path
  ssm_rails_master_key_path = data.aws_ssm_parameter.rails_master_key.name
  environment               = var.environment
}

data "aws_ssm_parameter" "rails_master_key" {
  name = "/${var.common_name}-${var.environment}/rails-master-key"
}