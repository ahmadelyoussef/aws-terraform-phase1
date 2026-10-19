
variable "vpc_id" {
  type = string
}

variable "alb_security_group_id" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "iam_instance_profile" {
  type = string
}

variable "private_subnet_1_id" {
  type = string
}

variable "private_subnet_2_id" {
  type = string
}

variable "target_group_arn" {
  type = string
}

variable "ec2_instance_type" {
  type = string
}