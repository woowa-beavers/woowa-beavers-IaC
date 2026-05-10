# terraform/modules/database/main.tf
# 역할: RDS 서브넷 그룹 · Auth DB · Commerce DB 정의 (dev 계정 데이터베이스 레이어)
# 흐름: variables.tf 입력값 → 서브넷 그룹·DB 인스턴스 생성 → outputs.tf 출력

# -----------------------------------------------
# DB Subnet Group
# -----------------------------------------------
resource "aws_db_subnet_group" "rds" {
  name        = "woowa-beavers-db-subnet group"
  description = "Auth RDS, Commerce RDS"
  subnet_ids  = var.db_subnet_ids

  tags = {
    Name = "woowa-beavers-db-subnet group"
  }
}

# -----------------------------------------------
# Auth RDS (MySQL 8.4)
# -----------------------------------------------
resource "aws_db_instance" "auth" {
  identifier     = "auth"
  engine         = "mysql"
  engine_version = "8.4.7"
  instance_class = "db.t3.micro"

  db_name  = "Auth_DB"
  username = "admin"
  password = var.auth_db_password
  port     = 3306

  db_subnet_group_name   = aws_db_subnet_group.rds.name
  vpc_security_group_ids = [var.rds_sg_id]

  storage_type          = "gp2"
  allocated_storage     = 20
  max_allocated_storage = 1000
  storage_encrypted     = true

  parameter_group_name = "auth-rds"

  multi_az            = false
  publicly_accessible = false
  skip_final_snapshot = true
  deletion_protection = false

  tags = {
    Name = "auth"
  }
}

# -----------------------------------------------
# Commerce RDS (MySQL 8.4)
# -----------------------------------------------
resource "aws_db_instance" "commerce" {
  identifier     = "commerce"
  engine         = "mysql"
  engine_version = "8.4.7"
  instance_class = "db.t3.micro"

  db_name  = "Commerce_DB"
  username = "admin"
  password = var.commerce_db_password
  port     = 3306

  db_subnet_group_name   = aws_db_subnet_group.rds.name
  vpc_security_group_ids = [var.rds_sg_id]

  storage_type          = "gp2"
  allocated_storage     = 20
  max_allocated_storage = 1000
  storage_encrypted     = true

  parameter_group_name = "default.mysql8.4"

  multi_az            = false
  publicly_accessible = false
  skip_final_snapshot = true
  deletion_protection = false

  tags = {
    Name = "commerce"
  }
}
