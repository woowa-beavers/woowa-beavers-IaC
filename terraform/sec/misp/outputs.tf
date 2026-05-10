# terraform/sec/misp/outputs.tf

output "vpc_id" {
  description = "Existing MISP VPC ID"
  value       = data.aws_vpc.misp.id
}

output "public_subnet_id" {
  description = "Existing public subnet ID"
  value       = data.aws_subnet.public.id
}

output "private_subnet_id" {
  description = "Existing private subnet ID"
  value       = data.aws_subnet.private.id
}

output "private_route_table_id" {
  description = "Private route table ID"
  value       = data.aws_route_table.private.id
}

output "nat_gateway_id" {
  description = "MISP NAT Gateway ID"
  value       = aws_nat_gateway.misp.id
}

output "nat_eip_public_ip" {
  description = "Elastic IP address for MISP NAT Gateway"
  value       = aws_eip.nat.public_ip
}