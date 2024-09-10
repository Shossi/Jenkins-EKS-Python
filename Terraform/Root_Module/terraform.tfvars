jenkins_vpc_cidr =  "10.10.0.0/16"
jenkins_public_subnets   = ["10.10.1.0/24", "10.10.2.0/24"]
jenkins_private_subnets  = ["10.10.3.0/24", "10.10.4.0/24"]

jenkins_vpc_cidr =  "10.100.0.0/16"
eks_public_subnets       = ["10.100.1.0/24", "10.100.2.0/24"]
eks_private_subnets      = ["10.100.3.0/24", "10.100.4.0/24"]

environment              = "dev"

jenkins_ami              = "ami-0e04bcbe83a83792e"
jenkins_agent_ami        = "ami-0e04bcbe83a83792e"
bastion_ami              = "ami-0e04bcbe83a83792e"

key_name                 = "my-ssh-key"

cluster_name             = "eks-cluster-dev"
node_group_name          = "eks-node-group-dev"
