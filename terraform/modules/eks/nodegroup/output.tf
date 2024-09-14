output "node_group_id" {
  description = "ID of the EKS node group"
  value       = aws_eks_node_group.eks_node_group.id
}

output "node_group_arn" {
  description = "ARN of the EKS node group"
  value       = aws_eks_node_group.eks_node_group.arn
}
