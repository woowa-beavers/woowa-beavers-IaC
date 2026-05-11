# terraform/modules/database/outputs.tf
# 역할: database 모듈 출력값 (엔드포인트 · 서브넷 그룹명)
# 흐름: aws_db_instance 속성 → 이 파일 → environments/dev/outputs.tf 에서 참조

output "auth_db_endpoint" {
  description = "Auth RDS endpoint"
  value       = aws_db_instance.auth.endpoint
}

output "commerce_db_endpoint" {
  description = "Commerce RDS endpoint"
  value       = aws_db_instance.commerce.endpoint
}

output "db_subnet_group_name" {
  description = "DB 서브넷 그룹 이름"
  value       = aws_db_subnet_group.rds.name
}
