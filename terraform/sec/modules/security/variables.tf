# terraform/sec/modules/security/variables.tf
# 역할: security 모듈 입력 변수 정의
# 흐름: 상위 루트 모듈 또는 tfvars → 이 파일 변수 → main.tf 리소스

variable "sec_account_id" {
  description = "sec 계정 ID (SecurityHub import용)"
  type        = string
}

variable "guardduty_detector_id" {
  description = "기존 GuardDuty detector ID (import용)"
  type        = string
}
