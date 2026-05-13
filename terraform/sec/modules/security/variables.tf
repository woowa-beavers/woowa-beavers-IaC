# terraform/sec/modules/security/variables.tf
# 역할: security 모듈 입력 변수 정의
# 흐름: 상위 루트 모듈 또는 tfvars → 이 파일 변수 → main.tf 리소스

variable "sec_account_id" {
  description = "sec 계정 ID (Config IAM role ARN 구성용)"
  type        = string
}
