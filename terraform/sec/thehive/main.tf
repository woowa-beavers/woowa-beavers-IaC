# terraform/sec/thehive/main.tf
# 역할: TheHive EC2 인스턴스 및 NAT 인스턴스 생성, Private Route Table 구성
# 흐름: variables.tf 입력값 → IAM Profile → NAT Instance·TheHive Server 생성 → Route Table 연결 → EIP 할당

terraform {
  required_version = "1.15.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.44"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# ==========================================
# 1. IAM Profile 
# ==========================================
data "aws_iam_role" "existing_ssm_role" {
  name = "thehive-ssm-role"
}

resource "aws_iam_instance_profile" "ssm_profile" {
  name = "thehive-ssm-profile"
  role = data.aws_iam_role.existing_ssm_role.name
}

# ==========================================
# 2. EC2 Instances & Routing
# ==========================================

# NAT Instance
resource "aws_instance" "nat" {
  ami                    = var.ec2_ami
  instance_type          = "t3.nano"
  subnet_id              = var.public_subnet_id
  availability_zone      = "ap-northeast-2d"
  
  vpc_security_group_ids = var.nat_security_group_ids
  iam_instance_profile   = aws_iam_instance_profile.ssm_profile.name
  source_dest_check      = false 

  # EBS
  root_block_device {
    volume_size = 8
    volume_type = "gp3"
    tags = { Name = "thehive-nat-root-vol" }
  }

  user_data = <<-EOF
              #!/bin/bash
              sysctl -w net.ipv4.ip_forward=1
              /sbin/iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
              EOF

  tags = { Name = "thehive-nat-instance" }
}

# Private Route Table (TheHive -> NAT)
resource "aws_route_table" "private" {
  vpc_id = var.vpc_id
  
  route {
    cidr_block           = "0.0.0.0/0"
    network_interface_id = aws_instance.nat.primary_network_interface_id
  }
  
  tags = { Name = "thehive-private-rt" }
}

resource "aws_route_table_association" "private" {
  subnet_id      = var.private_subnet_id
  route_table_id = aws_route_table.private.id
}

# TheHive Server
resource "aws_instance" "thehive" {
  ami                    = var.ec2_ami
  instance_type          = "t3.large"
  subnet_id              = var.private_subnet_id
  availability_zone      = "ap-northeast-2d"
  
  vpc_security_group_ids = var.thehive_security_group_ids
  iam_instance_profile   = aws_iam_instance_profile.ssm_profile.name

  # EBS
  root_block_device {
    volume_size = 64
    volume_type = "gp3"
    tags = { Name = "thehive-server-root-vol" }
  }

  tags = { Name = "thehive-server" }
}

# Elastic IP 
data "aws_eip" "existing_nat_eip" {
  id = var.existing_nat_eip_alloc_id
}

# NAT Instance Elastic IP 
resource "aws_eip_association" "nat_eip_assoc" {
  instance_id   = aws_instance.nat.id
  allocation_id = data.aws_eip.existing_nat_eip.id
}
