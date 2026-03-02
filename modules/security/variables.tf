variable "name_prefix" {
  description = "A short prefix used for all resource names (e.g., 'acme-web'). Max 10 chars recommended."
  type        = string
  
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.name_prefix))
    error_message = "The name_prefix must be lowercase, alphanumeric, and can contain hyphens."
  }
}

variable "app_port" {
  description = "The internal port the container listens on (e.g., 5000 for Flask)."
  type        = number

  validation {
    condition     = var.app_port > 0 && var.app_port <= 65535
    error_message = "The app_port must be a valid port number between 1 and 65535."
  }
}

variable "vpc_id" {
  description = "The ID of the VPC where subnets will be created"
  type        = string
}