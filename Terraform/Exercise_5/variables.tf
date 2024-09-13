variable "associate_eip" {
  description = "Control whether an Elastic IP should be associated with the instance"
  type        = bool
  default     = true
}

variable "associate_public_ip" {
  description = "Whether to associate a public IP"
  type        = bool
  default     = true
}

variable "apache_public_subnets" {
  description = "Public subnets for apache"
  type        = list(string)
  default = ["10.181.242.0/25"]
}

variable "apache_private_subnets" {
  description = "Private subnets for apache"
  type        = list(string)
  default = ["10.181.242.128/25"]
}

variable "azs" {
  description = "Availability Zones for the VPCs"
  type        = list(string)
  default     = ["eu-central-1a", "eu-central-1b"]
}

variable "apache_vpc_cidr" {
  description = "CIDR block for apache VPC"
  type        = string
  default     = "10.181.242.0/24"
}