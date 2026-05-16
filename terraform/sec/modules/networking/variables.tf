# terraform/sec/modules/networking/variables.tf
# 역할: networking 모듈 입력 변수 정의 (MISP·TheHive VPC/서브넷 CIDR)
# 흐름: 상위 루트 모듈 → 이 파일 변수 → main.tf 리소스

variable "misp_project_name" {
  description = "MISP 프로젝트 이름 (리소스 태그용)"
  type        = string
  default     = "soc-misp"
}

variable "misp_vpc_cidr" {
  description = "MISP VPC CIDR block"
  type        = string
  default     = "10.20.0.0/16"
}

variable "misp_public_subnet_cidr" {
  description = "MISP 퍼블릭 서브넷 CIDR (NAT Gateway용)"
  type        = string
  default     = "10.20.1.0/24"
}

variable "misp_private_subnet_cidr" {
  description = "MISP 프라이빗 서브넷 CIDR (MISP 서버용)"
  type        = string
  default     = "10.20.2.0/24"
}

variable "thehive_vpc_cidr" {
  description = "TheHive VPC CIDR block"
  type        = string
  default     = "10.30.0.0/16"
}

variable "thehive_public_subnet_cidr" {
  description = "TheHive 퍼블릭 서브넷 CIDR (NAT Instance용)"
  type        = string
  default     = "10.30.1.0/24"
}

variable "thehive_private_subnet_cidr" {
  description = "TheHive 프라이빗 서브넷 CIDR (TheHive 서버용)"
  type        = string
  default     = "10.30.2.0/24"
}
