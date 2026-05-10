# terraform/cloudflare/main.tf
# 역할: Cloudflare provider 설정 (DNS·프록시 등 Cloudflare 리소스 관리 진입점)
# 흐름: variables.tf 입력값(API 토큰) → Cloudflare provider 초기화 → 하위 리소스 정의

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
