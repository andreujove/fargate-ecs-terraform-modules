# Existing IAM Role existing in the exam account: 
data "aws_iam_role" "task_ecs" {
  name = "ecsTaskExecutionRole"
}

resource "aws_ecs_cluster" "main" {
  name = "${var.name_prefix}-ecs-cluster"
}

resource "aws_ecs_task_definition" "app" {
  family                   = "${var.name_prefix}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "1024"
  memory                   = "2048"

  # Ensure these IAM roles have 'ecs-tasks.amazonaws.com' in their Trust Policy
  execution_role_arn = data.aws_iam_role.task_ecs.arn
  task_role_arn      = data.aws_iam_role.task_ecs.arn

  container_definitions = jsonencode([
    {
      name      = "${var.name_prefix}-app"
      image     = "${var.aws_account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/tp-flask-app:1.0.0"
      essential = true

      # logConfiguration = {
      #   logDriver = "awslogs"
      #   options = {
      #     "awslogs-group"         = aws_cloudwatch_log_group.ecs_log_group.name
      #     "awslogs-region"        = var.aws_region
      #     "awslogs-stream-prefix" = "ecs"
      #   }
      # }

      portMappings = [
        {
          containerPort = var.app_port # Using variable for consistency
          hostPort      = var.app_port
          protocol      = "tcp"
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "main" {
  name            = "${var.name_prefix}-ecs-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  # Wait for the application to boot before starting health checks
  health_check_grace_period_seconds = 60

  network_configuration {
    security_groups  = [var.ecs_tasks_sg_id]
    subnets          = var.private_subnet_ids # Modern splat syntax
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.aws_lb_target_group_arn # Use .arn instead of .id
    container_name   = "${var.name_prefix}-app"
    container_port   = var.app_port
  }

  lifecycle {
    ignore_changes = [
      task_definition, # Prevents Terraform from reverting version changes made by CI/CD
      desired_count    # Prevents Terraform from fighting with Auto Scaling
    ]
  }

  depends_on = [
    aws_vpc_endpoint.interface_endpoints,
    aws_vpc_endpoint.s3
  ]
}

# Unable to create resources:
# resource "aws_cloudwatch_log_group" "ecs_log_group" {
#   name              = "/ecs/${var.name_prefix}-log-group"
#   retention_in_days = 7 # Increased slightly; 1 day is very short for debugging
# }

# Note: aws_cloudwatch_log_stream is usually handled automatically by ECS 
# when using 'awslogs-stream-prefix', but keeping it here doesn't hurt.
# resource "aws_cloudwatch_log_stream" "ecs_log_stream" {
#   name           = "${var.name_prefix}-log-stream"
#   log_group_name = aws_cloudwatch_log_group.ecs_log_group.name
# }