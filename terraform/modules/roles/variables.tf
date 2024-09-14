variable "role_name" {
  description = "Name of the IAM role"
  type        = string
}

variable "assume_role_policy" {
  description = "Assume role policy for the IAM role"
  type        = string
}

variable "policy_arns" {
  description = "List of IAM policies to attach to the role"
  type        = list(string)
}

variable "tags" {
  description = "Tags to assign to the role"
  type        = map(string)
  default     = {}
}
