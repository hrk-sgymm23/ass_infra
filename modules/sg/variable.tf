variable "security_group_name" {
  type        = string
  description = "SecurityGroup Name"
}

variable "vpc_id" {
  type        = string
  description = "VPC id"
}

variable "port" {
  type        = number
  description = "Permit ConnectionPort"
}

variable "cidr_blocks" {
  type        = list(string)
  description = "CIDR Block List "
}