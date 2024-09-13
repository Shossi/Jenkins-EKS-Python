module "apache_vpc" {
  source          = "../modules/vpc"
  vpc_name        = "apache-vpc"
  cidr            = var.apache_vpc_cidr
  azs             = var.azs
  public_subnets  = var.apache_public_subnets
  private_subnets = var.apache_private_subnets
}

module "apache_Sec_group" {
  source      = "../modules/securitygroup"
  description = "Security Group for Apache"
  ingress_rules = [
    { from_port = 80, to_port = 80, protocol = "tcp", cidr_blocks = ["91.231.246.50/32"] },
#    { from_port = 80, to_port = 80, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] }
  ]
  egress_rules = [
    { from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = ["0.0.0.0/0"] }
  ]
  name   = "Apache-SG"
  vpc_id = module.apache_vpc.vpc_id
}

module "apache_instance" {
  source            = "../modules/ec2"
  ami               = "ami-0b6c6d3707776c98d"
  instance_name     = "Apache-Server"
  instance_type     = "t2.micro"
  user_data         = file("../../configuration/apache.sh")
  security_group_id = module.apache_Sec_group.security_group_id
  subnet_id         = module.apache_vpc.public_subnet_ids[0]
  associate_eip     = true
}
