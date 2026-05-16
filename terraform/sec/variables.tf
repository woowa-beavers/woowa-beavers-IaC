# terraform/sec/variables.tf
# 역할: sec 루트 모듈 전체 입력 변수 정의
# 흐름: GitHub Secrets(TF_VAR_) → 이 파일 변수 → main.tf 모듈 호출

variable "aws_region" {
  description = "AWS 리전"
  type        = string
  default     = "ap-northeast-2"
}

# ==========================================
# Networking
# ==========================================
variable "misp_project_name" {
  description = "MISP 프로젝트 이름 (리소스 태그용)"
  type        = string
  default     = "soc-misp"
}

# ==========================================
# Compute (TheHive)
# ==========================================
variable "ec2_ami" {
  description = "TheHive EC2 AMI ID (Ubuntu 24.04)"
  type        = string
}

variable "thehive_admin_cidr" {
  description = "TheHive API 접근 허용 관리자 IP CIDR (예: x.x.x.x/32)"
  type        = string
}

variable "thehive_public_key" {
  description = "TheHive 서버 EC2 Key Pair 공개키 (GitHub Secrets: TF_VAR_THEHIVE_PUBLIC_KEY)"
  type        = string
}

# ==========================================
# Compute (MISP)
# ==========================================
variable "misp_ami" {
  description = "MISP EC2 AMI ID (Ubuntu 24.04)"
  type        = string
}

variable "misp_public_key" {
  description = "MISP 서버 EC2 Key Pair 공개키 (GitHub Secrets: TF_VAR_MISP_PUBLIC_KEY)"
  type        = string
}

# ==========================================
# Security
# ==========================================
variable "sec_account_id" {
  description = "sec 계정 ID"
  type        = string
}

# ==========================================
# S3 버킷
# ==========================================
variable "cloudtrail_bucket_name" {
  description = "CloudTrail 로그 S3 버킷 이름"
  type        = string
  default     = "woowa-beavers-central-cloudtrail-logs"
}

variable "config_bucket_name" {
  description = "Config 로그 S3 버킷 이름"
  type        = string
  default     = "woowa-beavers-central-config-logs"
}

variable "waf_logs_bucket_name" {
  description = "WAF 로그 S3 버킷 이름"
  type        = string
  default     = "soc-waf-logs-126378327873"
}
