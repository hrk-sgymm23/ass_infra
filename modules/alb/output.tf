output "target_group_arn" {
  value = aws_lb_target_group.main.arn
}

output "dns_name" {
  value = aws_lb.main.dns_name
}

output "zone_id" {
  value = aws_lb.main.zone_id
}