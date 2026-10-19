output "asg_security_group_id" {
  value = aws_security_group.phase1_asg_sg.id
}

output "asg_name" {
  value = aws_autoscaling_group.phase1_asg.name
}