# terraform/modules/networking/outputs.tf
# 역할: Bastion SG ID · 공인 IP · NAT IP 출력
# 흐름: main.tf 리소스 생성 → 출력값 노출 → compute 모듈 및 dev/outputs.tf 에서 참조

output "bastion_sg_id" {
  description = "Bastion SG ID - referenced by EC2 inbound rules"
  value       = aws_security_group.bastion_sg.id
}

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
  description = "NAT instance private IP - referenced by routing table"
  value       = aws_instance.nat.private_ip
}

output "nat_sg_id" {
  description = "NAT instance SG ID"
  value       = aws_security_group.nat_sg.id
}
