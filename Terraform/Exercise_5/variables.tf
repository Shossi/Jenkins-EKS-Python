variable "associate_eip" {
  description = "Control whether an Elastic IP should be associated with the instance"
  type        = bool
  default     = true # Default to true to assign an EIP
}

variable "associate_public_ip" {
  description = "Whether to associate a public IP"
  type        = bool
  default     = true
}

variable "apache_public_subnets" {
  description = "Public subnets for apache"
  type        = list(string)
}

variable "apache_private_subnets" {
  description = "Private subnets for apache"
  type        = list(string)
}

variable "azs" {
  description = "Availability Zones for the VPCs"
  type        = list(string)
  default     = ["eu-central-1a", "eu-central-1b"]
}

variable "apache_vpc_cidr" {
  description = "CIDR block for apache VPC"
  type        = string
  default     = "10.10.0.0/16"
}
apache_public_subnets  = ["10.10.1.0/24", "10.10.2.0/24"]
apache_private_subnets = ["10.10.3.0/24", "10.10.4.0/24"]