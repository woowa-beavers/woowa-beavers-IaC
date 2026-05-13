variable "bucket_name" {
  description = "S3 Bucket Name"
  type        = string
}

variable "tags" {
  description = "Resource Tags"
  type        = map(string)
  default     = {}
}

variable "bucket_policy" {
  description = "S3 Bucket Policy JSON"
  type        = string
  default     = null
}