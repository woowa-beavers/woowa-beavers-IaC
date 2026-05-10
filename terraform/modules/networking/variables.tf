# terraform/modules/networking/variables.tf
# 역할: networking 모듈 입력 변수 선언 (Bastion · NAT 인스턴스 설정값)
# 흐름: environments/dev/main.tf 에서 전달 → 변수 검증 → main.tf 에서 참조

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnet_id" {
  description = "Public subnet ID for bastion and NAT instance"
  type        = string
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDR blocks (private1 + private2 모두 포함)"
  type        = list(string)
  default     = ["10.0.2.0/24", "10.0.3.0/24"]
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
  default     = "10.0.1.171"
}
