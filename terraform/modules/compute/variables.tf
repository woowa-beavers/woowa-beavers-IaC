# terraform/modules/compute/variables.tf
# 역할: compute 모듈 입력 변수 선언 (EC2 인스턴스 설정값)
# 흐름: environments/dev/main.tf 에서 전달 → 변수 검증 → main.tf 에서 참조

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "private_subnet_id" {
  description = "Private subnet ID for EC2 instances"
  type        = string
}

variable "bastion_sg_id" {
  description = "Bastion SG ID - allows SSH"
  type        = string
}

variable "alb_sg_id" {
  description = "ALB SG ID - allows port 8000"
  type        = string
}

# -----------------------------------------------
# EC2-1 Product
# -----------------------------------------------
variable "ec2_1_ami_id" {
  description = "EC2-1 AMI ID"
  type        = string
}

variable "ec2_1_key_name" {
  description = "EC2 key pair name for EC2-1"
  type        = string
  default     = "woowa-beavers-keypair"
}

variable "ec2_1_private_ip" {
  description = "EC2-1 private IP"
  type        = string
}

# -----------------------------------------------
# EC2-2 Auth
# -----------------------------------------------
variable "ec2_2_ami_id" {
  description = "EC2-2 AMI ID"
  type        = string
}

variable "ec2_2_key_name" {
  description = "EC2 key pair name for EC2-2"
  type        = string
  default     = "woowa-beavers-keypair"
}

variable "ec2_2_private_ip" {
  description = "EC2-2 private IP"
  type        = string
  default     = "10.0.2.233"
}

# -----------------------------------------------
# EC2-3 Inventory
# -----------------------------------------------
variable "ec2_3_ami_id" {
  description = "EC2-3 inventory AMI ID"
  type        = string
}

variable "ec2_3_key_name" {
  description = "EC2 key pair name for EC2-3"
  type        = string
  default     = "woowa-beavers-keypair"
}

variable "ec2_3_private_ip" {
  description = "EC2-3 private IP"
  type        = string
  default     = "10.0.2.33"
}

# -----------------------------------------------
# EC2-4 Order
# -----------------------------------------------
variable "ec2_4_ami_id" {
  description = "EC2-4 order AMI ID"
  type        = string
}

variable "ec2_4_key_name" {
  description = "EC2 key pair name for EC2-4"
  type        = string
  default     = "woowa-beavers-keypair"
}

variable "ec2_4_private_ip" {
  description = "EC2-4 private IP"
  type        = string
  default     = "10.0.2.74"
}

# -----------------------------------------------
# EC2-5
# -----------------------------------------------
variable "ec2_5_ami_id" {
  description = "EC2-5 AMI ID"
  type        = string
}

variable "ec2_5_key_name" {
  description = "EC2 key pair name for EC2-5"
  type        = string
  default     = "woowa-beavers-keypair"
}

variable "ec2_5_private_ip" {
  description = "EC2-5 private IP"
  type        = string
}
