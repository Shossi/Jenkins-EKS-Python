variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "addon_name" {
  description = "Name of the add-on (e.g., CoreDNS, kube-proxy, vpc-cni)"
  type        = string
}

variable "addon_version" {
  description = "Version of the add-on"
  type        = string
}

variable "tags" {
  description = "Tags for the add-on resources"
  type        = map(string)
  default     = {}
}
