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
