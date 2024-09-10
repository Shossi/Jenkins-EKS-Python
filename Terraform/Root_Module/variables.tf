variable "azs" {
  description = "Availability Zones"
  type        = list(string)
  default     = ["eu-central-1a", "us-west-1b"]
}

variable "jenkins_public_subnets" {
  description = "Public subnets for Jenkins"
  type        = list(string)
}

variable "jenkins_private_subnets" {
  description = "Private subnets for Jenkins"
  type        = list(string)
}

variable "eks_public_subnets" {
  description = "Public subnets for EKS"
  type        = list(string)
}

variable "eks_private_subnets" {
  description = "Private subnets for EKS"
  type        = list(string)
}

variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string
}

variable "environment" {
  description = "Environment (dev, staging, production)"
  type        = string
}

variable "jenkins_ami" {
  description = "AMI ID for Jenkins master"
  type        = string
}

variable "jenkins_agent_ami" {
  description = "AMI ID for Jenkins agent"
  type        = string
}

variable "bastion_ami" {
  description = "AMI ID for Bastion host"
  type        = string
}

variable "key_name" {
  description = "SSH Key Pair Name"
  type        = string
}

variable "cluster_name" {
  description = "EKS Cluster Name"
  type        = string
}

variable "node_group_name" {
  description = "EKS Node Group Name"
  type        = string
}

variable "desired_size" {
  description = "Desired size of EKS node group"
  type        = number
  default     = 1
}

variable "min_size" {
  description = "Minimum size of EKS node group"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum size of EKS node group"
  type        = number
  default     = 3
}
