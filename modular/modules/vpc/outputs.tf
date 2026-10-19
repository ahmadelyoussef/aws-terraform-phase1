# =========================
# VPC OUTPUT
# =========================

output "vpc_id" {
  value = aws_vpc.phase1_vpc.id
}

# =========================
# PUBLIC SUBNET OUTPUTS
# =========================

output "public_subnet_1_id" {
  value = aws_subnet.public_subnet_1.id
}

output "public_subnet_2_id" {
  value = aws_subnet.public_subnet_2.id
}

# =========================
# PRIVATE SUBNET OUTPUTS
# =========================

output "private_subnet_1_id" {
  value = aws_subnet.private_subnet_1.id
}

output "private_subnet_2_id" {
  value = aws_subnet.private_subnet_2.id
}

# Public Elastic IP address of the NAT Gateway.
output "nat_gateway_public_ip" {
  description = "Public Elastic IP address of the NAT Gateway"
  value       = aws_eip.nat_eip.public_ip
}
