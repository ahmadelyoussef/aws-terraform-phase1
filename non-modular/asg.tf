
# =========================
# ASG EC2 SECURITY GROUP
# =========================

resource "aws_security_group" "phase1_asg_sg" {
  name        = "phase1-asg-sg"
  description = "Security group for ASG EC2 instances"
  vpc_id      = aws_vpc.phase1_vpc.id

  ingress {
    description     = "Allow HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.phase1_alb_sg.id]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "tf-phase1-asg-sg"
  }
}

# =========================
# LAUNCH TEMPLATE
# =========================

resource "aws_launch_template" "phase1_asg_lt" {
  name_prefix   = "phase1-asg-lt-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"

  vpc_security_group_ids = [
    aws_security_group.phase1_asg_sg.id
  ]

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_ssm_profile.name
  }
  # Publish EC2 metrics to CloudWatch every minute.
  # Detailed monitoring incurs additional charges.
  monitoring {
    enabled = true
  }

  user_data = base64encode(<<-EOF
  #!/bin/bash
  dnf install -y httpd
  systemctl enable httpd
  systemctl start httpd

  TOKEN=$(curl -s -X PUT \
    -H "X-aws-ec2-metadata-token-ttl-seconds: 60" \
    http://169.254.169.254/latest/api/token)

  INSTANCE_ID=$(curl -s \
    -H "X-aws-ec2-metadata-token: $TOKEN" \
    http://169.254.169.254/latest/meta-data/instance-id)

  AZ=$(curl -s \
    -H "X-aws-ec2-metadata-token: $TOKEN" \
    http://169.254.169.254/latest/meta-data/placement/availability-zone)

  echo "Hello from $INSTANCE_ID in $AZ" > /var/www/html/index.html
EOF
  )
}

# =========================
# AUTO SCALING GROUP
# =========================

resource "aws_autoscaling_group" "phase1_asg" {
  name             = "tf-phase1-asg"
  min_size         = 2
  max_size         = 4
  desired_capacity = 2

  vpc_zone_identifier = [
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id
  ]

  launch_template {
    id      = aws_launch_template.phase1_asg_lt.id
    version = "$Latest"
  }

  target_group_arns = [
    aws_lb_target_group.phase1_web_tg.arn
  ]

  health_check_type         = "ELB"
  health_check_grace_period = 300

  tag {
    key                 = "Name"
    value               = "tf-phase1-asg-ec2"
    propagate_at_launch = true
  }

  lifecycle {
    ignore_changes = [desired_capacity]
  }

  depends_on = [
    aws_route.private_nat_route,
    aws_route_table_association.private_subnet_1_assoc,
    aws_route_table_association.private_subnet_2_assoc
  ]
}

# =========================
# CPU AUTO SCALING POLICY
# =========================

resource "aws_autoscaling_policy" "phase1_cpu_scaling" {
  name                   = "phase1-cpu-scaling"
  autoscaling_group_name = aws_autoscaling_group.phase1_asg.name
  policy_type            = "TargetTrackingScaling"

  estimated_instance_warmup = 300

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 50.0
  }
}
