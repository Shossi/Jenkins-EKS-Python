module "jenkins_vpc" {
  source          = "../Modules/VPC"
  vpc_name        = "jenkins-vpc"
  cidr            = var.jenkins_vpc_cidr
  azs             = var.azs
  public_subnets  = var.jenkins_public_subnets
  private_subnets = var.jenkins_private_subnets
}

module "jenkins_security_group" {
  source      = "../Modules/SecurityGroup"
  description = "Security Group for Jenkins"
  ingress_rules = [
    { from_port = 22, to_port = 22, protocol = "tcp", security_groups = [module.bastion_security_group.security_group_id] },
    { from_port = 8080, to_port = 8080, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
    { from_port = 22, to_port = 22, protocol = "tcp", self = true }
  ]
  egress_rules = [
    { from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = ["0.0.0.0/0"] }
  ]
  name   = "Jenkins-SG"
  vpc_id = module.jenkins_vpc.vpc_id
}

module "bastion_security_group" {
  source      = "../Modules/SecurityGroup"
  description = "Security group for the Bastion Host."
  ingress_rules = [
    { from_port = 22, to_port = 22, protocol = "tcp", cidr_blocks = ["${chomp(data.http.ip.response_body)}/32"] }
  ]
  egress_rules = [
    { from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = ["0.0.0.0/0"] }
  ]
  name   = "Bastion-sg"
  vpc_id = module.jenkins_vpc.vpc_id
}

data "http" "ip" {
  url = "https://ipv4.icanhazip.com"
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file(var.public_key_path)
}

module "bastion_host" {
  source            = "../Modules/EC2"
  ami               = var.bastion_ami
  instance_name     = "Bastion"
  instance_type     = var.bastion_instance_type
  security_group_id = module.bastion_security_group.security_group_id
  subnet_id         = module.jenkins_vpc.public_subnet_ids[0]
  key_name          = aws_key_pair.deployer.key_name
}

module "jenkins_master" {
  source              = "../Modules/EC2"
  ami                 = var.jenkins_ami
  instance_name       = "Jenk-Master"
  instance_type       = var.jenkins_master_instance_type
  security_group_id   = module.jenkins_security_group.security_group_id
  subnet_id           = module.jenkins_vpc.private_subnet_ids[0]
  key_name            = aws_key_pair.deployer.key_name
  associate_public_ip = false
}


module "jenkins_agent" {
  source              = "../Modules/EC2"
  ami                 = var.jenkins_agent_ami
  instance_name       = "Jenk-Agent"
  instance_type       = var.jenkins_agent_instance_type
  security_group_id   = module.jenkins_security_group.security_group_id
  subnet_id           = module.jenkins_vpc.private_subnet_ids[0]
  key_name            = aws_key_pair.deployer.key_name
  associate_public_ip = false
}

module "jenkins_lb" {
  source             = "../Modules/LoadBalancer"
  lb_name            = var.jenkins_lb_name
  load_balancer_type = "application"
  internal           = false
  subnets            = module.jenkins_vpc.public_subnet_ids
  security_groups    = [module.jenkins_security_group.security_group_id]

  target_group_name = "jenkins-tg"
  target_port       = var.jenkins_lb_port
  target_protocol   = var.jenkins_lb_protocol
  vpc_id            = module.jenkins_vpc.vpc_id

  listener_port     = var.jenkins_lb_listener_port
  listener_protocol = var.jenkins_lb_protocol

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

