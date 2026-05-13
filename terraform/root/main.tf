# terraform/root/main.tf
# 역할: root 계정 루트 모듈 - Organizations OU 구조 및 계정 관리
# 흐름: variables.tf 입력값 → 기존 Organization 조회 → OU import → 계정 import

terraform {
  required_version = "1.15.2"

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

# ==========================================
# 1. Organization 조회
# ==========================================
data "aws_organizations_organization" "org" {}

# ==========================================
# 2. OU (기존 import)
# ==========================================
import {
  to = aws_organizations_organizational_unit.billing
  id = "ou-08tv-yjjkvj1b"
}

resource "aws_organizations_organizational_unit" "billing" {
  name      = "Billing-OU"
  parent_id = data.aws_organizations_organization.org.roots[0].id
}

import {
  to = aws_organizations_organizational_unit.infrastructure
  id = "ou-08tv-pjje4rye"
}

resource "aws_organizations_organizational_unit" "infrastructure" {
  name      = "Infrastructure-OU"
  parent_id = data.aws_organizations_organization.org.roots[0].id
}

import {
  to = aws_organizations_organizational_unit.security
  id = "ou-08tv-ixwv6vvh"
}

resource "aws_organizations_organizational_unit" "security" {
  name      = "Security-OU"
  parent_id = data.aws_organizations_organization.org.roots[0].id
}

import {
  to = aws_organizations_organizational_unit.workload
  id = "ou-08tv-ro5pi3kz"
}

resource "aws_organizations_organizational_unit" "workload" {
  name      = "Workload-OU"
  parent_id = data.aws_organizations_organization.org.roots[0].id
}

# ==========================================
# 3. 계정 (기존 import)
# ==========================================
import {
  to = aws_organizations_account.billing
  id = var.billing_account_id
}

resource "aws_organizations_account" "billing" {
  name      = var.billing_account_name
  email     = var.billing_account_email
  parent_id = aws_organizations_organizational_unit.billing.id
}

import {
  to = aws_organizations_account.ops
  id = var.ops_account_id
}

resource "aws_organizations_account" "ops" {
  name      = var.ops_account_name
  email     = var.ops_account_email
  parent_id = aws_organizations_organizational_unit.infrastructure.id
}

import {
  to = aws_organizations_account.sec
  id = var.sec_account_id
}

resource "aws_organizations_account" "sec" {
  name      = var.sec_account_name
  email     = var.sec_account_email
  parent_id = aws_organizations_organizational_unit.security.id
}

import {
  to = aws_organizations_account.dev
  id = var.dev_account_id
}

resource "aws_organizations_account" "dev" {
  name      = var.dev_account_name
  email     = var.dev_account_email
  parent_id = aws_organizations_organizational_unit.workload.id
}

import {
  to = aws_organizations_account.workload_extra
  id = var.workload_extra_account_id
}

resource "aws_organizations_account" "workload_extra" {
  name      = var.workload_extra_account_name
  email     = var.workload_extra_account_email
  parent_id = aws_organizations_organizational_unit.workload.id
}

# ==========================================
# 4. CloudTrail (조직 전체 추적)
# ==========================================
import {
  to = aws_cloudtrail.org
  id = "soc-org-trail"
}

resource "aws_cloudtrail" "org" {
  name                          = "soc-org-trail"
  s3_bucket_name                = "woowa-beavers-central-cloudtrail-logs"
  include_global_service_events = true
  is_multi_region_trail         = true
  is_organization_trail         = true

  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.cloudtrail.arn}:*"
  cloud_watch_logs_role_arn  = "arn:aws:iam::362437996006:role/service-role/CloudTrail-CloudWatch-Role"

  tags = {
    Name = "soc-org-trail"
  }
}

import {
  to = aws_cloudwatch_log_group.cloudtrail
  id = "woowa-beavers-cloudtrail-logs"
}

resource "aws_cloudwatch_log_group" "cloudtrail" {
  name = "woowa-beavers-cloudtrail-logs"
}
