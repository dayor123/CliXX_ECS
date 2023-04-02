resource "aws_db_snapshot_copy" "rds" {
  source_db_snapshot_identifier = local.clixx_creds.sharedsnapshot
  target_db_snapshot_identifier = "wordpressdbclixx"
}

resource "aws_db_subnet_group" "clixx-rds" {
  name       = "clixx-multi-az-subnet-group"
  subnet_ids = [aws_subnet.db-private-subnet-1.id, aws_subnet.db-private-subnet-2.id]

  tags = {
    Name = "Multi-AZ Subnet Group for RDS"
  }
}

resource "aws_db_instance" "rds" {
  allocated_storage      = 20
  engine                 = "mysql"
  instance_class         = "db.t3.micro"
  db_name                = local.clixx_creds.dbname
  password               = local.clixx_creds.password
  username               = local.clixx_creds.username
  identifier             = "wordpressdbclixx"
  snapshot_identifier    = aws_db_snapshot_copy.rds.id
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.rdsdatabase-sg.id]
  db_subnet_group_name   = aws_db_subnet_group.clixx-rds.name


  maintenance_window      = "Fri:09:00-Fri:09:30"
  backup_retention_period = 0
  parameter_group_name    = "default.mysql8.0"
}