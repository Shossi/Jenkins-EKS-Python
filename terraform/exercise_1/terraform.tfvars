# Jenkins VPC configuration
jenkins_vpc_cidr        = "10.10.0.0/16"
jenkins_public_subnets  = ["10.10.1.0/24", "10.10.2.0/24"]
jenkins_private_subnets = ["10.10.3.0/24", "10.10.4.0/24"]

# EKS VPC configuration
eks_vpc_cidr        = "10.100.0.0/16"
eks_public_subnets  = ["10.100.1.0/24", "10.100.2.0/24"]
eks_private_subnets = ["10.100.3.0/24", "10.100.4.0/24"]

# General environment variables
environment = "dev"

# AMI IDs
jenkins_ami       = "ami-0b6c6d3707776c98d" # Jenkins master AMI
jenkins_agent_ami = "ami-0d18c15e6412e4cbb" # Jenkins agent AMI
bastion_ami       = "ami-0e04bcbe83a83792e" # Bastion host AMI (Ubuntu 24)

# EKS Cluster and Node Group configuration
cluster_name    = "eks-cluster-dev"
node_group_name = "eks-node-group-dev"

# Other default values
# desired_size      = 2
# min_size          = 2
# max_size          = 5
# jenkins_lb_name   = "jenkins-lb"
# jenkins_lb_port   = 8080
# jenkins_lb_listener_port = 8080
# jenkins_lb_protocol        = "HTTP"
# eks_cluster_role_name = "eks-cluster-role"
# eks_node_group_role_name = "eks-node-group-role"
# public_key_path   = "/home/yossi/.ssh/new_key.pub"
# jenkins_master_instance_type = "t3.large"
# jenkins_agent_instance_type  = "t2.micro"
# bastion_instance_type        = "t2.micro"





