# terraform/dev/modules/cdn/outputs.tf
# 역할: ALB DNS · ARN · 타겟 그룹 ARN(EC2 1~5) 출력
# 흐름: main.tf 리소스 생성 → 출력값 노출 → dev/outputs.tf 및 Cloudflare DNS 에서 참조

output "alb_dns_name" {
  description = "ALB DNS name"
  value       = aws_lb.main.dns_name
}

output "alb_arn" {
  description = "ALB ARN"
  value       = aws_lb.main.arn
}

output "alb_sg_id" {
  description = "ALB SG ID - referenced by EC2 inbound rules"
  value       = var.alb_sg_id
}

output "target_group_ec2_1_arn" {
  description = "EC2-1 target group ARN (product)"
  value       = aws_lb_target_group.ec2_1.arn
}

output "target_group_ec2_2_arn" {
  description = "EC2-2 target group ARN (auth)"
  value       = data.aws_lb_target_group.ec2_2.arn
}

output "target_group_ec2_3_arn" {
  description = "EC2-3 target group ARN (inventory)"
  value       = data.aws_lb_target_group.ec2_3.arn
}

output "target_group_ec2_4_arn" {
  description = "EC2-4 target group ARN (order)"
  value       = data.aws_lb_target_group.ec2_4.arn
}

output "target_group_ec2_5_arn" {
  description = "EC2-5 target group ARN"
  value       = data.aws_lb_target_group.ec2_5.arn
}
