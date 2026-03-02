resource "aws_lb" "main" {
  name               = "${var.name_prefix}-alb"
  internal           = false
  load_balancer_type = "application"

  # References your specific security group name
  security_groups = [var.alb_security_group_id]

  # References the public subnets we created earlier
  subnets = var.public_subnet_ids

  enable_deletion_protection = false
}

resource "aws_lb_target_group" "ecs_tg" {
  name        = "${var.name_prefix}-tg"
  port        = 5000 # Flask app port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id # Matches your data source
  target_type = "ip"                        # Required for Fargate

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    matcher             = "200"
    path                = "/"
    port                = "traffic-port" # Means "use port 5000"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }

}

resource "aws_lb_listener" "web" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80 # Public entry point
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_tg.arn
  }

}