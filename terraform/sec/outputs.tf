# terraform/sec/outputs.tf
# 역할: sec 루트 모듈 출력값 - 주요 리소스 정보 노출
# 흐름: 서브 모듈 outputs → 이 파일에서 re-export

output "misp_nat_eip" {
  description = "MISP NAT Gateway EIP"
  value       = module.networking.misp_nat_eip_public_ip
}

output "thehive_instance_id" {
  description = "TheHive 서버 인스턴스 ID (SSM 접속용)"
  value       = module.compute.thehive_instance_id
}

output "thehive_private_ip" {
  description = "TheHive 서버 프라이빗 IP"
  value       = module.compute.thehive_private_ip
}

