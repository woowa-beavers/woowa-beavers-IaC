# terraform/sec/misp/main.tf
# 역할: 기존 MISP VPC/Subnet을 조회하고, NAT Gateway 기반 outbound 경로 구성

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# 기존 MISP VPC 조회
data "aws_vpc" "misp" {
  tags = {
    Name = var.vpc_name
  }
}

# 기존 Public Subnet 조회
# NAT Gateway가 배치될 서브넷
data "aws_subnet" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.misp.id]
  }

  tags = {
    Name = var.public_subnet_name
  }
}

# 기존 Private Subnet 조회
# MISP EC2가 위치한 서브넷
data "aws_subnet" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.misp.id]
  }

  tags = {
    Name = var.private_subnet_name
  }
}

# Private Subnet에 연결된 Route Table 조회
data "aws_route_table" "private" {
  subnet_id = data.aws_subnet.private.id
}

# NAT Gateway용 Elastic IP
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = merge(var.tags, {
    Name = "${var.project_name}-nat-eip"
  })
}

# NAT Gateway
resource "aws_nat_gateway" "misp" {
  allocation_id = aws_eip.nat.id
  subnet_id     = data.aws_subnet.public.id

  tags = merge(var.tags, {
    Name = "${var.project_name}-nat-gateway"
  })
}

# Private Subnet의 기본 경로를 NAT Gateway로 설정
resource "aws_route" "private_default_to_nat" {
  route_table_id         = data.aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.misp.id
}