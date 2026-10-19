output "public_ec2_id" {
  description = "ID of the public EC2 instance"
  value       = aws_instance.public_ec2.id
}

output "private_ec2_id" {
  description = "ID of the private EC2 instance"
  value       = aws_instance.private_ec2.id
}

output "public_ec2_ip" {
  description = "Public IP address of the public EC2 instance"
  value       = aws_instance.public_ec2.public_ip
}

output "private_ec2_ip" {
  description = "Private IP address of the private EC2 instance"
  value       = aws_instance.private_ec2.private_ip
}