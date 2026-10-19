variable "vpc_id" {
  type = string
}

variable "private_subnet_1_id" {
  type = string
}

variable "private_subnet_2_id" {
  type = string
}

variable "asg_security_group_id" {
  type = string
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