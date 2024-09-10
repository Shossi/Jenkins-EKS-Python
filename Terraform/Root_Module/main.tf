module "jenkins_vpc" {
  source            = "../Modules/VPC"
  vpc_name          = "jenkins-vpc"
  cidr              = var.jenkins_vpc_cidr
  azs               = var.azs
  public_subnets    = var.jenkins_public_subnets
  private_subnets   = var.jenkins_private_subnets
}

module "eks_vpc" {
  source  = "../Modules/VPC"
  vpc_name = "eks-vpc"
  cidr     = var.eks_vpc_cidr
  azs      = var.azs
  public_subnets  = var.eks_public_subnets
  private_subnets = var.eks_private_subnets
}

data "aws_caller_identity" "current" {}

resource "aws_vpc_peering_connection" "jenkins_eks" {
  vpc_id        = module.jenkins_vpc.vpc_id
  peer_vpc_id   = module.eks_vpc.vpc_id
  peer_owner_id = data.aws_caller_identity.current.account_id
  auto_accept   = true

  tags = {
    Name = var.vpc_peering_name
  }
}

resource "aws_route" "jenkins_to_eks" {
  route_table_id         = module.jenkins_vpc.public_route_table_id
  destination_cidr_block = module.eks_vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.jenkins_eks.id
}

resource "aws_route" "eks_to_jenkins" {
  route_table_id         = module.eks_vpc.public_route_table_id
  destination_cidr_block = module.jenkins_vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.jenkins_eks.id
}

module "eks_security_group" {
  source = "../Modules/SecurityGroup"
  description = "Security Group for EKS"
  ingress_rules = [
    { from_port = 443, to_port = 443, protocol = "tcp", cidr_blocks = [module.eks_vpc.cidr_block] },
    { from_port = 1025, to_port = 65535, protocol = "tcp", cidr_blocks = [module.eks_vpc.cidr_block] }
  ]
  egress_rules = [
    { from_port = 0, to_port = 0, cidr_blocks = ["0.0.0.0/0"] }
  ]
  name = "EKS-SG"
  vpc_id = module.eks_vpc.vpc_id
}

module "jenkins_security_group" {
  source = "../Modules/SecurityGroup"
  description = "Security Group for Jenkins"
  ingress_rules = [
    { from_port = 22, to_port = 22, security_groups = [module.bastion_security_group.security_group_id] },
    { from_port = 8080, to_port = 8080 }
  ]
  egress_rules = [
    { from_port = 0, to_port = 0, cidr_blocks = ["0.0.0.0/0"] }
  ]
  name = "Jenkins-SG"
  vpc_id = module.jenkins_vpc.vpc_id
}

module "bastion_security_group" {
  source = "../Modules/SecurityGroup"
  description = "Security group for the Bastion Host."
  ingress_rules = [
    { from_port = 22, to_port = 22, cidr_blocks = ["${chomp(data.http.ip.response_body)}/32"] }
  ]
  egress_rules = [
    { from_port = 0, to_port = 0, cidr_blocks = ["0.0.0.0/0"] }
  ]
  name = "Bastion-sg"
  vpc_id = module.jenkins_vpc.vpc_id
}

data "http" "ip" {
  url = "https://ipv4.icanhazip.com"
}

module "bastion_host" {
  source = "../Modules/EC2"
  ami    = var.bastion_ami
  instance_name = "Bastion"
  instance_type = "t2.micro"
  security_group_id = module.bastion_security_group.security_group_id
  subnet_id = module.jenkins_vpc.public_subnet_ids[0]
}

module "jenkins_master" {
  source = "../Modules/EC2"
  ami    = var.jenkins_ami
  instance_name = "Jenk-Master"
  instance_type = "t3.large"
  security_group_id = module.jenkins_security_group.security_group_id
  subnet_id = module.jenkins_vpc.private_subnet_ids[0]
  key_name = var.key_name
}

module "jenkins_agent" {
  source = "../Modules/EC2"
  ami    = var.jenkins_agent_ami
  instance_name = "Jenk-Agent"
  instance_type = "t2.micro"
  security_group_id = module.jenkins_security_group.security_group_id
  subnet_id = module.jenkins_vpc.private_subnet_ids[0]
  iam_instance_profile = aws_iam_instance_profile.this.name
  key_name = var.key_name
}

module "eks_cluster" {
  source  = "../Modules/EKS/Cluster"
  cluster_name        = var.cluster_name
  cluster_role_arn    = module.eks_cluster_role.role_arn
  subnet_ids          = module.eks_vpc.private_subnet_ids
  endpoint_public_access  = true
  endpoint_private_access = true

  tags = {
    Environment = var.environment
  }
}

module "eks_node_group" {
  source  = "../Modules/EKS/NodeGroup"
  cluster_name        = module.eks_cluster.cluster_id
  node_group_name     = var.node_group_name
  node_role_arn       = module.eks_node_group_role.role_arn
  subnet_ids          = module.eks_vpc.private_subnet_ids
  desired_size        = var.desired_size
  min_size            = var.min_size
  max_size            = var.max_size
  instance_types      = ["t2.small"]
  tags = {}
}

module "eks_addon_vpc_cni" {
  source  = "../Modules/EKS/Addon"
  cluster_name    = module.eks_cluster.cluster_id
  addon_name      = "vpc-cni"
  addon_version   = var.vpc_cni_version

  tags = {
    Environment = var.environment
  }
}

module "eks_addons_kube_proxy" {
  source  = "../Modules/EKS/Addon"
  cluster_name    = module.eks_cluster.cluster_id
  addon_name      = "kube-proxy"
  addon_version   = var.kube_proxy_version

  tags = {
    Environment = var.environment
  }
}

module "eks_addons_coredns" {
  source  = "../Modules/EKS/Addon"
  cluster_name    = module.eks_cluster.cluster_id
  addon_name      = "coredns"
  addon_version   = var.coredns_version

  tags = {
    Environment = var.environment
  }
}

module "jenkins_agent_role" {
  source  = "../Modules/Roles"
  role_name         = "jenkins-agent-role"
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
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  ]
}

resource "aws_iam_instance_profile" "this" {
  name = "${module.jenkins_agent_role.role_name}-profile"
  role = module.jenkins_agent_role.role_name
}


module "eks_cluster_role" {
  source  = "../Modules/Roles"
  role_name         = "eks-cluster-role"
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
  source  = "../Modules/Roles"
  role_name         = "eks-node-group-role"
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
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ]
}

module "jenkins_lb" {
  source = "../Modules/LoadBalancer"
  lb_name            = var.jenkins_lb_name
  load_balancer_type = "application"
  internal           = false
  subnets            = module.jenkins_vpc.public_subnet_ids
  security_groups    = [module.jenkins_security_group.security_group_id]

  target_group_name  = "jenkins-tg"
  target_port        = var.jenkins_lb_port
  target_protocol    = "HTTP"
  vpc_id             = module.jenkins_vpc.vpc_id

  listener_port      = var.jenkins_lb_listener_port
  listener_protocol  = "HTTP"

  targets = {
    jenkins_master = {
      id   = module.jenkins_master.instance_id
      port = var.jenkins_lb_port
    }
  }

  tags = {
    Environment = var.environment
  }
}
