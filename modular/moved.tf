
# ========================================
# VPC MODULE
# ========================================

moved {
  from = aws_vpc.phase1_vpc
  to   = module.vpc.aws_vpc.phase1_vpc
}

moved {
  from = aws_subnet.public_subnet_1
  to   = module.vpc.aws_subnet.public_subnet_1
}

moved {
  from = aws_subnet.public_subnet_2
  to   = module.vpc.aws_subnet.public_subnet_2
}

moved {
  from = aws_subnet.private_subnet_1
  to   = module.vpc.aws_subnet.private_subnet_1
}

moved {
  from = aws_subnet.private_subnet_2
  to   = module.vpc.aws_subnet.private_subnet_2
}

moved {
  from = aws_internet_gateway.phase1_igw
  to   = module.vpc.aws_internet_gateway.phase1_igw
}

moved {
  from = aws_route_table.public_rt
  to   = module.vpc.aws_route_table.public_rt
}

moved {
  from = aws_route.public_internet_route
  to   = module.vpc.aws_route.public_internet_route
}

moved {
  from = aws_route_table_association.public_subnet_1_assoc
  to   = module.vpc.aws_route_table_association.public_subnet_1_assoc
}

moved {
  from = aws_route_table_association.public_subnet_2_assoc
  to   = module.vpc.aws_route_table_association.public_subnet_2_assoc
}

moved {
  from = aws_eip.nat_eip
  to   = module.vpc.aws_eip.nat_eip
}

moved {
  from = aws_nat_gateway.phase1_nat
  to   = module.vpc.aws_nat_gateway.phase1_nat
}

moved {
  from = aws_route_table.private_rt
  to   = module.vpc.aws_route_table.private_rt
}

moved {
  from = aws_route.private_nat_route
  to   = module.vpc.aws_route.private_nat_route
}

moved {
  from = aws_route_table_association.private_subnet_1_assoc
  to   = module.vpc.aws_route_table_association.private_subnet_1_assoc
}

moved {
  from = aws_route_table_association.private_subnet_2_assoc
  to   = module.vpc.aws_route_table_association.private_subnet_2_assoc
}


# ========================================
# EC2 MODULE
# ========================================

moved {
  from = aws_security_group.public_ec2_sg
  to   = module.ec2.aws_security_group.public_ec2_sg
}

moved {
  from = aws_security_group.private_ec2_sg
  to   = module.ec2.aws_security_group.private_ec2_sg
}

moved {
  from = aws_instance.public_ec2
  to   = module.ec2.aws_instance.public_ec2
}

moved {
  from = aws_instance.private_ec2
  to   = module.ec2.aws_instance.private_ec2
}


# ========================================
# ALB MODULE
# ========================================

# ALB Security Group
moved {
  from = aws_security_group.phase1_alb_sg
  to   = module.alb.aws_security_group.phase1_alb_sg
}

# Application Load Balancer
moved {
  from = aws_lb.phase1_alb
  to   = module.alb.aws_lb.phase1_alb
}

# Target Group
moved {
  from = aws_lb_target_group.phase1_web_tg
  to   = module.alb.aws_lb_target_group.phase1_web_tg
}

# HTTP Listener
moved {
  from = aws_lb_listener.phase1_http_listener
  to   = module.alb.aws_lb_listener.phase1_http_listener
}

# HTTPS Listener
moved {
  from = aws_lb_listener.phase1_https
  to   = module.alb.aws_lb_listener.phase1_https
}


# ========================================
# ASG MODULE
# ========================================

moved {
  from = aws_security_group.phase1_asg_sg
  to   = module.asg.aws_security_group.phase1_asg_sg
}

moved {
  from = aws_launch_template.phase1_asg_lt
  to   = module.asg.aws_launch_template.phase1_asg_lt
}

moved {
  from = aws_autoscaling_group.phase1_asg
  to   = module.asg.aws_autoscaling_group.phase1_asg
}

moved {
  from = aws_autoscaling_policy.phase1_cpu_scaling
  to   = module.asg.aws_autoscaling_policy.phase1_cpu_scaling
}


# ========================================
# RDS MODULE
# ========================================

moved {
  from = aws_db_subnet_group.phase1_db_subnet_group
  to   = module.rds.aws_db_subnet_group.phase1_db_subnet_group
}

moved {
  from = aws_security_group.rds_sg
  to   = module.rds.aws_security_group.rds_sg
}

moved {
  from = aws_db_instance.phase1_postgres
  to   = module.rds.aws_db_instance.phase1_postgres
}


# ========================================
# CLOUDWATCH MODULE
# ========================================

moved {
  from = aws_sns_topic.phase1_cpu_alerts
  to   = module.cloudwatch.aws_sns_topic.phase1_cpu_alerts
}

moved {
  from = aws_sns_topic_subscription.phase1_cpu_email
  to   = module.cloudwatch.aws_sns_topic_subscription.phase1_cpu_email
}

moved {
  from = aws_cloudwatch_metric_alarm.phase1_high_cpu
  to   = module.cloudwatch.aws_cloudwatch_metric_alarm.phase1_high_cpu
}

moved {
  from = aws_cloudwatch_log_group.phase1_apache_logs
  to   = module.cloudwatch.aws_cloudwatch_log_group.phase1_apache_logs
}

moved {
  from = aws_ssm_parameter.cloudwatch_agent_config
  to   = module.cloudwatch.aws_ssm_parameter.cloudwatch_agent_config
}


# ========================================
# IAM MODULE
# ========================================

# IAM Role
moved {
  from = aws_iam_role.ec2_ssm_role
  to   = module.iam.aws_iam_role.ec2_ssm_role
}

# Systems Manager Policy Attachment
moved {
  from = aws_iam_role_policy_attachment.ssm_policy
  to   = module.iam.aws_iam_role_policy_attachment.ssm_policy
}

# CloudWatch Agent Policy Attachment
moved {
  from = aws_iam_role_policy_attachment.cloudwatch_agent_policy
  to   = module.iam.aws_iam_role_policy_attachment.cloudwatch_agent_policy
}

# IAM Instance Profile
moved {
  from = aws_iam_instance_profile.ec2_ssm_profile
  to   = module.iam.aws_iam_instance_profile.ec2_ssm_profile
}


# ========================================
# ACM MODULE
# ========================================

# ACM Certificate
moved {
  from = aws_acm_certificate.phase1_cert
  to   = module.acm.aws_acm_certificate.phase1_cert
}

# Route 53 DNS Validation Records
moved {
  from = aws_route53_record.phase1_cert_validation
  to   = module.acm.aws_route53_record.phase1_cert_validation
}

# ACM Certificate Validation
moved {
  from = aws_acm_certificate_validation.phase1_validation
  to   = module.acm.aws_acm_certificate_validation.phase1_validation
}


# ========================================
# ROUTE 53 MODULE
# ========================================

# Route 53 Hosted Zone
moved {
  from = aws_route53_zone.phase1_zone
  to   = module.route53.aws_route53_zone.phase1_zone
}

# Root Domain Alias Record
moved {
  from = aws_route53_record.phase1_root
  to   = module.route53.aws_route53_record.phase1_root
}

# WWW Domain Alias Record
moved {
  from = aws_route53_record.phase1_www
  to   = module.route53.aws_route53_record.phase1_www
}
