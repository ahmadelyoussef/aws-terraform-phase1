output "public_ec2_ip" {
  value = aws_instance.public_ec2.public_ip
}

output "private_ec2_ip" {
  value = aws_instance.private_ec2.private_ip
}

output "nat_gateway_public_ip" {
  value = aws_eip.nat_eip.public_ip
}
output "alb_dns_name" {
  description = "Public DNS name of the ALB"
  value       = aws_lb.phase1_alb.dns_name
}

output "rds_endpoint" {
  value = aws_db_instance.phase1_postgres.endpoint
}
