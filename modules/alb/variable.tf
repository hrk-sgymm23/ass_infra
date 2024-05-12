variable "common_name" {
  description = "common name"
  type        = string
}

variable "vpc_id" {
  description = "vpc id"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public Subnet Ids Form DB Subnet Group"
  type        = list(string)
}

# variable "aws_acm_certificate_arn" {
#   description = "aws acm arn"
#   type        = string
# }

# variable "acm_depends_on" {
#   description = "ACM Depends on"
#   type        = any
# }

variable "environment" {
  description = "env name"
  type        = string
}