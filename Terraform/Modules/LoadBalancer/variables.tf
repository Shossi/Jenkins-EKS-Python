variable "lb_name" {
  description = "Name of the Load Balancer"
  type        = string
}

variable "load_balancer_type" {
  description = "Type of Load Balancer to create ('application' for ALB, 'network' for NLB)"
  type        = string
  default     = "application"
}

variable "internal" {
  description = "Whether the load balancer is internal"
  type        = bool
  default     = false
}

variable "subnets" {
  description = "List of subnet IDs to attach to the Load Balancer"
  type        = list(string)
}

variable "security_groups" {
  description = "Security groups for the load balancer (only applicable for ALB)"
  type        = list(string)
  default     = []
}

variable "enable_deletion_protection" {
  description = "Enable deletion protection for the load balancer"
  type        = bool
  default     = false
}

# Target Group variables
variable "target_group_name" {
  description = "Name of the target group"
  type        = string
}

variable "target_port" {
  description = "Port for the target group"
  type        = number
}

variable "target_protocol" {
  description = "Protocol for the target group (HTTP, HTTPS, TCP, etc.)"
  type        = string
}

variable "target_type" {
  description = "Type of target (instance, ip, lambda)"
  type        = string
  default     = "instance"
}

variable "vpc_id" {
  description = "VPC ID for the target group"
  type        = string
}

# Health check variables
variable "health_check_interval" {
  description = "Time between health checks"
  type        = number
  default     = 30
}

variable "health_check_path" {
  description = "Path to ping for health check"
  type        = string
  default     = "/"
}

variable "health_check_port" {
  description = "Port for health check"
  type        = string
  default     = "traffic-port"
}

variable "health_check_protocol" {
  description = "Protocol for health check (HTTP, HTTPS, TCP)"
  type        = string
  default     = "HTTP"
}

variable "healthy_threshold" {
  description = "Number of successful health checks before marking the target as healthy"
  type        = number
  default     = 3
}

variable "unhealthy_threshold" {
  description = "Number of failed health checks before marking the target as unhealthy"
  type        = number
  default     = 3
}

# Listener variables
variable "listener_port" {
  description = "Port for the listener (e.g., 80 for HTTP, 443 for HTTPS)"
  type        = number
}

variable "listener_protocol" {
  description = "Protocol for the listener (HTTP, HTTPS, TCP, etc.)"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the Load Balancer"
  type        = map(string)
  default     = {}
}

variable "targets" {
  description = "List of targets for the Load Balancer (instance IDs and ports)"
  type = map(object({
    id   = string
    port = number
  }))
  default = {}
}
