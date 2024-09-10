terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.5.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.6.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
  required_version = ">= 1.0.0"
  backend "s3" {
    bucket  = "terraform-yossi-state"
    key     = "global/s3/jenkins-eks/terraform.tfstate"
    region  = "eu-west-3"
    encrypt = true
  }
}

provider "aws" {
  region = "eu-central-1"
}

provider "helm" {
  kubernetes {
    host                   = module.eks_cluster.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks_cluster.cluster_auth[0].data)
    token                  = data.aws_eks_cluster_auth.auth.token
  }
}

provider "kubernetes" {
  host                   = module.eks_cluster.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks_cluster.cluster_auth[0].data)
  token                  = data.aws_eks_cluster_auth.auth.token
}

variable "public_key_path" {
  description = "Path to the SSH public key"
  type        = string
  default     = "/home/yossi/.ssh/new_key.pub"
}

data "aws_eks_cluster_auth" "auth" {
  name = module.eks_cluster.cluster_name
}
