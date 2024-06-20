output "public_subnet_ids" {
  value = toset([
    for subnet in aws_subnet.public-subnet : subnet.id
  ])
}
output "private_subnet_ids" {
  value = toset([
    for subnet in aws_subnet.private-subnet : subnet.id
  ])
}

output "private_route_table_ids" {
  value = [for rt in aws_route_table.private : rt.id]
}