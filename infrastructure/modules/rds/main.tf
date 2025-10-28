resource "aws_db_subnet_group" "netscore_db_subnet_group" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = var.subnet_ids
}

resource "aws_security_group" "db_sg" {
  name        = "${var.project_name}-rds-sg"
  description = "Security group for RDS PostgreSQL instance"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr_block]
  }

  tags = {
    Name = var.project_name
  }
}

resource "aws_db_instance" "netscore_db" {
  identifier             = "${var.project_name}-db"
  engine                 = "postgres"
  engine_version         = "16"
  instance_class         = "db.t4g.medium"
  allocated_storage      = 20
  storage_type           = "gp3"
  username               = var.db_username
  password               = var.db_password
  db_name                = var.project_name
  multi_az               = true 
  storage_encrypted      = true 
  publicly_accessible    = false 
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.netscore_db_subnet_group.name

  backup_retention_period = 7
  backup_window           = "03:00-04:00"
  maintenance_window      = "Mon:04:00-Mon:05:00"

  deletion_protection = false
  skip_final_snapshot  = true

  monitoring_interval          = 60
  monitoring_role_arn          = aws_iam_role.rds_monitoring_role.arn
  performance_insights_enabled = true

  auto_minor_version_upgrade = true

  tags = {
    Name = var.project_name
  }
}

resource "aws_iam_role" "rds_monitoring_role" {
  name = "rds-monitoring-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "monitoring.rds.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "rds_monitoring_policy" {
  role       = aws_iam_role.rds_monitoring_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}