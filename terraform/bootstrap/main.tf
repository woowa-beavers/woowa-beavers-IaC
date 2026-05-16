# terraform/bootstrap/main.tf
# 역할: Terraform state 저장용 S3 버킷 생성 (로컬 backend 사용 — 최초 1회만 실행)
# 흐름: terraform init (local) → apply → 버킷 생성 완료 → 이후 모든 계정 terraform init 가능
#
# 실행 방법:
#   cd terraform/bootstrap
#   export AWS_ACCESS_KEY_ID=...  # root 또는 ops 계정 자격증명
#   export AWS_SECRET_ACCESS_KEY=...
#   terraform init
#   terraform apply

terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.44"
    }
  }
  # backend는 local (S3 버킷이 아직 없으므로)
}

provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_s3_bucket" "tfstate" {
  bucket = "woowa-beavers-tfstate"

  tags = {
    Name      = "woowa-beavers-tfstate"
    ManagedBy = "terraform-bootstrap"
  }
}

resource "aws_s3_bucket_versioning" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
