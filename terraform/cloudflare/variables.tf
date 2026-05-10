# terraform/cloudflare/variables.tf
# 역할: Cloudflare 모듈 입력 변수 선언 (API 토큰 등 민감 정보)
# 흐름: terraform.tfvars 값 주입 → 변수 검증 → main.tf 에서 참조

variable "cloudflare_api_token" {
  description = "Cloudflare API token"
  type        = string
  sensitive   = true
}
