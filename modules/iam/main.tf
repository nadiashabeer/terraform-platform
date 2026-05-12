# IAM Roles
resource "aws_iam_role" "main" {
  for_each = { for role in var.roles : role.name => role }

  name        = "${var.project_name}-${var.environment}-${each.value.name}"
  description = each.value.description

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = each.value.policy_type == "ec2" ? "ec2.amazonaws.com" : "ssm.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(
    {
      Name        = "${var.project_name}-${var.environment}-${each.value.name}"
      Project     = var.project_name
      Environment = var.environment
    },
    var.tags
  )
}

# AWS Managed Policy Attachments
resource "aws_iam_role_policy_attachment" "managed_policies" {
  for_each = {
    for combo in flatten([
      for role_name, role in var.roles : [
        for policy in role.aws_managed_policies : {
          role_name = role_name
          policy    = policy
        }
      ]
    ]) : "${combo.role_name}-${combo.policy}" => combo
  }

  role       = aws_iam_role.main[each.value.role_name].name
  policy_arn = each.value.policy
}

# Custom Inline Policies
resource "aws_iam_role_policy" "inline_policies" {
  for_each = {
    for combo in flatten([
      for role_name, role in var.roles : [
        for policy in role.inline_policies : {
          role_name   = role_name
          policy_name = policy.name
          policy_json = policy.policy
        }
      ]
    ]) : "${combo.role_name}-${combo.policy_name}" => combo
  }

  name   = "${var.project_name}-${var.environment}-${each.value.role_name}-${each.value.policy_name}"
  role   = aws_iam_role.main[each.value.role_name].id
  policy = each.value.policy_json
}

# Instance Profile for EC2 Roles
resource "aws_iam_instance_profile" "main" {
  for_each = {
    for role in var.roles : role.name => role 
    if role.policy_type == "ec2"
  }

  name = "${var.project_name}-${var.environment}-${each.value.name}-profile"
  role = aws_iam_role.main[each.key].name
}