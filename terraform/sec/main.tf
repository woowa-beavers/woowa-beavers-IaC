# terraform/sec/main.tf
# 역할: sec 계정 루트 모듈 - 보안 서버 및 보안 서비스 전체 구성
# 흐름: variables.tf 입력값 → networking → iam → compute → security 모듈 순서로 실행

terraform {
  required_version = "1.15.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.44"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# ==========================================
# 1. Networking (MISP VPC/서브넷/NAT GW)
# ==========================================
module "networking" {
  source = "./modules/networking"

  misp_vpc_name            = var.misp_vpc_name
  misp_public_subnet_name  = var.misp_public_subnet_name
  misp_private_subnet_name = var.misp_private_subnet_name
  misp_project_name        = var.misp_project_name
}

# ==========================================
# 2. IAM (TheHive SSM Role/Profile)
# ==========================================
module "iam" {
  source = "./modules/iam"
}

# ==========================================
# 3. Compute (TheHive NAT Instance / Server)
# ==========================================
module "compute" {
  source = "./modules/compute"

  ec2_ami                       = var.ec2_ami
  thehive_vpc_id                = var.thehive_vpc_id
  thehive_public_subnet_id      = var.thehive_public_subnet_id
  thehive_private_subnet_id     = var.thehive_private_subnet_id
  nat_security_group_ids        = var.nat_security_group_ids
  thehive_security_group_ids    = var.thehive_security_group_ids
  thehive_nat_eip_alloc_id      = var.thehive_nat_eip_alloc_id
  thehive_instance_profile_name = module.iam.thehive_instance_profile_name

  depends_on = [module.iam]
}

# ==========================================
# 4. Security (GuardDuty / SecurityHub / Config)
# ==========================================
module "security" {
  source = "./modules/security"

  sec_account_id        = var.sec_account_id
  guardduty_detector_id = var.guardduty_detector_id
}
