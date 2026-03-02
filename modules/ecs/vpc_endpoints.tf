

# Interface Endpoints: ECR API, ECR Docker, and CloudWatch Logs
resource "aws_vpc_endpoint" "interface_endpoints" {
  for_each = toset(["ecr.api", "ecr.dkr", "logs"])

  vpc_id = var.vpc_id
  # Dynamically uses the region from your provider
  service_name        = "com.amazonaws.${var.aws_region}.${each.key}"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  subnet_ids         = var.private_subnet_ids
  security_group_ids = [var.vpc_endpoints_sg_id]

}

# S3 Gateway Endpoint (Required for ECR image layer downloads)
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"

  # Attach to the route table used by your private subnets
  route_table_ids = [var.default_vpc_rt_id]

}