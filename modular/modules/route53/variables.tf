
variable "domain_name" {
  description = "Domain name for the Route 53 hosted zone"
  type        = string
}

variable "alb_dns_name" {
  description = "DNS hostname of the Application Load Balancer"
  type        = string
}

variable "alb_zone_id" {
  description = "AWS-managed hosted zone ID of the ALB"
  type        = string
}
