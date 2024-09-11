variable "name" {
  description = "Release name"
  type        = string
}

variable "repository" {
  description = "Helm repository"
  type        = string
}

variable "chart" {
  description = "Helm chart name"
  type        = string
}

variable "vers" {
  description = "Helm chart version"
  type        = string
}

variable "namespace" {
  description = "Kubernetes namespace"
  type        = string
}

variable "create_namespace" {
  description = "Whether to create the namespace"
  type        = bool
  default     = true
}

variable "set" {
  description = "Helm set values"
  type        = map(string)
  default     = {}
}
