output "alb_hostname" {
  description = "The fully qualified URL of the Load Balancer"
  value = "http://${aws_lb.main.dns_name}"
}

output "aws_lb_target_group_arn" {
    value = aws_lb_target_group.ecs_tg.arn
}