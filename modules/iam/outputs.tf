output "role_arns" {
  description = "Map of role names to their ARNs"
  value = {
    for role_name, role in aws_iam_role.main : 
    role_name => role.arn
  }
}

output "role_ids" {
  description = "Map of role names to their IDs"
  value = {
    for role_name, role in aws_iam_role.main : 
    role_name => role.id
  }
}

output "instance_profile_names" {
  description = "Map of EC2 role names to their instance profile names"
  value = {
    for profile_name, profile in aws_iam_instance_profile.main : 
    profile_name => profile.name
  }
}

output "instance_profile_arns" {
  description = "Map of EC2 role names to their instance profile ARNs"
  value = {
    for profile_name, profile in aws_iam_instance_profile.main : 
    profile_name => profile.arn
  }
}
