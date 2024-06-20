output "ssm_db_password_path" {
  value = aws_ssm_parameter.db_password.name
}

output "ssm_db_username_path" {
  value = aws_ssm_parameter.db_username.name
}

output "ssm_db_port_path" {
  value = aws_ssm_parameter.db_port.name
}

output "ssm_db_host_path" {
  value = aws_ssm_parameter.host.name
}

output "ssm_db_name_path" {
  value = aws_ssm_parameter.db_name.name
}