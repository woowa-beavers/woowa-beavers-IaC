# terraform/modules/storage/outputs.tf
# 역할: storage 모듈 출력값 - 버킷 ID·ARN 노출
# 흐름: main.tf 리소스 → 이 파일 출력값 → 상위 루트 모듈 참조

output "bucket_id" {
  description = "S3 버킷 ID"
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "S3 버킷 ARN"
  value       = aws_s3_bucket.this.arn
}
