variable "enviroment" {
  description = "Enviromet Name"
  type        = string
}

variable "common_name" {
  description = "common_name"
  type        = string
}

variable "file_name" {
  description = "file_name"
  type        = string
}

variable "function_name" {
  description = "function_name"
  type        = string
}

variable "code_hash" {
  description = "function_name"
  type        = string
}

variable "handler" {
  description = "handler_name"
  type        = string
}

variable "environments_variables" {
  description = "environments_variables_for_lambda"
  type        = map(string)
  default     = {}
}