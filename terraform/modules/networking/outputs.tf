output "vpc_id" {
  value = aws_vpc.main.id
}

output "vpc_arn" {
  value = aws_vpc.main.arn
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "public_subnet_arns" {
  value = aws_subnet.public[*].arn
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "private_subnet_arns" {
  value = aws_subnet.private[*].arn
}

output "internet_gateway_id" {
  value = aws_internet_gateway.main.id
}

output "internet_gateway_arn" {
  value = aws_internet_gateway.main.arn
}

output "nat_gateway_ids" {
  value = aws_nat_gateway.main[*].id
}

output "nat_gateway_association_ids" {
  value = aws_nat_gateway.main[*].allocation_id
}

output "network_interface_ids" {
  value = aws_nat_gateway.main[*].network_interface_id
}

output "nat_gateway_public_ips" {
  value = aws_nat_gateway.main[*].public_ip
}

output "public_route_table_ids" {
  value = aws_route_table.public[*].id
}

output "public_route_table_arns" {
  value = aws_route_table.public[*].arn
}

output "private_route_table_ids" {
  value = aws_route_table.private[*].id
}

output "private_route_table_arns" {
  value = aws_route_table.private[*].arn
}
