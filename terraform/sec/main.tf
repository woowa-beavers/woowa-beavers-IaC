# terraform/sec/main.tf
# 역할: sec 계정 Terraform 루트 모듈 진입점 (AWS provider 설정)
# 흐름: variables.tf 입력값 → AWS provider 초기화 → 하위 보안 모듈(compute·iam·networking·security) 독립 실행

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}
