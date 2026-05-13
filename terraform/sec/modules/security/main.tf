# terraform/sec/modules/security/main.tf
# 역할: sec 계정 보안 서비스 모듈 - GuardDuty, SecurityHub, CloudTrail Lake 관리
# 흐름: variables.tf 입력값 → GuardDuty 활성화 → 결과 outputs.tf 출력

# ==========================================
# SecurityHub
# ==========================================
import {
  to = aws_securityhub_account.main
  id = var.sec_account_id
}

resource "aws_securityhub_account" "main" {
  enable_default_standards = true
}

resource "aws_securityhub_standards_subscription" "cis" {
  standards_arn = "arn:aws:securityhub:::ruleset/cis-aws-foundations-benchmark/v/1.2.0"
  depends_on    = [aws_securityhub_account.main]
}

resource "aws_securityhub_standards_subscription" "aws_foundational" {
  standards_arn = "arn:aws:securityhub:ap-northeast-2::standards/aws-foundational-security-best-practices/v/1.0.0"
  depends_on    = [aws_securityhub_account.main]
}

# ==========================================
# AWS Config
# ==========================================
import {
  to = aws_config_configuration_recorder.main
  id = "default"
}

resource "aws_config_configuration_recorder" "main" {
  name     = "default"
  role_arn = "arn:aws:iam::${var.sec_account_id}:role/aws-service-role/config.amazonaws.com/AWSServiceRoleForConfig"

  recording_group {
    all_supported                 = true
    include_global_resource_types = true
  }
}

import {
  to = aws_config_delivery_channel.main
  id = "default"
}

resource "aws_config_delivery_channel" "main" {
  name           = "default"
  s3_bucket_name = "woowa-beavers-central-config-logs"
  depends_on     = [aws_config_configuration_recorder.main]
}

resource "aws_config_configuration_recorder_status" "main" {
  name       = aws_config_configuration_recorder.main.name
  is_enabled = true
  depends_on = [aws_config_delivery_channel.main]
}

# ==========================================
# GuardDuty
# ==========================================
import {
  to = aws_guardduty_detector.main
  id = var.guardduty_detector_id
}

resource "aws_guardduty_detector" "main" {
  enable = true

  datasources {
    s3_logs {
      enable = true
    }
    kubernetes {
      audit_logs {
        enable = false
      }
    }
    malware_protection {
      scan_ec2_instance_with_findings {
        ebs_volumes {
          enable = true
        }
      }
    }
  }

  tags = {
    Name = "sec-guardduty"
  }
}
