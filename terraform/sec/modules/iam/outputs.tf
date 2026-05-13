# terraform/sec/modules/iam/outputs.tf
# 역할: IAM 모듈 출력값 - Instance Profile 이름 노출
# 흐름: main.tf 리소스 → 이 파일 출력값 → compute 모듈 참조

output "thehive_instance_profile_name" {
  description = "TheHive SSM Instance Profile 이름"
  value       = aws_iam_instance_profile.thehive_ssm.name
}
