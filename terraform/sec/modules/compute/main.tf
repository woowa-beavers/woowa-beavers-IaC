# terraform/sec/modules/compute/main.tf
# 역할: sec 계정 컴퓨트 모듈 - 보안그룹·TheHive NAT 인스턴스·서버·MISP 서버 EC2 생성 및 라우팅 구성
# 흐름: variables.tf 입력값 → 보안그룹 생성 → NAT Instance → Route Table → TheHive 서버 → EIP 연결 → MISP 서버

# ==========================================
# TheHive NAT Instance Security Group
# ==========================================
resource "aws_security_group" "thehive_nat" {
  name        = "thehive-nat-sg"
  description = "TheHive NAT 인스턴스 보안그룹"
  vpc_id      = var.thehive_vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.30.2.0/24"]
    description = "Allow all from TheHive private subnet"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "thehive-nat-sg" }
}

# ==========================================
# TheHive Server Security Group
# ==========================================
resource "aws_security_group" "thehive" {
  name        = "thehive-sg"
  description = "TheHive 서버 보안그룹"
  vpc_id      = var.thehive_vpc_id

  ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["10.30.2.0/24"]
    description = "TheHive API from private subnet"
  }

  ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = [var.thehive_admin_cidr]
    description = "TheHive API from admin IP"
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.30.1.0/24"]
    description = "Allow all from TheHive public subnet"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "thehive-sg" }
}

# ==========================================
# MISP Server Security Group
# ==========================================
resource "aws_security_group" "misp" {
  name        = "misp-sg"
  description = "MISP 서버 보안그룹"
  vpc_id      = var.misp_vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.20.1.0/24"]
    description = "Allow all from MISP public subnet"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "misp-sg" }
}

# ==========================================
# TheHive NAT Instance
# ==========================================
resource "aws_instance" "thehive_nat" {
  ami               = var.ec2_ami
  instance_type     = "t3.nano"
  subnet_id         = var.thehive_public_subnet_id
  availability_zone = "ap-northeast-2d"

  vpc_security_group_ids = [aws_security_group.thehive_nat.id]
  iam_instance_profile   = var.thehive_instance_profile_name
  source_dest_check      = false

  root_block_device {
    volume_size = 8
    volume_type = "gp3"
    tags        = { Name = "thehive-nat-root-vol" }
  }

  user_data = <<-EOF
              #!/bin/bash
              sysctl -w net.ipv4.ip_forward=1
              /sbin/iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
              EOF

  tags = { Name = "thehive-nat-instance" }
}

# ==========================================
# TheHive Private Route Table
# ==========================================
resource "aws_route_table" "thehive_private" {
  vpc_id = var.thehive_vpc_id

  route {
    cidr_block           = "0.0.0.0/0"
    network_interface_id = aws_instance.thehive_nat.primary_network_interface_id
  }

  tags = { Name = "thehive-private-rt" }
}

resource "aws_route_table_association" "thehive_private" {
  subnet_id      = var.thehive_private_subnet_id
  route_table_id = aws_route_table.thehive_private.id
}

# ==========================================
# TheHive Server
# ==========================================
resource "aws_instance" "thehive" {
  ami               = var.ec2_ami
  instance_type     = "t3.large"
  subnet_id         = var.thehive_private_subnet_id
  availability_zone = "ap-northeast-2d"
  key_name          = "theHive-server-ec2"

  vpc_security_group_ids = [aws_security_group.thehive.id]
  iam_instance_profile   = var.thehive_instance_profile_name

  root_block_device {
    volume_size = 64
    volume_type = "gp3"
    tags        = { Name = "thehive-server-root-vol" }
  }

  tags = { Name = "theHive" }
}

# ==========================================
# NAT Instance EIP
# ==========================================
data "aws_eip" "thehive_nat" {
  id = var.thehive_nat_eip_alloc_id
}

resource "aws_eip_association" "thehive_nat" {
  instance_id   = aws_instance.thehive_nat.id
  allocation_id = data.aws_eip.thehive_nat.id
}

# ==========================================
# MISP Server
# ==========================================
resource "aws_instance" "misp" {
  ami               = var.misp_ami
  instance_type     = "t3a.medium"
  subnet_id         = var.misp_private_subnet_id
  availability_zone = "ap-northeast-2a"
  key_name          = "misp-ec2-server"

  vpc_security_group_ids = [aws_security_group.misp.id]
  iam_instance_profile   = var.misp_instance_profile_name

  root_block_device {
    volume_size = 16
    volume_type = "gp3"
    tags        = { Name = "misp-server-root-vol" }
  }

  tags = { Name = "MISP" }
}
