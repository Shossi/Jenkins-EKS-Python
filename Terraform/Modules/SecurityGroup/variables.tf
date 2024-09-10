variable "ingress_rules" {
  description = "List of ingress rules"
  type = list(object({
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = optional(list(string))
    security_groups  = optional(list(string), [])
    ipv6_cidr_blocks = optional(list(string), [])
    prefix_list_ids  = optional(list(string), [])
    self             = optional(bool)
  }))
}

variable "egress_rules" {
  description = "List of egress rules"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}

variable "name" {
  description = "Name of the Security Group"
  type        = string
}

variable "description" {
  description = "Description for the Security Group"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the Security Group will be created"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the Security Group"
  type        = map(string)
  default     = {}
}
