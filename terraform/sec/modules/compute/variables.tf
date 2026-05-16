# terraform/sec/modules/compute/variables.tf
# 역할: compute 모듈 입력 변수 정의
# 흐름: 상위 루트 모듈 → 이 파일 변수 → main.tf 리소스

variable "ec2_ami" {
  description = "TheHive EC2 AMI ID (Ubuntu 24.04)"
  type        = string
}

variable "thehive_vpc_id" {
  description = "TheHive VPC ID"
  type        = string
}

variable "thehive_public_subnet_id" {
  description = "TheHive NAT 인스턴스용 퍼블릭 서브넷 ID"
  type        = string
}

variable "thehive_private_subnet_id" {
  description = "TheHive 서버용 프라이빗 서브넷 ID"
  type        = string
}

variable "thehive_admin_cidr" {
  description = "TheHive API 접근 허용 관리자 IP CIDR"
  type        = string
}

variable "thehive_nat_eip_alloc_id" {
  description = "NAT 인스턴스에 연결할 EIP Allocation ID"
  type        = string
}

variable "thehive_instance_profile_name" {
  description = "TheHive EC2 IAM Instance Profile 이름"
  type        = string
}

# ==========================================
# MISP
# ==========================================
variable "misp_ami" {
  description = "MISP EC2 AMI ID (Ubuntu 24.04)"
  type        = string
}

variable "misp_vpc_id" {
  description = "MISP VPC ID"
  type        = string
}

variable "misp_private_subnet_id" {
  description = "MISP 서버용 프라이빗 서브넷 ID"
  type        = string
}

variable "misp_instance_profile_name" {
  description = "MISP EC2 IAM Instance Profile 이름"
  type        = string
}
