# terraform/sec/misp/outputs.tf
# 역할: MISP NAT Gateway 모듈 출력값 정의
# 흐름: main.tf 리소스·데이터 소스 → output 블록 → 외부 참조 가능

output "vpc_id" {
  description = "Existing MISP VPC ID"
  value       = data.aws_vpc.misp.id
}

output "public_subnet_id" {
  description = "Existing public subnet ID"
  value       = data.aws_subnet.public.id
}

output "private_subnet_id" {
  description = "Existing private subnet ID"
  value       = data.aws_subnet.private.id
}

output "private_route_table_id" {
  description = "Private route table ID"
  value       = data.aws_route_table.private.id
}

output "nat_gateway_id" {
  description = "MISP NAT Gateway ID"
  value       = aws_nat_gateway.misp.id
}

output "nat_eip_public_ip" {
  description = "Elastic IP address for MISP NAT Gateway"
  value       = aws_eip.nat.public_ip
}