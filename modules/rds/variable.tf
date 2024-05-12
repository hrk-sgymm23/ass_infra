variable "enviroment" {
  description = "Enviromet Name"
  type = string
}

variable "common_name" {
  description = "common_name"
  type = string
}

variable "parameter_group_family" {
  description = "Parameter Group Family"
  type = string
}

variable "engine_name" {
  description = "DB Engine Name"
  type = string
}

variable "major_engine_version" {
  description = "Major DB Engine Version"
  type = string
}

variable "engine_verdion" {
  description = "DB Engine Version"
  type = string
}

variable "db_instance_class" {
  description = "DB Instance Class"
  type = string
}

variable "db_name" {
  description = "DB Name"
  type = string
}

variable "db_user_name" {
  description = "DB User Name"
  type = string
}

variable "multi_az" {
  description = "DB Multi AZ"
  type = bool
}

variable "port" {
  description = "DB Port"
  type = number
}

variable "vpc_id" {
  description = "VPC Id"
  type = string
}

variable "private_subnet_ids" {
  description = "Private Subnet Ids Form DB Subnet Group"
  type        = list(string)
}

variable "cidr_blocks" {
  description = "Security Group Cidr Blocks"
  type = list(string)
}

variable "enabled_cloudwatch_logs_exports" {
  description = "enabled_cloudwatch_logs_exports"
  type = list(type)
}
