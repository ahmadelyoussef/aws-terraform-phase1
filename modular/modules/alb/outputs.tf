output "alb_dns_name" {
  value = aws_lb.phase1_alb.dns_name
}

output "alb_zone_id" {
  value = aws_lb.phase1_alb.zone_id
}

output "target_group_arn" {
  value = aws_lb_target_group.phase1_web_tg.arn
}

output "alb_sg_id" {
  value = aws_security_group.phase1_alb_sg.id
}