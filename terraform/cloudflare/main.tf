# terraform/cloudflare/main.tf
# 역할: Cloudflare DNS 레코드 관리 (woowabeavers.cloud)
# 흐름: variables.tf 입력값 → provider 초기화 → Tunnel CNAME·일반 CNAME 레코드 생성

terraform {
  required_version = "1.15.3"

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    bucket = "woowa-beavers-tfstate"
    key    = "cloudflare/terraform.tfstate"
    region = "ap-northeast-2"
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

# ==========================================
# Tunnel CNAME 레코드
# ==========================================
resource "cloudflare_record" "bastion" {
  zone_id = var.cloudflare_zone_id
  name    = "bastion"
  content = "${var.tunnel_id_bastion}.cfargotunnel.com"
  type    = "CNAME"
  proxied = true
  ttl     = 1
}

resource "cloudflare_record" "cortex" {
  zone_id = var.cloudflare_zone_id
  name    = "cortex"
  content = "${var.tunnel_id_thehive}.cfargotunnel.com"
  type    = "CNAME"
  proxied = true
  ttl     = 1
}

resource "cloudflare_record" "misp" {
  zone_id = var.cloudflare_zone_id
  name    = "misp"
  content = "${var.tunnel_id_misp}.cfargotunnel.com"
  type    = "CNAME"
  proxied = true
  ttl     = 1
}

resource "cloudflare_record" "n8n" {
  zone_id = var.cloudflare_zone_id
  name    = "n8n"
  content = "${var.tunnel_id_n8n}.cfargotunnel.com"
  type    = "CNAME"
  proxied = true
  ttl     = 1
}

resource "cloudflare_record" "thehive" {
  zone_id = var.cloudflare_zone_id
  name    = "thehive"
  content = "${var.tunnel_id_thehive}.cfargotunnel.com"
  type    = "CNAME"
  proxied = true
  ttl     = 1
}

resource "cloudflare_record" "velociraptor" {
  zone_id = var.cloudflare_zone_id
  name    = "velociraptor"
  content = "${var.tunnel_id_velociraptor}.cfargotunnel.com"
  type    = "CNAME"
  proxied = true
  ttl     = 1
}

resource "cloudflare_record" "wazuh" {
  zone_id = var.cloudflare_zone_id
  name    = "wazuh"
  content = "${var.tunnel_id_wazuh}.cfargotunnel.com"
  type    = "CNAME"
  proxied = true
  ttl     = 1
}

# ==========================================
# CNAME 레코드
# ==========================================
resource "cloudflare_record" "shop" {
  zone_id = var.cloudflare_zone_id
  name    = "shop"
  content = var.shop_cname_target
  type    = "CNAME"
  proxied = true
  ttl     = 1
}

resource "cloudflare_record" "www" {
  zone_id = var.cloudflare_zone_id
  name    = "www"
  content = "woowabeavers.cloud"
  type    = "CNAME"
  proxied = true
  ttl     = 1
}
