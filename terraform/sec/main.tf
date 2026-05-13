# terraform/sec/main.tf
# 역할: sec 계정 Terraform 루트 모듈 진입점 (AWS provider 설정)
# 흐름: variables.tf 입력값 → AWS provider 초기화 → 하위 보안 모듈 실행

terraform {
  required_version = ">= 1.5.0"

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

##################################################
# 1. Security Module (KMS)
##################################################

# module "security" {
#   source     = "./modules/security"
#   account_id = var.account_id
# }

##################################################
# 2. CloudTrail Logs Bucket
##################################################

import {
  to = module.central_cloudtrail.aws_s3_bucket.this
  id = var.cloudtrail_bucket_name
}

import {
  to = module.central_cloudtrail.aws_s3_bucket_policy.this[0]
  id = var.cloudtrail_bucket_name
}

module "central_cloudtrail" {
  source = "../modules/storage"
  bucket_name = var.cloudtrail_bucket_name
  bucket_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "AWSCloudTrailAclCheck"
        Effect = "Allow"

        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }

        Action = "s3:GetBucketAcl"

        Resource = "arn:aws:s3:::${var.cloudtrail_bucket_name}"
      },

      {
        Sid    = "AWSCloudTrailWrite"
        Effect = "Allow"

        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }

        Action = "s3:PutObject"

        Resource = "arn:aws:s3:::${var.cloudtrail_bucket_name}/AWSLogs/*"

        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      },

      {
        Sid    = "WazuhReadAccess"
        Effect = "Allow"

        Principal = {
          AWS = var.wazuh_reader_iam_arn
        }

        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]

        Resource = [
          "arn:aws:s3:::${var.cloudtrail_bucket_name}",
          "arn:aws:s3:::${var.cloudtrail_bucket_name}/*"
        ]
      }
    ]
  })
}

##################################################
# 3. AWS Config Logs Bucket
##################################################

import {
  to = module.central_config.aws_s3_bucket.this
  id = var.config_bucket_name
}

import {
  to = module.central_config.aws_s3_bucket_policy.this[0]
  id = var.config_bucket_name
}

module "central_config" {
  source = "../modules/storage"
  bucket_name = var.config_bucket_name
  bucket_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "AWSConfigBucketPermissionsCheck"
        Effect = "Allow"

        Principal = {
          Service = "config.amazonaws.com"
        }

        Action = "s3:GetBucketAcl"

        Resource = "arn:aws:s3:::${var.config_bucket_name}"
      },

      {
        Sid    = "AWSConfigBucketDelivery"
        Effect = "Allow"

        Principal = {
          Service = "config.amazonaws.com"
        }

        Action = "s3:PutObject"

        Resource = "arn:aws:s3:::${var.config_bucket_name}/AWSLogs/*/Config/*"

        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      }
    ]
  })
}

##################################################
# 4. WAF Logs Bucket
##################################################

import {
  to = module.waf_logs.aws_s3_bucket.this
  id = var.waf_logs_bucket_name
}

import {
  to = module.waf_logs.aws_s3_bucket_policy.this[0]
  id = var.waf_logs_bucket_name
}

module "waf_logs" {
  source = "../modules/storage"
  bucket_name = var.waf_logs_bucket_name
  bucket_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "WAFLogDelivery"
        Effect = "Allow"

        Principal = {
          Service = "delivery.logs.amazonaws.com"
        }

        Action = "s3:PutObject"

        Resource = "arn:aws:s3:::${var.waf_logs_bucket_name}/AWSLogs/529646247193/*"

        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      },

      {
        Sid    = "WAFLogAclCheck"
        Effect = "Allow"

        Principal = {
          Service = "delivery.logs.amazonaws.com"
        }

        Action = "s3:GetBucketAcl"

        Resource = "arn:aws:s3:::${var.waf_logs_bucket_name}"
      }
    ]
  })
}