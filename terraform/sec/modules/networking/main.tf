# terraform/sec/modules/networking/main.tf
# 역할: sec 계정 네트워킹 - MISP VPC/서브넷/IGW/NAT GW, TheHive VPC/서브넷/IGW 전체 생성
# 흐름: variables.tf 입력값 → VPC·서브넷·IGW·라우트 테이블 생성 → NAT GW → outputs.tf 출력

data "aws_availability_zones" "available" {
  state = "available"
}

# ==========================================
# MISP VPC
# ==========================================
resource "aws_vpc" "misp" {
  cidr_block           = var.misp_vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name      = "soc-misp-vpc"
    Project   = var.misp_project_name
    ManagedBy = "terraform"
  }
}

resource "aws_internet_gateway" "misp" {
  vpc_id = aws_vpc.misp.id

  tags = {
    Name      = "${var.misp_project_name}-igw"
    Project   = var.misp_project_name
    ManagedBy = "terraform"
  }
}

resource "aws_subnet" "misp_public" {
  vpc_id            = aws_vpc.misp.id
  cidr_block        = var.misp_public_subnet_cidr
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name      = "misp-public-subnet-${data.aws_availability_zones.available.names[0]}"
    Project   = var.misp_project_name
    ManagedBy = "terraform"
  }
}

resource "aws_subnet" "misp_private" {
  vpc_id            = aws_vpc.misp.id
  cidr_block        = var.misp_private_subnet_cidr
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name      = "misp-private-subnet-${data.aws_availability_zones.available.names[0]}"
    Project   = var.misp_project_name
    ManagedBy = "terraform"
  }
}

resource "aws_route_table" "misp_public" {
  vpc_id = aws_vpc.misp.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.misp.id
  }

  tags = {
    Name      = "${var.misp_project_name}-public-rtb"
    Project   = var.misp_project_name
    ManagedBy = "terraform"
  }
}

resource "aws_route_table_association" "misp_public" {
  subnet_id      = aws_subnet.misp_public.id
  route_table_id = aws_route_table.misp_public.id
}

resource "aws_route_table" "misp_private" {
  vpc_id = aws_vpc.misp.id

  tags = {
    Name      = "${var.misp_project_name}-private-rtb"
    Project   = var.misp_project_name
    ManagedBy = "terraform"
  }
}

resource "aws_route_table_association" "misp_private" {
  subnet_id      = aws_subnet.misp_private.id
  route_table_id = aws_route_table.misp_private.id
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
  subnet_id     = aws_subnet.misp_public.id

  tags = {
    Name      = "${var.misp_project_name}-nat-gateway"
    Project   = var.misp_project_name
    ManagedBy = "terraform"
  }
}

resource "aws_route" "misp_private_to_nat" {
  route_table_id         = aws_route_table.misp_private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.misp.id
}

# ==========================================
# TheHive VPC
# ==========================================
resource "aws_vpc" "thehive" {
  cidr_block           = var.thehive_vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name      = "thehive-vpc"
    ManagedBy = "terraform"
  }
}

resource "aws_internet_gateway" "thehive" {
  vpc_id = aws_vpc.thehive.id

  tags = {
    Name      = "thehive-igw"
    ManagedBy = "terraform"
  }
}

resource "aws_subnet" "thehive_public" {
  vpc_id            = aws_vpc.thehive.id
  cidr_block        = var.thehive_public_subnet_cidr
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name      = "thehive-public-subnet"
    ManagedBy = "terraform"
  }
}

resource "aws_subnet" "thehive_private" {
  vpc_id            = aws_vpc.thehive.id
  cidr_block        = var.thehive_private_subnet_cidr
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name      = "thehive-private-subnet"
    ManagedBy = "terraform"
  }
}

resource "aws_route_table" "thehive_public" {
  vpc_id = aws_vpc.thehive.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.thehive.id
  }

  tags = {
    Name      = "thehive-public-rtb"
    ManagedBy = "terraform"
  }
}

resource "aws_route_table_association" "thehive_public" {
  subnet_id      = aws_subnet.thehive_public.id
  route_table_id = aws_route_table.thehive_public.id
}
