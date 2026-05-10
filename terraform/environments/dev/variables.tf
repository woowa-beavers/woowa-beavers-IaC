# terraform/environments/dev/variables.tf
# 역할: dev 루트 모듈 입력 변수 전체 선언 (networking · compute · cdn 모듈에 전달)
# 흐름: terraform.tfvars 값 주입 → 변수 검증 → main.tf 를 통해 각 모듈로 전달

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-2"
}

# -----------------------------------------------
# 공통 네트워크
# -----------------------------------------------
variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnet_id" {
  description = "Public subnet ID for bastion and NAT instance"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs for ALB (different AZs, 2 or more)"
  type        = list(string)
}

variable "private_subnet_id" {
  description = "Private subnet ID for EC2 instances"
  type        = string
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDR blocks (private1 + private2)"
  type        = list(string)
  default     = ["10.0.2.0/24", "10.0.3.0/24"]
}

variable "alb_sg_id" {
  description = "ALB security group ID"
  type        = string
}

# -----------------------------------------------
# Networking 모듈 - Bastion
# -----------------------------------------------
variable "bastion_ami_id" {
  description = "Bastion AMI ID"
  type        = string
}

variable "bastion_key_name" {
  description = "EC2 key pair name for bastion"
  type        = string
}

variable "bastion_private_ip" {
  description = "Bastion private IP"
  type        = string
  default     = "10.0.1.143"
}

# -----------------------------------------------
# Networking 모듈 - NAT
# -----------------------------------------------
variable "nat_ami_id" {
  description = "NAT instance AMI ID"
  type        = string
}

variable "nat_key_name" {
  description = "EC2 key pair name for NAT"
  type        = string
}

variable "nat_private_ip" {
  description = "NAT instance private IP"
  type        = string
  default     = "10.0.1.171"
}

# -----------------------------------------------
# Compute 모듈 - EC2-1 Product
# -----------------------------------------------
variable "ec2_1_ami_id" {
  description = "EC2-1 AMI ID"
  type        = string
}

variable "ec2_1_key_name" {
  description = "EC2 key pair name for EC2-1"
  type        = string
}

variable "ec2_1_private_ip" {
  description = "EC2-1 private IP"
  type        = string
}

# -----------------------------------------------
# Compute 모듈 - EC2-2 Auth
# -----------------------------------------------
variable "ec2_2_ami_id" {
  description = "EC2-2 AMI ID"
  type        = string
}

variable "ec2_2_key_name" {
  description = "EC2 key pair name for EC2-2"
  type        = string
}

variable "ec2_2_private_ip" {
  description = "EC2-2 private IP"
  type        = string
  default     = "10.0.2.233"
}

# -----------------------------------------------
# Compute 모듈 - EC2-3 Inventory
# -----------------------------------------------
variable "ec2_3_ami_id" {
  description = "EC2-3 inventory AMI ID"
  type        = string
}

variable "ec2_3_key_name" {
  description = "EC2 key pair name for EC2-3"
  type        = string
}

variable "ec2_3_private_ip" {
  description = "EC2-3 private IP"
  type        = string
  default     = "10.0.2.33"
}

# -----------------------------------------------
# Compute 모듈 - EC2-4 Order
# -----------------------------------------------
variable "ec2_4_ami_id" {
  description = "EC2-4 order AMI ID"
  type        = string
}

variable "ec2_4_key_name" {
  description = "EC2 key pair name for EC2-4"
  type        = string
}

variable "ec2_4_private_ip" {
  description = "EC2-4 private IP"
  type        = string
  default     = "10.0.2.74"
}

# -----------------------------------------------
# Compute 모듈 - EC2-5
# -----------------------------------------------
variable "ec2_5_ami_id" {
  description = "EC2-5 AMI ID"
  type        = string
}

variable "ec2_5_key_name" {
  description = "EC2 key pair name for EC2-5"
  type        = string
  default     = "woowa-beavers-keypair"
}

variable "ec2_5_private_ip" {
  description = "EC2-5 private IP"
  type        = string
}

# -----------------------------------------------
# CDN 모듈 - ALB
# -----------------------------------------------
variable "certificate_arn" {
  description = "ACM certificate ARN for HTTPS listener"
  type        = string
}

variable "x_origin_secret" {
  description = "Cloudflare X-Origin-Secret 헤더 값 (GitHub Secrets로 주입)"
  type        = string
  sensitive   = true
}
