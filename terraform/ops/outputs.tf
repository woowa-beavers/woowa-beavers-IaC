# terraform/ops/outputs.tf
# 역할: ops 계정 루트 모듈 출력값 - OIDC Provider 및 IAM Role 정보 노출
# 흐름: main.tf 리소스 → 이 파일 출력값 → GitHub Actions workflow 참조

output "github_actions_role_arn" {
  description = "GitHub Actions Terraform 실행 IAM Role ARN"
  value       = aws_iam_role.github_actions.arn
}

output "oidc_provider_arn" {
  description = "GitHub Actions OIDC Provider ARN"
  value       = aws_iam_openid_connect_provider.github_actions.arn
}
