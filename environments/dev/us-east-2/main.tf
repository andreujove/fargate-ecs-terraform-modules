data "aws_vpc" "default" {
  default = true
}

data "aws_route_table" "default_vpc_rt" {
  vpc_id = data.aws_vpc.default.id

  filter {
    name   = "association.main"
    values = ["true"]
  }
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

module "ecr" {
  source            = "../../../modules/ecr"
  name_prefix       = var.name_prefix
  environment       = var.environment
  image_mutability  = var.image_mutability
}
 
module "security" {
  source            = "../../../modules/security"
  name_prefix       = var.name_prefix
  vpc_id            = data.aws_vpc.default.id
  app_port          = var.app_port
}

module "network" {
  source              = "../../../modules/network"
  name_prefix         = var.name_prefix
  vpc_id              = data.aws_vpc.default.id
  vpc_cidr_block      = data.aws_vpc.default.cidr_block
  default_vpc_rt_id   = data.aws_route_table.default_vpc_rt.id
  aws_region          = data.aws_region.current.name
}

module "alb" {
  source              = "../../../modules/alb"
  depends_on = [
    module.network,
    module.security
  ]

  name_prefix               = var.name_prefix
  public_subnet_ids         = module.network.public_subnet_ids
  alb_security_group_id     = module.security.alb_security_group_id
  vpc_id                    = data.aws_vpc.default.id
}

module "ecs" {
  depends_on = [
    module.network,
    module.security,
    module.alb
  ]
  source                    = "../../../modules/ecs"
  name_prefix               = var.name_prefix
  app_port                  = var.app_port
  aws_region                = data.aws_region.current.name
  aws_account_id            = data.aws_caller_identity.current.account_id
  vpc_id                    = data.aws_vpc.default.id
  default_vpc_rt_id         = data.aws_route_table.default_vpc_rt.id
  ecs_tasks_sg_id           = module.security.ecs_tasks_sg_id
  private_subnet_ids        = module.network.private_subnet_ids
  aws_lb_target_group_arn   = module.alb.aws_lb_target_group_arn
  vpc_endpoints_sg_id       = module.security.vpc_endpoints_sg_id
}