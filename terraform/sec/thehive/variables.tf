# terraform/sec/variables.tf
# 역할: sec 루트 모듈 공통 변수 선언 (리전 등)
# 흐름: terraform.tfvars 값 주입 → 변수 검증 → main.tf 에서 참조

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-2"
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnet_id" {
  description = "NAT Instance Public Subnet ID"
  type        = string
}

variable "private_subnet_id" {
  description = "TheHive Server Private Subnet ID"
  type        = string
}

variable "ec2_ami" {
  description = "EC2 AMI ID"
  type        = string
}

# terraform/sec/variables.tf

variable "nat_security_group_ids" {
  description = "NAT Instance Security Group iD"
  type        = list(string)
}

variable "thehive_security_group_ids" {
  description = "TheHive Server Security Group iD"
  type        = list(string)
}

variable "existing_nat_eip_alloc_id" {
  description = "NAT Instance Elastic IP Allocation ID"
  type        = string
}