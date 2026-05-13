# terraform/root/outputs.tf
# 역할: root 모듈 출력값 - OU ID, 계정 ID 노출
# 흐름: main.tf 리소스 → 이 파일 출력값

output "org_id" {
  description = "AWS Organizations ID"
  value       = data.aws_organizations_organization.org.id
}

output "billing_ou_id" {
  description = "Billing-OU ID"
  value       = aws_organizations_organizational_unit.billing.id
}

output "infrastructure_ou_id" {
  description = "Infrastructure-OU ID"
  value       = aws_organizations_organizational_unit.infrastructure.id
}

output "security_ou_id" {
  description = "Security-OU ID"
  value       = aws_organizations_organizational_unit.security.id
}

output "workload_ou_id" {
  description = "Workload-OU ID"
  value       = aws_organizations_organizational_unit.workload.id
}
