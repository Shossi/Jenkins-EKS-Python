output "security_group_id" {
  description = "ID of the created Security Group"
  value       = aws_security_group.sec_group.id
}
