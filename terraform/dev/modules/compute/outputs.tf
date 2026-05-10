# terraform/dev/modules/compute/outputs.tf
# 역할: EC2 인스턴스 ID · 프라이빗 IP · SG ID 출력
# 흐름: main.tf 리소스 생성 → 출력값 노출 → cdn 모듈 및 dev/outputs.tf 에서 참조

output "ec2_1_instance_id" {
  description = "EC2-1 instance ID - referenced by ALB target group"
  value       = aws_instance.ec2_1.id
}

output "ec2_1_private_ip" {
  description = "EC2-1 private IP"
  value       = aws_instance.ec2_1.private_ip
}

output "ec2_1_sg_id" {
  description = "EC2-1 SG ID"
  value       = aws_security_group.ec2_1_sg.id
}

output "ec2_2_instance_id" {
  description = "EC2-2 instance ID"
  value       = aws_instance.ec2_2_auth.id
}

output "ec2_2_private_ip" {
  description = "EC2-2 private IP"
  value       = aws_instance.ec2_2_auth.private_ip
}

output "ec2_2_sg_id" {
  description = "EC2-2 SG ID"
  value       = aws_security_group.ec2_2_sg.id
}

output "ec2_3_instance_id" {
  description = "EC2-3 instance ID"
  value       = aws_instance.ec2_3_inventory.id
}

output "ec2_3_private_ip" {
  description = "EC2-3 private IP"
  value       = aws_instance.ec2_3_inventory.private_ip
}

output "ec2_3_sg_id" {
  description = "EC2-3 SG ID"
  value       = aws_security_group.ec2_3_sg.id
}

output "ec2_4_instance_id" {
  description = "EC2-4 instance ID"
  value       = aws_instance.ec2_4_order.id
}

output "ec2_4_private_ip" {
  description = "EC2-4 private IP"
  value       = aws_instance.ec2_4_order.private_ip
}

output "ec2_4_sg_id" {
  description = "EC2-4 SG ID"
  value       = aws_security_group.ec2_4_sg.id
}

output "ec2_5_instance_id" {
  description = "EC2-5 instance ID"
  value       = aws_instance.ec2_5.id
}

output "ec2_5_private_ip" {
  description = "EC2-5 private IP"
  value       = aws_instance.ec2_5.private_ip
}

output "ec2_5_sg_id" {
  description = "EC2-5 SG ID"
  value       = aws_security_group.ec2_5_sg.id
}
