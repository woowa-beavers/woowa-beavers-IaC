# terraform/sec/variables.tf
# 역할: sec 루트 모듈 공통 변수 선언 (리전 등)
# 흐름: terraform.tfvars 값 주입 → 변수 검증 → main.tf 에서 참조

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-2"
}
