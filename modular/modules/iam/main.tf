
# =========================
# IAM ROLE FOR EC2
# =========================

resource "aws_iam_role" "ec2_ssm_role" {
  name = "tf-phase1-ec2-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "tf-phase1-ec2-ssm-role"
  }
}

# =========================
# ATTACH SSM MANAGED POLICY
# =========================

resource "aws_iam_role_policy_attachment" "ssm_policy" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# =========================
# ATTACH CLOUDWATCH AGENT POLICY
# =========================

resource "aws_iam_role_policy_attachment" "cloudwatch_agent_policy" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# =========================
# INSTANCE PROFILE
# =========================

resource "aws_iam_instance_profile" "ec2_ssm_profile" {
  name = "tf-phase1-ec2-ssm-profile"
  role = aws_iam_role.ec2_ssm_role.name
}
