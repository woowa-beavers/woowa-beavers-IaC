# terraform/sec/modules/compute/outputs.tf
# 역할: compute 모듈 출력값 - EC2 인스턴스 정보 노출
# 흐름: main.tf 리소스 → 이 파일 출력값 → 상위 루트 모듈 참조

output "thehive_nat_public_ip" {
  description = "TheHive NAT 인스턴스 퍼블릭 IP"
  value       = aws_instance.thehive_nat.public_ip
}

output "thehive_private_ip" {
  description = "TheHive 서버 프라이빗 IP"
  value       = aws_instance.thehive.private_ip
}

output "thehive_instance_id" {
  description = "TheHive 서버 인스턴스 ID (SSM 접속용)"
  value       = aws_instance.thehive.id
}

output "misp_private_ip" {
  description = "MISP 서버 프라이빗 IP"
  value       = aws_instance.misp.private_ip
}

output "misp_instance_id" {
  description = "MISP 서버 인스턴스 ID (SSM 접속용)"
  value       = aws_instance.misp.id
}
