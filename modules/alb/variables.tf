variable "name_prefix" {
  description = "A short prefix used for all resource names (e.g., 'acme-web'). Max 10 chars recommended."
  type        = string
  
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.name_prefix))
    error_message = "The name_prefix must be lowercase, alphanumeric, and can contain hyphens."
  }
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "alb_security_group_id" {
  type = string
}

variable "vpc_id" {
  description = "The ID of the VPC where subnets will be created"
  type        = string
}