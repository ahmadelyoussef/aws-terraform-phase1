
# Public IP address of the standalone public EC2 instance.
output "public_ec2_ip" {
  description = "Public IP address of the public EC2 instance"
  value       = module.ec2.public_ec2_ip
}

# Private IP address of the standalone private EC2 instance.
output "private_ec2_ip" {
  description = "Private IP address of the private EC2 instance"
  value       = module.ec2.private_ec2_ip
}

# Public Elastic IP address of the NAT Gateway.
output "nat_gateway_public_ip" {
  description = "Public IP address of the NAT Gateway"
  value       = module.vpc.nat_gateway_public_ip
}

# Public DNS name of the Application Load Balancer.
output "alb_dns_name" {
  description = "Public DNS name of the ALB"
  value       = module.alb.alb_dns_name
}

# PostgreSQL RDS endpoint.
output "rds_endpoint" {
  description = "Connection endpoint of the PostgreSQL RDS instance"
  value       = module.rds.rds_endpoint
}
