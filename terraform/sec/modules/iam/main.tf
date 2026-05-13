# terraform/sec/modules/iam/main.tf
# 역할: sec 계정 IAM 모듈 - TheHive SSM 접근용 IAM Role 및 Instance Profile 관리
# 흐름: 기존 IAM Role 조회 → Instance Profile 생성

data "aws_iam_role" "thehive_ssm" {
  name = "thehive-ssm-role"
}

resource "aws_iam_instance_profile" "thehive_ssm" {
  name = "thehive-ssm-profile"
  role = data.aws_iam_role.thehive_ssm.name
}
