variable "name_prefix" {
  description = "Prefix for resource naming"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC where subnets will be created"
  type        = string
}

variable "vpc_cidr_block" {
  description = "The CIDR block of the VPC (used for cidrsubnet calculations)"
  type        = string
}

variable "default_vpc_rt_id" {
  description = "The ID of the route table of the VPC"
  type        = string
}

variable "aws_region" {
  type = string
}
