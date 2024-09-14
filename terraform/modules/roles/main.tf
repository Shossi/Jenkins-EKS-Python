resource "aws_iam_role" "this" {
  name               = var.role_name
  assume_role_policy = var.assume_role_policy

  tags = merge(var.tags, { Name = var.role_name })
}

resource "aws_iam_role_policy_attachment" "this" {
  count      = length(var.policy_arns)
  policy_arn = var.policy_arns[count.index]
  role       = aws_iam_role.this.name
}
