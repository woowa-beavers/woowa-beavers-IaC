# terraform/sec/modules/compute/main.tf
# 역할: sec 계정 컴퓨트 모듈 - TheHive NAT 인스턴스·서버 EC2 생성 및 라우팅 구성
# 흐름: variables.tf 입력값 → NAT Instance 생성 → Route Table 구성 → TheHive 서버 생성 → EIP 연결

# ==========================================
# TheHive NAT Instance
# ==========================================
resource "aws_instance" "thehive_nat" {
  ami               = var.ec2_ami
  instance_type     = "t3.nano"
  subnet_id         = var.thehive_public_subnet_id
  availability_zone = "ap-northeast-2d"

  vpc_security_group_ids = var.nat_security_group_ids
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

  vpc_security_group_ids = var.thehive_security_group_ids
  iam_instance_profile   = var.thehive_instance_profile_name

  root_block_device {
    volume_size = 64
    volume_type = "gp3"
    tags        = { Name = "thehive-server-root-vol" }
  }

  tags = { Name = "thehive-server" }
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
