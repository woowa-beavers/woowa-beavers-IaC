# terraform/modules/cdn/variables.tf
# 역할: cdn 모듈 입력 변수 선언 (ALB · 서브넷 · SG · EC2 ID · ACM 인증서 · X-Origin-Secret)
# 흐름: environments/dev/main.tf 에서 전달 → 변수 검증 → main.tf 에서 참조

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs for ALB (different AZs, 2 or more)"
  type        = list(string)
}

variable "alb_sg_id" {
  description = "ALB security group ID"
  type        = string
}

variable "ec2_1_instance_id" {
  description = "EC2-1 instance ID - attached to target group"
  type        = string
}

variable "certificate_arn" {
  description = "ACM certificate ARN for HTTPS listener"
  type        = string
}

variable "x_origin_secret" {
  description = "Cloudflare X-Origin-Secret 헤더 값 — ALB 라우팅 검증용 (GitHub Secrets로 주입)"
  type        = string
  sensitive   = true
}
