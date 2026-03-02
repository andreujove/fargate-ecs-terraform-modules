output "alb_hostname" {
  description = "The fully qualified URL of the Load Balancer"
  value       = aws_lb.main.dns_name
}

output "aws_lb_target_group_arn" {
  description = "The ARN of the ECS Target Group for service attachment"
  value       = aws_lb_target_group.ecs_tg.arn
}