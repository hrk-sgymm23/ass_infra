# RDSパラメーターグループ
resource "aws_db_parameter_group" "main" {
  name   = "${var.common_name}-${var.enviroment}"
  family = var.parameter_group_family
}

# DBオプショングループ
resource "aws_db_option_group" "main" {
  name                 = "${var.common_name}-${var.enviroment}"
  engine_name          = var.engine
  major_engine_version = var.major_engine_version
}

# サブネット　for RDS
resource "aws_db_subnet_group" "main" {
  name       = "${var.common_name}-subnet-${var.enviroment}"
  subnet_ids = var.private_subnet_ids
}

# RDS Instance
resource "aws_db_instance" "main" {
  identifier                      = "${var.common_name}-${var.enviroment}"
  db_name                         = replace(var.db_name, "-", "_")
  instance_class                  = var.db_instance_class
  engine                          = var.engine
  engine_version                  = var.engine_version
  allocated_storage               = 20
  max_allocated_storage           = 20
  storage_type                    = "gp2"
  storage_encrypted               = true
  username                        = replace(var.db_user_name, "-", "_")
  password                        = random_password.rds.result
  publicly_accessible             = false
  backup_window                   = "09:10-09:40"
  backup_retention_period         = 7
  maintenance_window              = "mon:10:10-mon:10:40"
  auto_minor_version_upgrade      = true
  deletion_protection             = false
  skip_final_snapshot             = false
  final_snapshot_identifier       = "${var.common_name}-snapshot-${var.enviroment}"
  port                            = var.port
  apply_immediately               = false
  vpc_security_group_ids          = [module.rds_security_group.security_group_id]
  parameter_group_name            = aws_db_parameter_group.main.name
  option_group_name               = aws_db_option_group.main.name
  db_subnet_group_name            = aws_db_subnet_group.main.name
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  lifecycle {
    ignore_changes = [password]
  }
  # monitoring_interval = 60
  # monitoring_role_arn = 
}

resource "random_password" "rds" {
  length  = 10
  special = false
}

# SecurityGroup
module "rds_security_group" {
  source              = "../sg"
  security_group_name = "${var.common_name}-rds-security-group"
  vpc_id              = var.vpc_id
  port                = var.port
  cidr_blocks         = var.cidr_blocks
}

# SSM
resource "aws_ssm_parameter" "db_username" {
  name        = "/${var.common_name}-${var.enviroment}/db/username"
  type        = "SecureString"
  value       = aws_db_instance.main.username
  description = "DBUserName"
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "db_password" {
  name        = "/${var.common_name}-${var.enviroment}/db/password"
  type        = "SecureString"
  value       = aws_db_instance.main.password
  description = "DBPassword"
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "db_port" {
  name        = "/${var.common_name}-${var.enviroment}/db/port"
  type        = "SecureString"
  value       = aws_db_instance.main.port
  description = "DBPort"
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "host" {
  name        = "/${var.common_name}-${var.enviroment}/db/host"
  type        = "SecureString"
  value       = replace(aws_db_instance.main.endpoint, ":${var.port}", "")
  description = "DBHost"
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "db_name" {
  name        = "/${var.common_name}-${var.enviroment}/db/name"
  type        = "SecureString"
  value       = aws_db_instance.main.identifier
  description = "DBName"
  lifecycle {
    ignore_changes = [value]
  }
}
