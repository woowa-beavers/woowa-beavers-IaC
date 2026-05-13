# terraform/sec/modules/networking/main.tf
# 역할: sec 계정 네트워킹 모듈 - MISP VPC/서브넷 조회, NAT Gateway 구성
# 흐름: variables.tf 입력값 → VPC·Subnet 조회 → EIP·NAT Gateway 생성 → Private Route 추가

# ==========================================
# MISP VPC / Subnet 조회
# ==========================================
data "aws_vpc" "misp" {
  tags = {
    Name = var.misp_vpc_name
  }
}

data "aws_subnet" "misp_public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.misp.id]
  }

  tags = {
    Name = var.misp_public_subnet_name
  }
}

data "aws_subnet" "misp_private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.misp.id]
  }

  tags = {
    Name = var.misp_private_subnet_name
  }
}

data "aws_route_table" "misp_private" {
  subnet_id = data.aws_subnet.misp_private.id
}

# ==========================================
# MISP NAT Gateway
# ==========================================
resource "aws_eip" "misp_nat" {
  domain = "vpc"

  tags = {
    Name      = "${var.misp_project_name}-nat-eip"
    Project   = var.misp_project_name
    ManagedBy = "terraform"
  }
}

resource "aws_nat_gateway" "misp" {
  allocation_id = aws_eip.misp_nat.id
  subnet_id     = data.aws_subnet.misp_public.id

  tags = {
    Name      = "${var.misp_project_name}-nat-gateway"
    Project   = var.misp_project_name
    ManagedBy = "terraform"
  }
}

resource "aws_route" "misp_private_to_nat" {
  route_table_id         = data.aws_route_table.misp_private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.misp.id
}
