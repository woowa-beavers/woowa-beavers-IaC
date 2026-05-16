# terraform/environments/dev/variables.tf
# 역할: dev 루트 모듈 입력 변수 전체 선언 (networking · compute · cdn 모듈에 전달)
# 흐름: terraform.tfvars 값 주입 → 변수 검증 → main.tf 를 통해 각 모듈로 전달

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-2"
}

# -----------------------------------------------
# Networking 모듈 - Bastion
# -----------------------------------------------
variable "bastion_nat_public_key" {
  description = "Bastion + NAT EC2 Key Pair 공개키 (GitHub Secrets: TF_VAR_BASTION_NAT_PUBLIC_KEY)"
  type        = string
}

variable "ec2_public_key" {
  description = "EC2 1~5 공용 Key Pair 공개키 (GitHub Secrets: TF_VAR_EC2_PUBLIC_KEY)"
  type        = string
}

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
# Networking 모듈 - NAT
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
  default     = "woowa-beavers-keypair"
}

variable "ec2_1_private_ip" {
  description = "EC2-1 private IP"
  type        = string
  default     = "10.0.2.184"
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
  default     = "woowa-beavers-keypair"
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
  default     = "woowa-beavers-keypair"
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
  default     = "woowa-beavers-keypair"
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
  default     = "10.0.2.202"
}

# -----------------------------------------------
# Database 모듈 - RDS
# -----------------------------------------------
variable "auth_db_password" {
  description = "Auth RDS master password (GitHub Secrets: TF_VAR_AUTH_DB_PASSWORD)"
  type        = string
  sensitive   = true
}

variable "commerce_db_password" {
  description = "Commerce RDS master password (GitHub Secrets: TF_VAR_COMMERCE_DB_PASSWORD)"
  type        = string
  sensitive   = true
}

# -----------------------------------------------
# CDN 모듈 - ALB
# -----------------------------------------------
variable "certificate_arn" {
  description = "ACM certificate ARN for ALB HTTPS listener (ap-northeast-2)"
  type        = string
}

variable "cloudfront_certificate_arn" {
  description = "ACM certificate ARN for CloudFront (us-east-1 필수)"
  type        = string
}

variable "waf_web_acl_arn" {
  description = "CloudFront WAF Web ACL ARN (us-east-1 global)"
  type        = string
}

variable "x_origin_secret" {
  description = "Cloudflare X-Origin-Secret 헤더 값 (GitHub Secrets로 주입)"
  type        = string
  sensitive   = true
}
