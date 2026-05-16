# terraform/modules/networking/outputs.tf
# 역할: VPC · 서브넷 · SG ID 및 Bastion·NAT 정보 출력
# 흐름: main.tf 리소스 생성 → 출력값 노출 → dev/main.tf 에서 compute·database·cdn 모듈로 전달

# -----------------------------------------------
# VPC / 서브넷
# -----------------------------------------------
output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "Public subnet ID list [public_1, public_2] - used by ALB"
  value       = [aws_subnet.public_1.id, aws_subnet.public_2.id]
}

output "private_subnet_id" {
  description = "Private subnet ID - used by EC2 instances"
  value       = aws_subnet.private_1.id
}

output "db_subnet_ids" {
  description = "DB subnet ID list [db_1, db_2] - used by RDS subnet group"
  value       = [aws_subnet.db_1.id, aws_subnet.db_2.id]
}

# -----------------------------------------------
# Security Groups
# -----------------------------------------------
output "alb_sg_id" {
  description = "ALB SG ID - referenced by EC2 inbound rules and ALB"
  value       = aws_security_group.alb_sg.id
}

output "rds_sg_id" {
  description = "RDS SG ID - referenced by RDS instances"
  value       = aws_security_group.rds_sg.id
}

output "bastion_sg_id" {
  description = "Bastion SG ID - referenced by EC2 inbound rules"
  value       = aws_security_group.bastion_sg.id
}

output "nat_sg_id" {
  description = "NAT instance SG ID"
  value       = aws_security_group.nat_sg.id
}

# -----------------------------------------------
# Bastion / NAT
# -----------------------------------------------
output "bastion_public_ip" {
  description = "Bastion public IP"
  value       = aws_instance.bastion.public_ip
}

output "bastion_instance_id" {
  description = "Bastion instance ID"
  value       = aws_instance.bastion.id
}

output "nat_instance_id" {
  description = "NAT instance ID"
  value       = aws_instance.nat.id
}

output "nat_private_ip" {
  description = "NAT instance private IP"
  value       = aws_instance.nat.private_ip
}
