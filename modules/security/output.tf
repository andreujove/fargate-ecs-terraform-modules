output "ecs_tasks_sg_id" {
  description = "The ID of the Security Group attached to the ECS Tasks"
  value       = aws_security_group.ecs_tasks.id
}

output "alb_security_group_id" {
  value = aws_security_group.lb.id
}

output "vpc_endpoints_sg_id" {
  value = aws_security_group.vpc_endpoints.id
}