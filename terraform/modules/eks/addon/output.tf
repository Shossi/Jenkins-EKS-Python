output "addon_name" {
  description = "Name of the installed EKS add-on"
  value       = aws_eks_addon.this.addon_name
}

output "addon_version" {
  description = "Version of the installed EKS add-on"
  value       = aws_eks_addon.this.addon_version
}
