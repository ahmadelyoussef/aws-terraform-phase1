
# =========================
# EC2 INSTANCE TYPE
# =========================

variable "ec2_instance_type" {
  description = "Instance type for standalone EC2 instances"
  type        = string
}

# =========================
# VPC
# =========================

variable "vpc_id" {
  description = "VPC ID from the VPC module"
  type        = string
}

# =========================
# SUBNETS
# =========================

variable "public_subnet_1_id" {
  description = "Public subnet ID for public EC2"
  type        = string
}

variable "private_subnet_2_id" {
  description = "Private subnet ID for private EC2"
  type        = string
}

# =========================
# AMI
# =========================

variable "ami_id" {
  description = "Amazon Linux AMI ID"
  type        = string
}

# =========================
# IAM INSTANCE PROFILE
# =========================

variable "iam_instance_profile" {
  description = "IAM instance profile name for SSM access"
  type        = string
}
