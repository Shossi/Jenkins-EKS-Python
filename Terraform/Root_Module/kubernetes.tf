
module "eks_vpc" {
  source          = "../Modules/VPC"
  vpc_name        = "eks-vpc"
  cidr            = var.eks_vpc_cidr
  azs             = var.azs
  public_subnets  = var.eks_public_subnets
  private_subnets = var.eks_private_subnets
}

module "eks_security_group" {
  source      = "../Modules/SecurityGroup"
  description = "Security Group for EKS"
  ingress_rules = [
    { from_port = 443, to_port = 443, protocol = "tcp", cidr_blocks = [module.eks_vpc.cidr_block] },
    { from_port = 1025, to_port = 65535, protocol = "tcp", cidr_blocks = [module.eks_vpc.cidr_block] }
  ]
  egress_rules = [
    { from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = ["0.0.0.0/0"] }
  ]
  name   = "EKS-SG"
  vpc_id = module.eks_vpc.vpc_id
}

module "eks_cluster" {
  source                  = "../Modules/EKS/Cluster"
  depends_on              = [module.eks_cluster_role]
  cluster_name            = var.cluster_name
  cluster_role_arn        = module.eks_cluster_role.role_arn
  subnet_ids              = module.eks_vpc.private_subnet_ids
  endpoint_public_access  = true
  endpoint_private_access = true

  tags = {
    Environment = var.environment
  }
}

module "eks_node_group" {
  source          = "../Modules/EKS/NodeGroup"
  depends_on      = [module.eks_node_group_role]
  cluster_name    = module.eks_cluster.cluster_id
  node_group_name = var.node_group_name
  node_role_arn   = module.eks_node_group_role.role_arn
  subnet_ids      = module.eks_vpc.private_subnet_ids
  desired_size    = var.desired_size
  min_size        = var.min_size
  max_size        = var.max_size
  instance_types  = ["t2.small"]
  tags            = {}
}

module "eks_addon_vpc_cni" {
  source       = "../Modules/EKS/Addon"
  depends_on   = [module.eks_node_group]
  cluster_name = module.eks_cluster.cluster_id
  addon_name   = "vpc-cni"
  k8s_version  = module.eks_cluster.eks_version

  tags = {
    Environment = var.environment
  }
}

module "eks_addons_kube_proxy" {
  source       = "../Modules/EKS/Addon"
  depends_on   = [module.eks_node_group]
  cluster_name = module.eks_cluster.cluster_id
  addon_name   = "kube-proxy"
  k8s_version  = module.eks_cluster.eks_version

  tags = {
    Environment = var.environment
  }
}

module "eks_addons_coredns" {
  source       = "../Modules/EKS/Addon"
  depends_on   = [module.eks_node_group]
  cluster_name = module.eks_cluster.cluster_id
  addon_name   = "coredns"
  k8s_version  = module.eks_cluster.eks_version

  tags = {
    Environment = var.environment
  }
}

module "eks_cluster_role" {
  source    = "../Modules/Roles"
  role_name = "eks-cluster-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "eks.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
  policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  ]
}

module "eks_node_group_role" {
  source    = "../Modules/Roles"
  role_name = "eks-node-group-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
  policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  ]
}

module "nginx_ingress_controller" {
  source           = "../Modules/EKS/Helm"
  depends_on       = [module.eks_cluster]
  name             = "nginx-ingress"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  vers             = "4.11.0"
  namespace        = "ingress-nginx"
  create_namespace = true

  set = {
    "controller.service.type"                                                                            = "LoadBalancer"
    "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-backend-protocol" = "http"
    "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type"             = "nlb"
    "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-ssl-ports"        = "443"
    "controller.admissionWebhooks.enabled"                                                               = "false"
  }
}

module "argocd" {
  source     = "../Modules/EKS/Helm"
  depends_on = [module.eks_cluster]
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  vers       = "4.5.2"
  namespace  = "argocd"
}