output "alb_hostname" {
  description = "The fully qualified URL of the Load Balancer"
  value = "http://${module.alb.alb_hostname}"
}
