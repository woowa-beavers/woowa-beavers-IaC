# terraform/sec/modules/compute/main.tf
# 역할: sec 계정 컴퓨트 모듈 - Key Pairs·보안그룹·TheHive NAT·서버·MISP 서버 EC2 생성
# 흐름: variables.tf 입력값 → Key Pair → 보안그룹 → NAT Instance → EIP → TheHive 서버 → MISP 서버

# ==========================================
# Key Pairs
# ==========================================
resource "aws_key_pair" "thehive" {
  key_name   = "theHive-server-ec2"
  public_key = var.thehive_public_key

  tags = { Name = "theHive-server-ec2" }
}

resource "aws_key_pair" "misp" {
  key_name   = "misp-ec2-server"
  public_key = var.misp_public_key

  tags = { Name = "misp-ec2-server" }
}

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
  ami           = var.ec2_ami
  instance_type = "t3.nano"
  subnet_id     = var.thehive_public_subnet_id

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
# TheHive NAT Instance EIP
# ==========================================
resource "aws_eip" "thehive_nat" {
  domain = "vpc"

  tags = { Name = "thehive-nat-eip" }
}

resource "aws_eip_association" "thehive_nat" {
  instance_id   = aws_instance.thehive_nat.id
  allocation_id = aws_eip.thehive_nat.id
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
  ami           = var.ec2_ami
  instance_type = "t3.large"
  subnet_id     = var.thehive_private_subnet_id
  key_name      = aws_key_pair.thehive.key_name

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
# MISP Server
# ==========================================
resource "aws_instance" "misp" {
  ami           = var.misp_ami
  instance_type = "t3a.medium"
  subnet_id     = var.misp_private_subnet_id
  key_name      = aws_key_pair.misp.key_name

  vpc_security_group_ids = [aws_security_group.misp.id]
  iam_instance_profile   = var.misp_instance_profile_name

  root_block_device {
    volume_size = 16
    volume_type = "gp3"
    tags        = { Name = "misp-server-root-vol" }
  }

  tags = { Name = "MISP" }
}
