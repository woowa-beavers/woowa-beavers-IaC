# terraform/sec/variables.tf
# 역할: sec 루트 모듈 전체 입력 변수 정의
# 흐름: GitHub Secrets(TF_VAR_) → 이 파일 변수 → main.tf 모듈 호출

variable "aws_region" {
  description = "AWS 리전"
  type        = string
  default     = "ap-northeast-2"
}

# ==========================================
# Networking (MISP)
# ==========================================
variable "misp_vpc_name" {
  description = "MISP VPC Name 태그"
  type        = string
}

variable "misp_public_subnet_name" {
  description = "MISP NAT Gateway용 퍼블릭 서브넷 Name 태그"
  type        = string
}

variable "misp_private_subnet_name" {
  description = "MISP EC2가 위치한 프라이빗 서브넷 Name 태그"
  type        = string
}

variable "misp_project_name" {
  description = "MISP 프로젝트 이름 (리소스 태그용)"
  type        = string
  default     = "soc-misp"
}

# ==========================================
# Compute (TheHive)
# ==========================================
variable "ec2_ami" {
  description = "EC2 AMI ID"
  type        = string
}

variable "thehive_vpc_id" {
  description = "TheHive VPC ID"
  type        = string
}

variable "thehive_public_subnet_id" {
  description = "TheHive NAT 인스턴스용 퍼블릭 서브넷 ID"
  type        = string
}

variable "thehive_private_subnet_id" {
  description = "TheHive 서버용 프라이빗 서브넷 ID"
  type        = string
}

variable "nat_security_group_ids" {
  description = "NAT 인스턴스 보안그룹 ID 목록"
  type        = list(string)
}

variable "thehive_security_group_ids" {
  description = "TheHive 서버 보안그룹 ID 목록"
  type        = list(string)
}

variable "thehive_nat_eip_alloc_id" {
  description = "NAT 인스턴스에 연결할 EIP Allocation ID"
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

variable "wazuh_reader_iam_arn" {
  description = "Wazuh CloudTrail 읽기 권한 IAM ARN"
  type        = string
}
