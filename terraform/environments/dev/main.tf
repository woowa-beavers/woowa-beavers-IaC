# terraform/environments/dev/main.tf
# 역할: dev 환경 루트 모듈 - networking · compute · cdn 모듈을 조합하여 전체 dev 인프라 구성
# 흐름: variables.tf 입력값 → 각 모듈 호출 → outputs.tf 출력

terraform {
  required_version = "1.15.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "networking" {
  source = "../../modules/networking"

  vpc_id               = var.vpc_id
  public_subnet_id     = var.public_subnet_id
  private_subnet_cidrs = var.private_subnet_cidrs

  bastion_ami_id     = var.bastion_ami_id
  bastion_key_name   = var.bastion_key_name
  bastion_private_ip = var.bastion_private_ip

  nat_ami_id     = var.nat_ami_id
  nat_key_name   = var.nat_key_name
  nat_private_ip = var.nat_private_ip
}

module "compute" {
  source = "../../modules/compute"

  vpc_id            = var.vpc_id
  private_subnet_id = var.private_subnet_id
  bastion_sg_id     = module.networking.bastion_sg_id
  alb_sg_id         = var.alb_sg_id

  ec2_1_ami_id     = var.ec2_1_ami_id
  ec2_1_key_name   = var.ec2_1_key_name
  ec2_1_private_ip = var.ec2_1_private_ip

  ec2_2_ami_id     = var.ec2_2_ami_id
  ec2_2_key_name   = var.ec2_2_key_name
  ec2_2_private_ip = var.ec2_2_private_ip

  ec2_3_ami_id     = var.ec2_3_ami_id
  ec2_3_key_name   = var.ec2_3_key_name
  ec2_3_private_ip = var.ec2_3_private_ip

  ec2_4_ami_id     = var.ec2_4_ami_id
  ec2_4_key_name   = var.ec2_4_key_name
  ec2_4_private_ip = var.ec2_4_private_ip

  ec2_5_ami_id     = var.ec2_5_ami_id
  ec2_5_key_name   = var.ec2_5_key_name
  ec2_5_private_ip = var.ec2_5_private_ip
}

module "database" {
  source = "../../modules/database"

  db_subnet_ids        = var.db_subnet_ids
  rds_sg_id            = var.rds_sg_id
  auth_db_password     = var.auth_db_password
  commerce_db_password = var.commerce_db_password
}

module "cdn" {
  source = "../../modules/cdn"

  vpc_id            = var.vpc_id
  public_subnet_ids = var.public_subnet_ids
  alb_sg_id         = var.alb_sg_id
  certificate_arn   = var.certificate_arn

  ec2_1_instance_id = module.compute.ec2_1_instance_id
  x_origin_secret   = var.x_origin_secret
}

# ==========================================
# S3 버킷
# ==========================================
module "alb_logs" {
  source      = "../../modules/storage"
  bucket_name = "woowa-beavers-alb-logs"
}

module "shop_static" {
  source      = "../../modules/storage"
  bucket_name = "woowa-beavers-shop-static-529646247193-ap-northeast-2-an"
}

module "vpc_flow_logs" {
  source      = "../../modules/storage"
  bucket_name = "woowabeavers-vpc-flow-logs-apnortheast2"
}

module "cloudtrail_logs_default" {
  source      = "../../modules/storage"
  bucket_name = "aws-cloudtrail-logs-529646247193-4ea1fc2d"
}

module "cloudtrail_logs_reg" {
  source      = "../../modules/storage"
  bucket_name = "woowa-beavers-cloudtrail-logs-529646247193-ap-northeast-2-an"
}
