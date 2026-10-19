
# =========================
# PUBLIC EC2 SECURITY GROUP
# =========================

resource "aws_security_group" "public_ec2_sg" {
  name        = "phase1-public-ec2-sg"
  description = "Security group for public EC2"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "tf-phase1-public-ec2-sg"
  }
}

# =========================
# PRIVATE EC2 SECURITY GROUP
# =========================

resource "aws_security_group" "private_ec2_sg" {
  name        = "phase1-private-ec2-sg"
  description = "Security group for private EC2"
  vpc_id      = var.vpc_id

  # No inbound rules required for this lab.

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "tf-phase1-private-ec2-sg"
  }
}

# =========================
# PUBLIC EC2
# =========================

resource "aws_instance" "public_ec2" {
  ami                         = var.ami_id
  instance_type               = var.ec2_instance_type
  subnet_id                   = var.public_subnet_1_id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.public_ec2_sg.id]

  iam_instance_profile = var.iam_instance_profile

  user_data = <<-EOF
    #!/bin/bash
    dnf install -y httpd
    systemctl enable httpd
    systemctl start httpd
    echo "Hello from Public EC2!" > /var/www/html/index.html
  EOF

  tags = {
    Name = "tf-phase1-public-ec2"
  }
}

# =========================
# PRIVATE EC2
# =========================

resource "aws_instance" "private_ec2" {
  ami                         = var.ami_id
  instance_type               = var.ec2_instance_type
  subnet_id                   = var.private_subnet_2_id
  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.private_ec2_sg.id]

  iam_instance_profile = var.iam_instance_profile

  user_data = <<-EOF
    #!/bin/bash
    dnf install -y httpd
    systemctl enable httpd
    systemctl start httpd
    echo "Hello from Private EC2!" > /var/www/html/index.html
  EOF

  tags = {
    Name = "tf-phase1-private-ec2"
  }
}
