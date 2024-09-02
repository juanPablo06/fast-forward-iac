output "policy_arns" {
  value = aws_iam_policy.main.*.arn
}

output "policy_ids" {
  value = aws_iam_policy.main.*.id
}

output "role_arn" {
  value = aws_iam_role.main.arn
}

output "role_id" {
  value = aws_iam_role.main.id
}

output "role_name" {
  value = aws_iam_role.main.name
}
