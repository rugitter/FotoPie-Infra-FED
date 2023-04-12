output "alb_sg_id" {
  description = "The security group id for alb"
  value = aws_security_group.lb_sg.id
}

output "alb_tg_arn" {
  description = "The arn of target group attached to this alb"
  value = aws_lb_target_group.ecs_tg.arn
}

output "alb_dns" {
  description = "The DNS name of alb for filling into Route53"
  value = aws_lb.main.dns_name
}

output "alb_zone_id" {
  description = "The Zone id of alb"
  value = aws_lb.main.zone_id
}