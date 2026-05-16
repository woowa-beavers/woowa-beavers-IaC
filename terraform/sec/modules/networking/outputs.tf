# terraform/sec/modules/networking/outputs.tf
# 역할: networking 모듈 출력값 - MISP·TheHive VPC/서브넷/NAT 정보 노출
# 흐름: main.tf 리소스 → 이 파일 출력값 → 상위 루트 모듈 참조

output "misp_vpc_id" {
  description = "MISP VPC ID"
  value       = aws_vpc.misp.id
}

output "misp_public_subnet_id" {
  description = "MISP 퍼블릭 서브넷 ID"
  value       = aws_subnet.misp_public.id
}

output "misp_private_subnet_id" {
  description = "MISP 프라이빗 서브넷 ID"
  value       = aws_subnet.misp_private.id
}

output "misp_nat_gateway_id" {
  description = "MISP NAT Gateway ID"
  value       = aws_nat_gateway.misp.id
}

output "misp_nat_eip_public_ip" {
  description = "MISP NAT Gateway EIP"
  value       = aws_eip.misp_nat.public_ip
}

output "thehive_vpc_id" {
  description = "TheHive VPC ID"
  value       = aws_vpc.thehive.id
}

output "thehive_public_subnet_id" {
  description = "TheHive 퍼블릭 서브넷 ID"
  value       = aws_subnet.thehive_public.id
}

output "thehive_private_subnet_id" {
  description = "TheHive 프라이빗 서브넷 ID"
  value       = aws_subnet.thehive_private.id
}
