# terraform/sec/variables.tf
# 역할: sec 루트 모듈 공통 변수 선언 (리전 등)
# 흐름: terraform.tfvars 값 주입 → 변수 검증 → main.tf 에서 참조

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-2"
}

variable "account_id" {
  type        = string
  description = "SEC Account Number"
}

variable "cloudtrail_bucket_name" {
  description = "Central(Cloudtrail) Log Bucket Name"
  type        = string
  default     = "woowa-beavers-central-cloudtrail-logs"
}

variable "wazuh_reader_iam_arn" {
  description = "IAM User/Role ARN to have Wazuh read permission"
  type        = string
}

variable "config_bucket_name" {
  description = "Config Log Bucket Name"
  type    = string
}

variable "waf_logs_bucket_name" {
  description = "WAF Log Bucket Name"
  type    = string
}
