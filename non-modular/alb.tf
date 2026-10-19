
# 1. ALB Security Group
resource "aws_security_group" "phase1_alb_sg" {
  name        = "tf-phase1-alb-sg"
  description = "Security group for ALB"
  vpc_id      = aws_vpc.phase1_vpc.id

  # Allow HTTP from the internet
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTPS from the internet
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow outbound traffic to EC2 targets
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "tf-phase1-alb-sg"
  }
}
# 2. Application Load Balancer

resource "aws_lb" "phase1_alb" {
  name               = "tf-phase1-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.phase1_alb_sg.id
  ]

  subnets = [
    aws_subnet.public_subnet_1.id,
    aws_subnet.public_subnet_2.id
  ]
}
# ALB: Doesn't need internet connectivity during startup to install software. 
# Explicit depends_on is generally unnecessary

# 3. Target Group
resource "aws_lb_target_group" "phase1_web_tg" {
  name        = "tf-phase1-web-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.phase1_vpc.id
  target_type = "instance"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    port                = "traffic-port"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 30
    timeout             = 5
  }
}

# 4. HTTP Listener
resource "aws_lb_listener" "phase1_http_listener" {
  load_balancer_arn = aws_lb.phase1_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
# Create an HTTPS listener on port 443.
# Attach the ACM certificate after validation.
# Forward HTTPS requests to our existing target group.

resource "aws_lb_listener" "phase1_https" {
  load_balancer_arn = aws_lb.phase1_alb.arn
  port              = 443
  protocol          = "HTTPS"

  certificate_arn = aws_acm_certificate_validation.phase1_validation.certificate_arn

  ssl_policy = "ELBSecurityPolicy-TLS13-1-2-2021-06"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.phase1_web_tg.arn
  }
}


# 5. ALB DNS Output

# Register Public EC2
# resource "aws_lb_target_group_attachment" "public_ec2" {
#   target_group_arn = aws_lb_target_group.phase1_web_tg.arn
#   target_id        = aws_instance.public_ec2.id
#   port             = 80
# }

# # Register Private EC2
# resource "aws_lb_target_group_attachment" "private_ec2" {
#   target_group_arn = aws_lb_target_group.phase1_web_tg.arn
#   target_id        = aws_instance.private_ec2.id
#   port             = 80
# }