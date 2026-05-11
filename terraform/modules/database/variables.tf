# terraform/modules/database/variables.tf
# 역할: database 모듈 입력 변수 선언 (서브넷 그룹 · 보안그룹 · DB 자격증명)
# 흐름: environments/dev/variables.tf 값 주입 → main.tf 리소스에 전달

variable "db_subnet_ids" {
  description = "DB 서브넷 그룹용 서브넷 ID 목록 (최소 2개, 다른 AZ)"
  type        = list(string)
}

variable "rds_sg_id" {
  description = "RDS 보안 그룹 ID (Woowa-Beavers-RDS-SG)"
  type        = string
}

variable "auth_db_password" {
  description = "Auth RDS master user password"
  type        = string
  sensitive   = true
}

variable "commerce_db_password" {
  description = "Commerce RDS master user password"
  type        = string
  sensitive   = true
}
