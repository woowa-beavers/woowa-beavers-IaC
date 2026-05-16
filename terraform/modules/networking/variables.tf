# terraform/modules/networking/variables.tf
# 역할: networking 모듈 입력 변수 선언 (VPC CIDR · 서브넷 CIDR · Bastion · NAT 설정값)
# 흐름: environments/dev/main.tf 에서 전달 → 변수 검증 → main.tf 에서 참조

# -----------------------------------------------
# VPC / 서브넷 CIDR
# -----------------------------------------------
variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_1_cidr" {
  description = "Public subnet 1 CIDR (ap-northeast-2a) - Bastion, NAT"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_2_cidr" {
  description = "Public subnet 2 CIDR (ap-northeast-2c) - ALB second AZ"
  type        = string
  default     = "10.0.5.0/24"
}

variable "private_subnet_cidr" {
  description = "Private subnet CIDR (ap-northeast-2a) - EC2 instances"
  type        = string
  default     = "10.0.2.0/24"
}

variable "db_subnet_1_cidr" {
  description = "DB subnet 1 CIDR (ap-northeast-2a)"
  type        = string
  default     = "10.0.3.0/24"
}

variable "db_subnet_2_cidr" {
  description = "DB subnet 2 CIDR (ap-northeast-2c)"
  type        = string
  default     = "10.0.4.0/24"
}

variable "bastion_nat_public_key" {
  description = "Bastion + NAT EC2 Key Pair 공개키 (ssh-rsa ...)"
  type        = string
}

variable "vpc_flow_logs_bucket_arn" {
  description = "VPC Flow Logs S3 버킷 ARN"
  type        = string
  default     = "arn:aws:s3:::woowabeavers-vpc-flow-logs-apnortheast2"
}

variable "cloudflare_cidrs" {
  description = "Cloudflare IPv4 CIDR 목록 — Bastion SSH 허용 대상 (https://www.cloudflare.com/ips/)"
  type        = list(string)
  default = [
    "173.245.48.0/20",
    "103.21.244.0/22",
    "103.22.200.0/22",
    "103.31.4.0/22",
    "141.101.64.0/18",
    "108.162.192.0/18",
    "190.93.240.0/20",
    "188.114.96.0/20",
    "197.234.240.0/22",
    "198.41.128.0/17",
    "162.158.0.0/15",
    "104.16.0.0/13",
    "104.24.0.0/14",
    "172.64.0.0/13",
    "131.0.72.0/22",
  ]
}

variable "team_ssh_cidrs" {
  description = "팀원 개인 IP CIDR 목록 — terraform.tfvars 에만 입력, git 커밋 금지"
  type        = list(string)
  default     = []
}

# -----------------------------------------------
# Bastion Host
# -----------------------------------------------
variable "bastion_ami_id" {
  description = "Bastion AMI ID"
  type        = string
}

variable "bastion_key_name" {
  description = "EC2 key pair name for bastion"
  type        = string
  default     = "woowa-beavers-bastion-EC2-key"
}

variable "bastion_private_ip" {
  description = "Bastion private IP"
  type        = string
  default     = "10.0.1.143"
}

# -----------------------------------------------
# NAT Instance
# -----------------------------------------------
variable "nat_ami_id" {
  description = "NAT instance AMI ID"
  type        = string
}

variable "nat_key_name" {
  description = "EC2 key pair name for NAT"
  type        = string
  default     = "woowa-beavers-bastion-EC2-key"
}

variable "nat_private_ip" {
  description = "NAT instance private IP"
  type        = string
  default     = "10.0.1.10"
}
