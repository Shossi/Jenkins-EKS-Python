variable "azs" {
  description = "Availability Zones for the VPCs"
  type        = list(string)
  default     = ["eu-central-1a", "eu-central-1b"]
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

variable "jenkins_vpc_cidr" {
  description = "CIDR block for Jenkins VPC"
  type        = string
  default     = "10.10.0.0/16"
}

variable "eks_vpc_cidr" {
  description = "CIDR block for EKS VPC"
  type        = string
  default     = "10.100.0.0/16"
}

variable "environment" {
  description = "Environment name (dev, staging, production)"
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

variable "cluster_name" {
  description = "EKS Cluster Name"
  type        = string
}

variable "node_group_name" {
  description = "EKS Node Group Name"
  type        = string
}

variable "desired_size" {
  description = "Desired size of the EKS node group"
  type        = number
  default     = 2
}

variable "min_size" {
  description = "Minimum size of the EKS node group"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum size of the EKS node group"
  type        = number
  default     = 5
}

variable "jenkins_lb_name" {
  description = "Name of the Jenkins Load Balancer"
  type        = string
  default     = "jenkins-lb"
}

variable "jenkins_lb_port" {
  description = "Port for Jenkins Load Balancer"
  type        = number
  default     = 8080
}

variable "jenkins_lb_listener_port" {
  description = "Listener port for Jenkins Load Balancer"
  type        = number
  default     = 80
}

variable "eks_cluster_role_name" {
  description = "IAM Role for EKS Cluster"
  type        = string
  default     = "eks-cluster-role"
}

variable "eks_node_group_role_name" {
  description = "IAM Role for EKS Node Group"
  type        = string
  default     = "eks-node-group-role"
}

variable "vpc_peering_name" {
  description = "Name of the VPC peering connection"
  type        = string
  default     = "jenkins-to-eks"
}
