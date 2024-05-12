# RDSパラメーターグループ
resource "aws_db_parameter_group" "main" {
  name = "${var.common_name}-${var.enviroment}"
  family = var.parameter_group_family
}

# DBオプショングループ
resource "aws_db_option_group" "main" {
  name = "${var.common_name}-${var.enviroment}"
  engine_name = var.engine_name
  major_engine_version = var.major_engine_version
}

# サブネット　for RDS
resource "aws_db_subnet_group" "main" {
  name = "${var.common_name}-subnet-${var.enviroment}"
  subnet_ids = var.private_subnet_ids
}

# RDS Instance


# SecurityGroup


# SSM
