# terraform/cloudflare/outputs.tf
# 역할: Cloudflare 모듈 출력값 - DNS 레코드 호스트명 노출
# 흐름: main.tf 리소스 → 이 파일 출력값 → 운영·모니터링 참조

output "bastion_hostname" {
  description = "Bastion 터널 DNS 호스트명"
  value       = cloudflare_record.bastion.hostname
}

output "cortex_hostname" {
  description = "Cortex 터널 DNS 호스트명"
  value       = cloudflare_record.cortex.hostname
}

output "misp_hostname" {
  description = "MISP 터널 DNS 호스트명"
  value       = cloudflare_record.misp.hostname
}

output "n8n_hostname" {
  description = "n8n 터널 DNS 호스트명"
  value       = cloudflare_record.n8n.hostname
}

output "thehive_hostname" {
  description = "TheHive 터널 DNS 호스트명"
  value       = cloudflare_record.thehive.hostname
}

output "velociraptor_hostname" {
  description = "Velociraptor 터널 DNS 호스트명"
  value       = cloudflare_record.velociraptor.hostname
}

output "wazuh_hostname" {
  description = "Wazuh 터널 DNS 호스트명"
  value       = cloudflare_record.wazuh.hostname
}

output "shop_hostname" {
  description = "Shop CNAME DNS 호스트명"
  value       = cloudflare_record.shop.hostname
}

output "www_hostname" {
  description = "WWW CNAME DNS 호스트명"
  value       = cloudflare_record.www.hostname
}
