# terraform/modules/networking/main.tf
# 역할: VPC · 서브넷 · IGW · 라우트 테이블 · ALB SG · RDS SG · Bastion · NAT 인스턴스 생성
# 흐름: variables.tf 입력값 → 전체 네트워크 레이어 생성 → outputs.tf 출력

# ==========================================
# VPC
# ==========================================
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "woowa-beavers-vpc"
  }
}

# ==========================================
# 서브넷
# ==========================================
resource "aws_subnet" "public_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_1_cidr
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "woowa-beavers-subnet-public1-ap-northeast-2a"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_2_cidr
  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "woowa-beavers-subnet-public2-ap-northeast-2c"
  }
}

resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "woowa-beavers-subnet-private1-ap-northeast-2a"
  }
}

resource "aws_subnet" "db_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.db_subnet_1_cidr
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "woowa-beavers-subnet-private2-ap-northeast-2a"
  }
}

resource "aws_subnet" "db_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.db_subnet_2_cidr
  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "woowa-beavers-subnet-db2-ap-northeast-2c"
  }
}

# ==========================================
# Internet Gateway + 퍼블릭 라우트 테이블
# ==========================================
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "woowa-beavers-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "woowa-beavers-rtb-public"
  }
}

resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

# ==========================================
# 프라이빗 라우트 테이블 (EC2 서브넷 → NAT)
# ==========================================
resource "aws_route_table" "private_1" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "woowa-beavers-rtb-private1-ap-northeast-2a"
  }
}

resource "aws_route" "private_1_to_nat" {
  route_table_id         = aws_route_table.private_1.id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = aws_instance.nat.primary_network_interface_id

  depends_on = [aws_instance.nat]
}

resource "aws_route_table_association" "private_1" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private_1.id
}

# ==========================================
# DB 서브넷 라우트 테이블 (인터넷 불필요)
# ==========================================
resource "aws_route_table" "db_1" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "woowa-beavers-rtb-private2-ap-northeast-2a"
  }
}

resource "aws_route_table_association" "db_1" {
  subnet_id      = aws_subnet.db_1.id
  route_table_id = aws_route_table.db_1.id
}

resource "aws_route_table" "db_2" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "woowa-beavers-rtb-db2-ap-northeast-2c"
  }
}

resource "aws_route_table_association" "db_2" {
  subnet_id      = aws_subnet.db_2.id
  route_table_id = aws_route_table.db_2.id
}

# ==========================================
# ALB Security Group
# ==========================================
resource "aws_security_group" "alb_sg" {
  name        = "woowa-beavers-alb-sg"
  description = "ALB security group - HTTP/HTTPS from internet"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP from internet"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS from internet"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "woowa-beavers-alb-sg"
  }
}

# ==========================================
# RDS Security Group
# ==========================================
resource "aws_security_group" "rds_sg" {
  name        = "Woowa-Beavers-RDS-SG"
  description = "RDS security group - MySQL from EC2 private subnet"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.private_subnet_cidr]
    description = "MySQL from EC2 private subnet"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Woowa-Beavers-RDS-SG"
  }
}

# ==========================================
# Bastion Host
# ==========================================
resource "aws_security_group" "bastion_sg" {
  name        = "Bastion Host SG"
  description = "Allow Cloudflare 22"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = concat(var.cloudflare_cidrs, var.team_ssh_cidrs)
    description = "SSH from Cloudflare and team members"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Bastion Host SG"
  }
}

resource "aws_instance" "bastion" {
  ami           = var.bastion_ami_id
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public_1.id
  private_ip    = var.bastion_private_ip
  key_name      = var.bastion_key_name

  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]

  tags = {
    Name = "bastion host"
    Role = "bastion"
  }
}

# ==========================================
# NAT Instance
# ==========================================
resource "aws_security_group" "nat_sg" {
  name        = "NAT Instance SG"
  description = "NAT Instance SG"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.private_subnet_cidr, var.db_subnet_1_cidr, var.db_subnet_2_cidr]
    description = "All traffic from private subnets"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "NAT Instance SG"
  }
}

resource "aws_instance" "nat" {
  ami           = var.nat_ami_id
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public_1.id
  private_ip    = var.nat_private_ip
  key_name      = var.nat_key_name

  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.nat_sg.id]

  source_dest_check = false

  tags = {
    Name = "NAT-Instance-EC2"
    Role = "nat"
  }
}
