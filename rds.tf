# RDS
resource "aws_db_instance" "default" {
  identifier        = "rds-${var.vpc_name}"
  engine            = "mariadb"
  engine_version    = "10.11.7"
  instance_class    = "db.t4g.small"
  storage_type      = "gp3"
  allocated_storage = 40

  username = "root"

  db_subnet_group_name   = aws_db_subnet_group.rds.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  multi_az               = true

  parameter_group_name         = "default.mariadb10.11"
  skip_final_snapshot          = true
  performance_insights_enabled = false
  storage_encrypted            = false
  delete_automated_backups     = true
}

# RDS Subnet
resource "aws_db_subnet_group" "rds" {
  name       = "rds-subnet-group-${var.vpc_name}"
  subnet_ids = [for subnet in aws_subnet.private_db.* : subnet.id]

  tags = {
    Name = "rds-subnet-group-${var.vpc_name}"
  }
}
