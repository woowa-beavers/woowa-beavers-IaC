# terraform/sec/modules/iam/main.tf
# 역할: sec 계정 IAM 모듈 - TheHive SSM 접근용 IAM Role 및 Instance Profile 관리
# 흐름: IAM Role 생성 → Instance Profile 생성 → compute 모듈에서 참조

resource "aws_iam_role" "thehive_ssm" {
  name        = "thehive-ssm-role"
  description = "Allows EC2 instances to call AWS services on your behalf."

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Service = "ec2.amazonaws.com" }
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "thehive_ssm" {
  role       = aws_iam_role.thehive_ssm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "thehive_ssm" {
  name = "thehive-ssm-role"
  role = aws_iam_role.thehive_ssm.name
}
