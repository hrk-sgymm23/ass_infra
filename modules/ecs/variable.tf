variable "common_name" {
  type        = string
  description = "common name"
}

variable "environment" {
  type        = string
  description = "enviroment name"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "cidr_blocks" {
  type        = list(string)
  description = "CIDR Blocks"
}

variable "private_subnet_ids" {
  description = "Private Subnet Ids Form DB Subnet Group"
  type        = list(string)
}

variable "target_group_arn" {
  description = "Target Group ARN"
  type        = string
}

variable "desired_count" {
  description = "ECS Task Count"
  type        = number
}

variable "cpu" {
  description = "ECS CPU"
  type        = string
}

variable "memory" {
  description = "ECS Memory"
  type        = string
}

variable "ecs_rails_tag" {
  description = "ECS Rails tag"
  type        = string
}

variable "ecs_nginx_tag" {
  description = "ECS Nginx Tag"
  type        = string
}

# variable "rails_ecr_arn" {
#   description = "Rails ECR ARN"
#   type        = string
# }

variable "rails_ecr_uri" {
  description = "Rails ECR URI"
  type        = string
}

# variable "nginx_ecr_arn" {
#   description = "Nginx ECR ARN"
#   type        = string
# }

variable "nginx_ecr_uri" {
  description = "Nginx ECR URI"
  type        = string
}

variable "ssm_db_password_path" {
  description = "aws_ssm_parameter.db_password.name"
  type        = string
}

variable "ssm_db_username_path" {
  description = "aws_ssm_parameter.db_username.name"
  type        = string
}

variable "ssm_db_port_path" {
  description = "aws_ssm_parameter.db_port.name"
  type        = string
}

variable "ssm_db_host_path" {
  description = "aws_ssm_parameter.db_host.name"
  type        = string
}

variable "ssm_db_name_path" {
  description = "aws_ssm_parameter.db_name.name"
  type        = string
}

variable "ssm_rails_master_key_path" {
  description = "data.aws_ssm_parameter.rails_master_key.name"
  type        = string
}