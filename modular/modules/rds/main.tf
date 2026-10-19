
# =========================
# RDS DB SUBNET GROUP
# =========================

resource "aws_db_subnet_group" "phase1_db_subnet_group" {
  name = "tf-phase1-db-subnet-group"

  subnet_ids = [
    var.private_subnet_1_id,
    var.private_subnet_2_id
  ]

  tags = {
    Name = "tf-phase1-db-subnet-group"
  }
}

# =========================
# RDS SECURITY GROUP
# =========================

resource "aws_security_group" "rds_sg" {
  name        = "tf-phase1-rds-sg"
  description = "Allow PostgreSQL from ASG instances"

  vpc_id = var.vpc_id

  ingress {
    description = "PostgreSQL from ASG"

    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"

    security_groups = [var.asg_security_group_id]
  }

  tags = {
    Name = "tf-phase1-rds-sg"
  }
}

# =========================
# RDS POSTGRESQL INSTANCE
# =========================

resource "aws_db_instance" "phase1_postgres" {
  identifier = var.db_identifier

  engine         = "postgres"
  instance_class = var.db_instance_class

  allocated_storage = var.db_allocated_storage
  storage_type      = "gp3"

  db_name  = var.db_name
  username = var.db_username

  manage_master_user_password = true

  db_subnet_group_name = aws_db_subnet_group.phase1_db_subnet_group.name

  vpc_security_group_ids = [
    aws_security_group.rds_sg.id
  ]

  publicly_accessible = false

  multi_az          = true
  apply_immediately = true

  skip_final_snapshot = true

  tags = {
    Name = "tf-phase1-postgres-db"
  }
}
