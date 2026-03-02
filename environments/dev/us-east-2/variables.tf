variable "name_prefix" {
  type        = string
  description = "A prefix used for naming all resources in this project (e.g., 'flask-prod')."
}

variable "environment" {
  type        = string
  description = "The deployment environment (e.g., 'dev', 'staging', 'prod')."

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "The environment variable must be one of: dev, staging, prod."
  }
}

variable "image_mutability" {
  type        = string
  default     = "MUTABLE"
  description = "Determines if images in ECR can be overwritten. Use 'IMMUTABLE' for production to prevent version hijacking."

  validation {
    condition     = contains(["MUTABLE", "IMMUTABLE"], var.image_mutability)
    error_message = "The image_mutability must be either 'MUTABLE' or 'IMMUTABLE'."
  }
}

variable "app_port" {
  type        = number
  default     = 5000
  description = "The internal port the container listens on (e.g., 5000 for Flask)."
}

variable "aws_profile" {
  type = string
}