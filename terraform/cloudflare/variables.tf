# terraform/cloudflare/variables.tf
# 역할: Cloudflare 모듈 입력 변수 선언 (API 토큰, Zone ID, Tunnel ID 등)
# 흐름: terraform.tfvars 값 주입 → 변수 검증 → main.tf 에서 참조

variable "cloudflare_api_token" {
  description = "Cloudflare API token"
  type        = string
  sensitive   = true
}

variable "cloudflare_zone_id" {
  description = "Cloudflare Zone ID (woowabeavers.cloud)"
  type        = string
}

# ==========================================
# Tunnel ID
# ==========================================
variable "tunnel_id_bastion" {
  description = "woowa-beavers-shop-bastion 터널 ID"
  type        = string
}

variable "tunnel_id_thehive" {
  description = "thehive 터널 ID (cortex·thehive DNS 레코드 공용)"
  type        = string
}

variable "tunnel_id_misp" {
  description = "misp 터널 ID"
  type        = string
}

variable "tunnel_id_n8n" {
  description = "n8n 터널 ID"
  type        = string
}

variable "tunnel_id_velociraptor" {
  description = "velociraptor 터널 ID"
  type        = string
}

variable "tunnel_id_wazuh" {
  description = "wazuh 터널 ID"
  type        = string
}

# ==========================================
# CNAME
# ==========================================
variable "shop_cname_target" {
  description = "shop 서브도메인 CNAME 대상 (CloudFront 도메인)"
  type        = string
}
