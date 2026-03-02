output "public_subnet_ids" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "List of IDs of private subnets"
  value       = aws_subnet.private[*].id
}

output "igw_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.gw.id
}

