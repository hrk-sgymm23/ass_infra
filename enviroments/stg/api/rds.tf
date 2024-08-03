module "ass_rds_stg" {
  enviroment                      = var.environment
  source                          = "../../../modules/rds"
  common_name                     = var.common_name
  parameter_group_family          = "mysql8.0"
  engine                          = "mysql"
  major_engine_version            = "8.0"
  engine_version                  = "8.0"
  db_instance_class               = "db.t3.micro"
  db_name                         = "${var.common_name}-rds-${var.environment}"
  db_user_name                    = var.service
  multi_az                        = true
  port                            = 3306
  vpc_id                          = module.ass_vpc_stg.id
  cidr_blocks                     = [module.ass_vpc_stg.cidr_block]
  private_subnet_ids              = module.ass_sbunet_stg.private_subnet_ids
  enabled_cloudwatch_logs_exports = ["error", "general", "slowquery"]
}