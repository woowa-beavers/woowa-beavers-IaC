# terraform/root/variables.tf
# 역할: root 모듈 입력 변수 정의 - 계정 ID, 이름, 이메일
# 흐름: GitHub Secrets(TF_VAR_) → 이 파일 변수 → main.tf 리소스

variable "aws_region" {
  description = "AWS 리전"
  type        = string
  default     = "ap-northeast-2"
}

# billing 계정
variable "billing_account_id" {
  description = "billing 계정 ID"
  type        = string
}

variable "billing_account_name" {
  description = "billing 계정 이름"
  type        = string
}

variable "billing_account_email" {
  description = "billing 계정 이메일"
  type        = string
}

# ops 계정
variable "ops_account_id" {
  description = "ops 계정 ID"
  type        = string
}

variable "ops_account_name" {
  description = "ops 계정 이름"
  type        = string
}

variable "ops_account_email" {
  description = "ops 계정 이메일"
  type        = string
}

# sec 계정
variable "sec_account_id" {
  description = "sec 계정 ID"
  type        = string
}

variable "sec_account_name" {
  description = "sec 계정 이름"
  type        = string
}

variable "sec_account_email" {
  description = "sec 계정 이메일"
  type        = string
}

# dev 계정
variable "dev_account_id" {
  description = "dev 계정 ID"
  type        = string
}

variable "dev_account_name" {
  description = "dev 계정 이름"
  type        = string
}

variable "dev_account_email" {
  description = "dev 계정 이메일"
  type        = string
}

# workload_extra 계정
variable "workload_extra_account_id" {
  description = "workload extra 계정 ID"
  type        = string
}

variable "workload_extra_account_name" {
  description = "workload extra 계정 이름"
  type        = string
}

variable "workload_extra_account_email" {
  description = "workload extra 계정 이메일"
  type        = string
}
