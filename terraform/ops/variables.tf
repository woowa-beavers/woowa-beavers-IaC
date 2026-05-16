# terraform/ops/variables.tf
# 역할: ops 계정 루트 모듈 입력 변수 정의
# 흐름: terraform.tfvars 값 주입 → 변수 검증 → main.tf 에서 참조

variable "aws_region" {
  description = "AWS 리전"
  type        = string
  default     = "ap-northeast-2"
}

variable "github_repo" {
  description = "GitHub 레포지토리 (org/repo 형식)"
  type        = string
  default     = "woowa-beavers/woowa-beavers-IaC"
}
