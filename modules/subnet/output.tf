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