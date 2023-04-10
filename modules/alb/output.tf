output "alb_sg_id" {
  description = "The security group id for alb"
  value = aws_security_group.lb_sg.id
}

output "alb_tg_arn" {
  description = "The arn of target group attached to this alb"
  value = aws_lb_target_group.ecs_tg.arn
}