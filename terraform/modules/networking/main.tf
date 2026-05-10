# terraform/modules/networking/main.tf
# 역할: Bastion Host + NAT 인스턴스 정의 (퍼블릭 서브넷 네트워크 컴포넌트)
# 흐름: variables.tf 입력값 → AWS 리소스 생성 → outputs.tf 출력

data "aws_vpc" "selected" {
  id = var.vpc_id
}

data "aws_subnet" "public" {
  id = var.public_subnet_id
}

# -----------------------------------------------
# Bastion Host
# -----------------------------------------------
resource "aws_security_group" "bastion_sg" {
  name        = "Bastion Host SG"
  description = "Allow Cloudflare 22"
  vpc_id      = data.aws_vpc.selected.id

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
  subnet_id     = data.aws_subnet.public.id
  private_ip    = var.bastion_private_ip
  key_name      = var.bastion_key_name

  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]

  tags = {
    Name = "bastion host"
    Role = "bastion"
  }
}

# -----------------------------------------------
# NAT Instance
# -----------------------------------------------
resource "aws_security_group" "nat_sg" {
  name        = "NAT Instance SG"
  description = "NAT Instance SG"
  vpc_id      = data.aws_vpc.selected.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.private_subnet_cidrs
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
  subnet_id     = data.aws_subnet.public.id
  private_ip    = var.nat_private_ip
  key_name      = var.nat_key_name

  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.nat_sg.id]

  # NAT 동작을 위한 필수 설정
  source_dest_check = false

  tags = {
    Name = "NAT-Instance-EC2"
    Role = "nat"
  }
}
