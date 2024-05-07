variable "availability_zones" {
  type        = list(string)
  default     = ["ap-northeast-1a", "ap-northeast-1c"]
  description = "Availability Zone List"
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "vpc_cidr_block" {
  description = "VPC CIDR BLOCK"
  type        = string
}