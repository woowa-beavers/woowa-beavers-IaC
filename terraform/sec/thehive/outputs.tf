# terraform/sec/thehive/outputs.tf
# 역할: TheHive 모듈 출력값 정의
# 흐름: main.tf 리소스 → output 블록 → 외부 참조 가능

output "nat_public_ip" {
  description = "NAT Instance Public IP"
  value       = aws_instance.nat.public_ip
}

output "thehive_private_ip" {
  description = "TheHive Server Private IP"
  value       = aws_instance.thehive.private_ip
}

output "thehive_instance_id" {
  description = "TheHive Server Instance ID (SSM)"
  value       = aws_instance.thehive.id
}