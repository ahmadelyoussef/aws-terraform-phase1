output "rds_endpoint" {
  value = aws_db_instance.phase1_postgres.endpoint
}