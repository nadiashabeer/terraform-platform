output "instance_ids" {
  description = "List of instance IDs"
  value       = aws_instance.main[*].id
}

output "instance_private_ips" {
  description = "List of private IP addresses"
  value       = aws_instance.main[*].private_ip
}

output "instance_public_ips" {
  description = "List of public IP addresses"
  value       = var.associate_public_ip ? aws_instance.main[*].public_ip : []
}

output "security_group_id" {
  description = "Security group ID for EC2 instances"
  value       = aws_security_group.ec2.id
}

output "security_group_arn" {
  description = "ARN of the security group"
  value       = aws_security_group.ec2.arn
}
