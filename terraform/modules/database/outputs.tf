output "security_group_id" {
  value = aws_security_group.main.id
}

output "security_group_arn" {
  value = aws_security_group.main.arn
}

output "rds_address" {
  value = aws_db_instance.main.address
}

output "rds_arn" {
  value = aws_db_instance.main.arn
}

output "rds_endpoint" {
  value = aws_db_instance.main.endpoint
}

output "rds_instance_id" {
  value = aws_db_instance.main.id
}

