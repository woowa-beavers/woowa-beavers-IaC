# terraform/sec/modules/security/main.tf
# 역할: sec 계정 보안 서비스 모듈 - GuardDuty, SecurityHub, CloudTrail Lake 관리
# 흐름: variables.tf 입력값 → GuardDuty 활성화 → 결과 outputs.tf 출력

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
