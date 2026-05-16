# terraform/sec/main.tf
# 역할: sec 계정 루트 모듈 - 보안 서버 및 보안 서비스 전체 구성
# 흐름: variables.tf 입력값 → networking → iam → compute → security 모듈 순서로 실행

terraform {
  required_version = "1.15.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.44"
    }
  }

  backend "s3" {
    bucket = "woowa-beavers-tfstate"
    key    = "sec/terraform.tfstate"
    region = "ap-northeast-2"
  }
}

provider "aws" {
  region = var.aws_region
}

# ==========================================
# 1. Networking (MISP·TheHive VPC/서브넷/IGW/NAT GW)
# ==========================================
module "networking" {
  source = "./modules/networking"

  misp_project_name = var.misp_project_name
}

# ==========================================
# 2. IAM (TheHive SSM Role/Profile)
# ==========================================
module "iam" {
  source = "./modules/iam"
}

# ==========================================
# 3. Compute (TheHive NAT Instance / Server / MISP Server)
# ==========================================
module "compute" {
  source = "./modules/compute"

  ec2_ami                       = var.ec2_ami
  thehive_vpc_id                = module.networking.thehive_vpc_id
  thehive_public_subnet_id      = module.networking.thehive_public_subnet_id
  thehive_private_subnet_id     = module.networking.thehive_private_subnet_id
  thehive_admin_cidr            = var.thehive_admin_cidr
  thehive_instance_profile_name = module.iam.thehive_instance_profile_name
  thehive_public_key            = var.thehive_public_key

  misp_ami                   = var.misp_ami
  misp_vpc_id                = module.networking.misp_vpc_id
  misp_private_subnet_id     = module.networking.misp_private_subnet_id
  misp_instance_profile_name = module.iam.misp_instance_profile_name
  misp_public_key            = var.misp_public_key
}

# ==========================================
# 4. Security (GuardDuty / SecurityHub / Config)
# ==========================================
module "security" {
  source = "./modules/security"

  sec_account_id = var.sec_account_id
}

# ==========================================
# 5. S3 버킷 (CloudTrail / Config / WAF 로그)
# ==========================================
module "central_cloudtrail" {
  source      = "../modules/storage"
  bucket_name = var.cloudtrail_bucket_name
  bucket_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AWSCloudTrailAclCheck"
        Effect    = "Allow"
        Principal = { Service = "cloudtrail.amazonaws.com" }
        Action    = "s3:GetBucketAcl"
        Resource  = "arn:aws:s3:::${var.cloudtrail_bucket_name}"
      },
      {
        Sid       = "AWSCloudTrailWrite"
        Effect    = "Allow"
        Principal = { Service = "cloudtrail.amazonaws.com" }
        Action    = "s3:PutObject"
        Resource  = "arn:aws:s3:::${var.cloudtrail_bucket_name}/AWSLogs/*"
        Condition = { StringEquals = { "s3:x-amz-acl" = "bucket-owner-full-control" } }
      }
    ]
  })
}

module "central_config" {
  source      = "../modules/storage"
  bucket_name = var.config_bucket_name
  bucket_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AWSConfigBucketPermissionsCheck"
        Effect    = "Allow"
        Principal = { Service = "config.amazonaws.com" }
        Action    = "s3:GetBucketAcl"
        Resource  = "arn:aws:s3:::${var.config_bucket_name}"
      },
      {
        Sid       = "AWSConfigBucketDelivery"
        Effect    = "Allow"
        Principal = { Service = "config.amazonaws.com" }
        Action    = "s3:PutObject"
        Resource  = "arn:aws:s3:::${var.config_bucket_name}/AWSLogs/*/Config/*"
        Condition = { StringEquals = { "s3:x-amz-acl" = "bucket-owner-full-control" } }
      }
    ]
  })
}

module "waf_logs" {
  source      = "../modules/storage"
  bucket_name = var.waf_logs_bucket_name
  bucket_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "WAFLogDelivery"
        Effect    = "Allow"
        Principal = { Service = "delivery.logs.amazonaws.com" }
        Action    = "s3:PutObject"
        Resource  = "arn:aws:s3:::${var.waf_logs_bucket_name}/AWSLogs/${var.sec_account_id}/*"
        Condition = { StringEquals = { "s3:x-amz-acl" = "bucket-owner-full-control" } }
      },
      {
        Sid       = "WAFLogAclCheck"
        Effect    = "Allow"
        Principal = { Service = "delivery.logs.amazonaws.com" }
        Action    = "s3:GetBucketAcl"
        Resource  = "arn:aws:s3:::${var.waf_logs_bucket_name}"
      }
    ]
  })
}
