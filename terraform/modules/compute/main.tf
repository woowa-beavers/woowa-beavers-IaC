# terraform/modules/compute/main.tf
# 역할: EC2 인스턴스 + 보안 그룹 정의 (product · auth · inventory · order · ec2-5)
# 흐름: variables.tf 입력값 → AWS 리소스 생성 → outputs.tf 출력

# -----------------------------------------------
# EC2-1 Product
# -----------------------------------------------
resource "aws_security_group" "ec2_1_sg" {
  name        = "woowa-beavers-ec2-1-sg"
  description = "EC2-1 product server security group"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [var.bastion_sg_id]
    description     = "SSH from Bastion"
  }

  ingress {
    from_port       = 8000
    to_port         = 8000
    protocol        = "tcp"
    security_groups = [var.alb_sg_id]
    description     = "FastAPI from ALB"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "woowa-beavers-ec2-1-sg"
  }
}

resource "aws_instance" "ec2_1" {
  ami           = var.ec2_1_ami_id
  instance_type = "t3.micro"
  subnet_id     = var.private_subnet_id
  private_ip    = var.ec2_1_private_ip
  key_name      = var.ec2_1_key_name

  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.ec2_1_sg.id]

  root_block_device {
    volume_size = 8
    volume_type = "gp3"
  }

  tags = {
    Name    = "EC2-1"
    Service = "product"
  }
}

# -----------------------------------------------
# EC2-2 Auth
# -----------------------------------------------
resource "aws_security_group" "ec2_2_sg" {
  name        = "woowa-beavers-ec2-2-sg"
  description = "woowa-beavers-ec2-2-sg"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [var.bastion_sg_id]
    description     = "SSH from Bastion"
  }

  ingress {
    from_port       = 8000
    to_port         = 8000
    protocol        = "tcp"
    security_groups = [var.alb_sg_id]
    description     = "FastAPI from ALB"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "woowa-beavers-ec2-2-sg"
  }
}

resource "aws_instance" "ec2_2_auth" {
  ami           = var.ec2_2_ami_id
  instance_type = "t3.micro"
  subnet_id     = var.private_subnet_id
  private_ip    = var.ec2_2_private_ip
  key_name      = var.ec2_2_key_name

  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.ec2_2_sg.id]

  root_block_device {
    volume_size = 8
    volume_type = "gp3"
  }

  tags = {
    Name    = "EC2-2"
    Service = "auth"
  }
}

# -----------------------------------------------
# EC2-3 Inventory
# -----------------------------------------------
resource "aws_security_group" "ec2_3_sg" {
  name        = "woowa-beavers-ec2-3-sg"
  description = "woowa-beavers-ec2-3-sg"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [var.bastion_sg_id]
    description     = "SSH from Bastion"
  }

  ingress {
    from_port       = 8000
    to_port         = 8000
    protocol        = "tcp"
    security_groups = [var.alb_sg_id]
    description     = "FastAPI from ALB"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "woowa-beavers-ec2-3-sg"
  }
}

resource "aws_instance" "ec2_3_inventory" {
  ami           = var.ec2_3_ami_id
  instance_type = "t3.micro"
  subnet_id     = var.private_subnet_id
  private_ip    = var.ec2_3_private_ip
  key_name      = var.ec2_3_key_name

  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.ec2_3_sg.id]

  root_block_device {
    volume_size = 8
    volume_type = "gp3"
  }

  tags = {
    Name    = "EC2-3"
    Service = "inventory"
  }
}

# -----------------------------------------------
# EC2-4 Order
# -----------------------------------------------
resource "aws_security_group" "ec2_4_sg" {
  name        = "woowa-beavers-ec2-4-sg"
  description = "woowa-beavers-ec2-4-sg"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [var.bastion_sg_id]
    description     = "SSH from Bastion"
  }

  ingress {
    from_port       = 8000
    to_port         = 8000
    protocol        = "tcp"
    security_groups = [var.alb_sg_id]
    description     = "FastAPI from ALB"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "woowa-beavers-ec2-4-sg"
  }
}

resource "aws_instance" "ec2_4_order" {
  ami           = var.ec2_4_ami_id
  instance_type = "t3.micro"
  subnet_id     = var.private_subnet_id
  private_ip    = var.ec2_4_private_ip
  key_name      = var.ec2_4_key_name

  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.ec2_4_sg.id]

  root_block_device {
    volume_size = 8
    volume_type = "gp3"
  }

  tags = {
    Name    = "EC2-4"
    Service = "order"
  }
}

# -----------------------------------------------
# EC2-5
# -----------------------------------------------
resource "aws_security_group" "ec2_5_sg" {
  name        = "woowa-beavers-ec2-5-sg"
  description = "woowa-beavers-ec2-5-sg"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [var.bastion_sg_id]
    description     = "SSH from Bastion"
  }

  ingress {
    from_port       = 8000
    to_port         = 8000
    protocol        = "tcp"
    security_groups = [var.alb_sg_id]
    description     = "FastAPI from ALB"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "woowa-beavers-ec2-5-sg"
  }
}

resource "aws_instance" "ec2_5" {
  ami           = var.ec2_5_ami_id
  instance_type = "t3.micro"
  subnet_id     = var.private_subnet_id
  private_ip    = var.ec2_5_private_ip
  key_name      = var.ec2_5_key_name

  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.ec2_5_sg.id]

  root_block_device {
    volume_size = 8
    volume_type = "gp3"
  }

  tags = {
    Name = "EC2-5"
  }
}
