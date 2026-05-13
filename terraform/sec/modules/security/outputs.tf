# terraform/sec/modules/security/outputs.tf
# 역할: security 모듈 출력값 - GuardDuty detector ID 노출
# 흐름: main.tf 리소스 → 이 파일 출력값

output "securityhub_id" {
  description = "SecurityHub 계정 ID"
  value       = aws_securityhub_account.main.id
}

output "guardduty_detector_id" {
  description = "GuardDuty Detector ID"
  value       = aws_guardduty_detector.main.id
}

output "guardduty_detector_arn" {
  description = "GuardDuty Detector ARN"
  value       = aws_guardduty_detector.main.arn
}
