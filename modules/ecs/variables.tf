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
  default     = 5000

  validation {
    condition     = var.app_port > 0 && var.app_port <= 65535
    error_message = "The app_port must be a valid port number between 1 and 65535."
  }
}

variable "aws_region" {
  description = "The AWS region where resources will be deployed (e.g., eu-west-2)."
  type        = string
  # No default here forces the user to be intentional about the region.
}

variable "aws_account_id" {
  description = "The 12-digit AWS Account ID."
  type        = string

  validation {
    condition     = can(regex("^\\d{12}$", var.aws_account_id))
    error_message = "The aws_account_id must be exactly 12 digits."
  }
}

variable "default_vpc_rt_id" {
  type = string
  
}

variable "ecs_tasks_sg_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "aws_lb_target_group_arn" {
  type = string
}

variable "vpc_id" {
  description = "The ID of the VPC where subnets will be created"
  type        = string
}

variable "vpc_endpoints_sg_id" {
  type = string
}