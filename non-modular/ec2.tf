
# =========================
# PUBLIC EC2 SECURITY GROUP
# =========================

resource "aws_security_group" "public_ec2_sg" {
  name        = "phase1-public-ec2-sg"
  description = "Security group for public EC2"
  vpc_id      = aws_vpc.phase1_vpc.id

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
  vpc_id      = aws_vpc.phase1_vpc.id

  ingress {
    description     = "Allow HTTP from public EC2"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.public_ec2_sg.id]
  }
  # we didn't need ingress rules for http. We can leave it empty.

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
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public_subnet_1.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.public_ec2_sg.id]

  iam_instance_profile = aws_iam_instance_profile.ec2_ssm_profile.name

  user_data = <<-EOF
    #!/bin/bash
    dnf install -y httpd
    systemctl enable httpd
    systemctl start httpd
    echo "Hello from Public EC2!" > /var/www/html/index.html
  EOF

  depends_on = [
    aws_route.public_internet_route,
    aws_route_table_association.public_subnet_1_assoc
  ]

  tags = {
    Name = "tf-phase1-public-ec2"
  }
}

# =========================
# PRIVATE EC2
# =========================

resource "aws_instance" "private_ec2" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.private_subnet_2.id
  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.private_ec2_sg.id]

  iam_instance_profile = aws_iam_instance_profile.ec2_ssm_profile.name

  user_data = <<-EOF
    #!/bin/bash
    dnf install -y httpd
    systemctl enable httpd
    systemctl start httpd
    echo "Hello from Private EC2!" > /var/www/html/index.html
  EOF

  depends_on = [
    aws_route.private_nat_route,
    aws_route_table_association.private_subnet_2_assoc
  ]

  tags = {
    Name = "tf-phase1-private-ec2"
  }
}
