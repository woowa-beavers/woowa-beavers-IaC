# terraform/sec/misp/variables.tf

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-2"
}

variable "project_name" {
  description = "Project name for MISP resources"
  type        = string
  default     = "soc-misp"
}

variable "vpc_name" {
  description = "Existing MISP VPC Name tag"
  type        = string
}

variable "public_subnet_name" {
  description = "Existing public subnet Name tag for NAT Gateway"
  type        = string
}

variable "private_subnet_name" {
  description = "Existing private subnet Name tag where MISP EC2 is placed"
  type        = string
}

variable "tags" {
  description = "Common tags"
  type        = map(string)

  default = {
    Project     = "soc-misp"
    Environment = "sec"
    Service     = "misp"
    ManagedBy   = "terraform"
  }
}
