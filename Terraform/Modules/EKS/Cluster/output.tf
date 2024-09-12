output "cluster_id" {
  description = "ID of the EKS cluster"
  value       = aws_eks_cluster.eks_cluster.id
}

output "cluster_endpoint" {
  description = "EKS API server endpoint"
  value       = aws_eks_cluster.eks_cluster.endpoint
}

output "cluster_auth" {
  value = aws_eks_cluster.eks_cluster.certificate_authority
}

output "cluster_name" {
  value = var.cluster_name
}

output "eks_version" {
  value = aws_eks_cluster.eks_cluster.version
}