# =========================
# AMAZON LINUX 2023 AMI
# =========================

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

# =========================
# VPC MODULE
# =========================

module "vpc" {
  source = "./modules/vpc"

  vpc_cidr              = var.vpc_cidr
  public_subnet_1_cidr  = var.public_subnet_1_cidr
  public_subnet_2_cidr  = var.public_subnet_2_cidr
  private_subnet_1_cidr = var.private_subnet_1_cidr
  private_subnet_2_cidr = var.private_subnet_2_cidr

  availability_zone_1 = var.availability_zone_1
  availability_zone_2 = var.availability_zone_2
}

# =========================
# EC2 MODULE
# =========================

module "ec2" {
  source = "./modules/ec2"

  ec2_instance_type = var.ec2_instance_type

  vpc_id              = module.vpc.vpc_id
  public_subnet_1_id  = module.vpc.public_subnet_1_id
  private_subnet_2_id = module.vpc.private_subnet_2_id

  ami_id               = data.aws_ami.amazon_linux.id
  iam_instance_profile = module.iam.instance_profile_name

  depends_on = [module.vpc, module.iam]
}

# =========================
# ALB MODULE
# =========================

module "alb" {
  source = "./modules/alb"

  vpc_id             = module.vpc.vpc_id
  public_subnet_1_id = module.vpc.public_subnet_1_id
  public_subnet_2_id = module.vpc.public_subnet_2_id

  acm_certificate_arn = module.acm.certificate_arn
}

# =========================
# ASG MODULE
# =========================

module "asg" {
  source = "./modules/asg"

  vpc_id                = module.vpc.vpc_id
  alb_security_group_id = module.alb.alb_sg_id

  ami_id               = data.aws_ami.amazon_linux.id
  iam_instance_profile = module.iam.instance_profile_name

  private_subnet_1_id = module.vpc.private_subnet_1_id
  private_subnet_2_id = module.vpc.private_subnet_2_id

  target_group_arn  = module.alb.target_group_arn
  ec2_instance_type = var.ec2_instance_type

  depends_on = [module.vpc, module.iam]
}

# =========================
# RDS MODULE
# =========================

module "rds" {
  source = "./modules/rds"

  vpc_id                = module.vpc.vpc_id
  private_subnet_1_id   = module.vpc.private_subnet_1_id
  private_subnet_2_id   = module.vpc.private_subnet_2_id
  asg_security_group_id = module.asg.asg_security_group_id

  db_identifier        = var.db_identifier
  db_name              = var.db_name
  db_instance_class    = var.db_instance_class
  db_allocated_storage = var.db_allocated_storage
  db_username          = var.db_username
}
# =========================
# CLOUDWATCH MODULE
# =========================


module "cloudwatch" {
  source = "./modules/cloudwatch"

  asg_name      = module.asg.asg_name
  alert_email   = var.alert_email
  cpu_threshold = var.cpu_threshold
}

# =========================
# IAM MODULE
# =========================

module "iam" {
  source = "./modules/iam"
}

# =========================
# ACM MODULE
# =========================

module "acm" {
  source      = "./modules/acm"
  zone_id     = module.route53.zone_id
  domain_name = var.domain_name
}

# =========================
# ROUTE53 MODULE
# =========================

module "route53" {
  source = "./modules/route53"

  domain_name  = var.domain_name
  alb_dns_name = module.alb.alb_dns_name
  alb_zone_id  = module.alb.alb_zone_id
}