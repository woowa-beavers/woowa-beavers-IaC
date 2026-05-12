# terraform/sec/outputs.tf
# 역할: sec 루트 모듈 출력 정의 (현재 미사용, 필요 시 서브 모듈 출력값을 상위로 노출)
# 흐름: 서브 모듈 outputs → 이 파일에서 re-export → 외부 참조

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