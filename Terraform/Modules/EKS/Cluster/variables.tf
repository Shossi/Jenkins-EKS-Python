variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_role_arn" {
  description = "IAM role ARN for the EKS cluster"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the EKS cluster"
  type        = list(string)
}

variable "endpoint_public_access" {
  description = "Enable public access to the EKS API"
  type        = bool
  default     = true
}

variable "endpoint_private_access" {
  description = "Enable private access to the EKS API"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags for the EKS cluster"
  type        = map(string)
}
