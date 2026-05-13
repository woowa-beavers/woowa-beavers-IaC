# terraform/modules/storage/variables.tf
# 역할: storage 모듈 입력 변수 정의
# 흐름: 상위 루트 모듈 → 이 파일 변수 → main.tf 리소스

variable "bucket_name" {
  description = "S3 버킷 이름"
  type        = string
}

variable "tags" {
  description = "리소스 태그"
  type        = map(string)
  default     = {}
}

variable "bucket_policy" {
  description = "S3 버킷 정책 JSON"
  type        = string
  default     = null
}
