resource "aws_iam_role" "main" {
  name                = var.role_name
  description         = var.role_description
  assume_role_policy  = var.assume_role_policy
  managed_policy_arns = var.managed_policy_arns
}

resource "aws_iam_policy" "main" {
  count = length(var.policy_names)

  name        = element(var.policy_names, count.index)
  description = element(var.policy_descriptions, count.index)
  policy      = element(var.policy_documents, count.index)
}

resource "aws_iam_role_policy_attachment" "main" {
  count = length(var.policy_names)

  role       = aws_iam_role.main.name
  policy_arn = aws_iam_policy.main.*.arn[count.index]
}
