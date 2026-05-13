# terraform/sec/modules/networking/variables.tf
# 역할: networking 모듈 입력 변수 정의
# 흐름: 상위 루트 모듈 → 이 파일 변수 → main.tf 리소스

variable "misp_vpc_name" {
  description = "MISP VPC Name 태그"
  type        = string
}

variable "misp_public_subnet_name" {
  description = "MISP NAT Gateway용 퍼블릭 서브넷 Name 태그"
  type        = string
}

variable "misp_private_subnet_name" {
  description = "MISP EC2가 위치한 프라이빗 서브넷 Name 태그"
  type        = string
}

variable "misp_project_name" {
  description = "MISP 프로젝트 이름 (리소스 태그용)"
  type        = string
  default     = "soc-misp"
}
