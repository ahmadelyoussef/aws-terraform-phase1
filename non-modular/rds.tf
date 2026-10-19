# ---------------------------------------------------------
# 1. RDS DB Subnet Group
# ---------------------------------------------------------

# Defines the private subnets where AWS can deploy RDS.
# The two subnets are in different Availability Zones,
# allowing RDS to support a Multi-AZ deployment.

resource "aws_db_subnet_group" "phase1_db_subnet_group" {
  name = "tf-phase1-db-subnet-group"

  # Reference our existing private subnets.
  subnet_ids = [
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id
  ]

  tags = {
    Name = "tf-phase1-db-subnet-group"
  }
}


# ---------------------------------------------------------
# 2. RDS Security Group
# ---------------------------------------------------------

# Allows EC2 instances launched by our ASG to connect
# to PostgreSQL on TCP port 5432.

resource "aws_security_group" "rds_sg" {
  name        = "tf-phase1-rds-sg"
  description = "Allow PostgreSQL from ASG instances"

  # Create the security group inside our existing VPC.
  vpc_id = aws_vpc.phase1_vpc.id

  ingress {
    description = "PostgreSQL from ASG"

    # PostgreSQL uses TCP port 5432.
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"

    # Allow connections from EC2 instances associated
    # with the ASG security group, rather than fixed IPs.
    # This continues working when ASG replaces instances.
    security_groups = [aws_security_group.phase1_asg_sg.id]
  }

  tags = {
    Name = "tf-phase1-rds-sg"
  }
}


# ---------------------------------------------------------
# 3. RDS PostgreSQL Instance
# ---------------------------------------------------------

# Creates a PostgreSQL database with Multi-AZ high
# availability, private networking, and AWS-managed
# master credentials.

resource "aws_db_instance" "phase1_postgres" {

  # Unique RDS DB instance identifier within this
  # AWS account and Region.
  identifier = "tf-phase1-postgres-db"

  # Database engine and compute instance class.
  engine         = "postgres"
  instance_class = "db.t3.micro"

  # Allocate 20 GiB of gp3 SSD storage.
  allocated_storage = 20
  storage_type      = "gp3"

  # Create the initial PostgreSQL database.
  db_name = "tf_phase1db"

  # PostgreSQL master username.
  username = "postgres"

  # AWS generates and stores the master password
  # in Secrets Manager instead of Terraform code.
  manage_master_user_password = true

  # Reference our DB subnet group containing two
  # private subnets in different Availability Zones.
  db_subnet_group_name = aws_db_subnet_group.phase1_db_subnet_group.name

  # Attach the RDS security group allowing TCP 5432
  # connections from our ASG instances.
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  # Prevent direct public internet access to RDS.
  publicly_accessible = false

  # Deploy a primary database and a synchronous standby
  # in different AZs for automatic failover.
  # The standby does not serve normal read queries.
  multi_az          = true
  apply_immediately = true
  # Delete RDS without creating a final snapshot.
  # Appropriate for a disposable lab, not production.
  skip_final_snapshot = true

  tags = {
    Name = "tf-phase1-postgres-db"
  }
}