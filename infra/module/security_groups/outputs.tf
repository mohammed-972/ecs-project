output "alb_security_group_id" {
  description = "ID of ALB sg - allows traffic from anywhere"
  value       = aws_security_group.alb.id
}

output "ecs_security_group_id" {
  description = "ID of ecs sg - allows traffic from ALB sg"
  value       = aws_security_group.ecs.id
}

