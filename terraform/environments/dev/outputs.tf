# terraform/environments/dev/outputs.tf
# 역할: dev 루트 모듈 핵심 출력값 노출 (각 모듈 output 취합)
# 흐름: 각 모듈 outputs → 이 파일에서 re-export → 운영·모니터링 참조

# -----------------------------------------------
# Networking
# -----------------------------------------------
output "bastion_public_ip" {
  description = "Bastion public IP"
  value       = module.networking.bastion_public_ip
}

output "bastion_sg_id" {
  description = "Bastion SG ID"
  value       = module.networking.bastion_sg_id
}

output "nat_private_ip" {
  description = "NAT instance private IP"
  value       = module.networking.nat_private_ip
}

# -----------------------------------------------
# Compute
# -----------------------------------------------
output "ec2_1_instance_id" {
  description = "EC2-1 instance ID"
  value       = module.compute.ec2_1_instance_id
}

output "ec2_2_instance_id" {
  description = "EC2-2 instance ID"
  value       = module.compute.ec2_2_instance_id
}

output "ec2_3_instance_id" {
  description = "EC2-3 instance ID"
  value       = module.compute.ec2_3_instance_id
}

output "ec2_4_instance_id" {
  description = "EC2-4 instance ID"
  value       = module.compute.ec2_4_instance_id
}

# -----------------------------------------------
# CDN
# -----------------------------------------------
output "alb_dns_name" {
  description = "ALB DNS name"
  value       = module.cdn.alb_dns_name
}
