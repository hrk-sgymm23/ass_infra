variable "name_tag" {
  default     = null
  description = "Name Tag"
  type        = string
  nullable    = true
}

variable "cidr_block" {
  description = "cidr_block"
  type        = string
}