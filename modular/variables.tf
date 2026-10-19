# =========================
# AWS PROVIDER
# =========================

variable "aws_region" {
  description = "AWS region for our infrastructure"
  type        = string
}

variable "aws_profile" {
  description = "AWS CLI profile"
  type        = string
}

# =========================
# ENVIRONMENT
# =========================

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

# =========================
# VPC
# =========================

variable "vpc_cidr" {
  type = string
}

# =========================
# PUBLIC SUBNETS
# =========================

variable "public_subnet_1_cidr" {
  type = string
}

variable "public_subnet_2_cidr" {
  type = string
}

# =========================
# PRIVATE SUBNETS
# =========================

variable "private_subnet_1_cidr" {
  type = string
}

variable "private_subnet_2_cidr" {
  type = string
}

# =========================
# AVAILABILITY ZONES
# =========================

variable "availability_zone_1" {
  type = string
}

variable "availability_zone_2" {
  type = string
}

variable "ec2_instance_type" {
  description = "Instance type for standalone EC2 instances"
  type        = string
}

variable "db_identifier" {
  description = "AWS identifier of the RDS database instance"
  type        = string
}

variable "db_name" {
  description = "Initial PostgreSQL database name"
  type        = string
}

variable "db_instance_class" {
  description = "Instance class of the RDS database"
  type        = string
}

variable "db_allocated_storage" {
  description = "Allocated database storage in GiB"
  type        = number
}

variable "db_username" {
  description = "Master username for the PostgreSQL database"
  type        = string
}
variable "alert_email" {
  type        = string
  description = "Email address for CloudWatch CPU alerts"
}

variable "cpu_threshold" {
  description = "CPU utilization percentage that triggers the CloudWatch alarm"
  type        = number
}


variable "domain_name" {
  description = "Domain name for the Route 53 hosted zone"
  type        = string
}