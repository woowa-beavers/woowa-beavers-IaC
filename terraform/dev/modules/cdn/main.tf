# terraform/dev/modules/cdn/main.tf
# 역할: ALB · 타겟 그룹 · HTTP/HTTPS 리스너 · 경로 기반 라우팅 규칙 정의
# 흐름: variables.tf 입력값 → ALB 및 리스너 생성 → EC2 타겟 그룹 연결 → outputs.tf 출력

# -----------------------------------------------
# ALB
# -----------------------------------------------
resource "aws_lb" "main" {
  name               = "woowa-beavers-shop-ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnet_ids

  tags = {
    Name = "woowa-beavers-shop-ALB"
  }
}

# -----------------------------------------------
# 타겟 그룹 - EC2-1 (product) 직접 생성
# -----------------------------------------------
resource "aws_lb_target_group" "ec2_1" {
  name     = "woowa-beavers-shop-EC2-1"
  port     = 8000
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    port                = "traffic-port"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }

  tags = {
    Name = "woowa-beavers-shop-EC2-1"
  }
}

resource "aws_lb_target_group_attachment" "ec2_1" {
  target_group_arn = aws_lb_target_group.ec2_1.arn
  target_id        = var.ec2_1_instance_id
  port             = 8000
}

# -----------------------------------------------
# 타겟 그룹 - EC2-2, 3, 4, 5 참조 (각 팀원이 생성한 것)
# -----------------------------------------------
data "aws_lb_target_group" "ec2_2" {
  name = "woowa-beavers-shop-EC2-2"
}

data "aws_lb_target_group" "ec2_3" {
  name = "woowa-beavers-shop-EC2-3"
}

data "aws_lb_target_group" "ec2_4" {
  name = "woowa-beavers-shop-EC2-4"
}

data "aws_lb_target_group" "ec2_5" {
  name = "woowa-beavers-shop-EC2-5"
}

# -----------------------------------------------
# HTTP 리스너 (포트 80) - HTTPS 301 리다이렉트
# -----------------------------------------------
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# -----------------------------------------------
# HTTPS 리스너 (포트 443) - X-Origin-Secret 없으면 403
# -----------------------------------------------
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.main.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-Res-PQ-2025-09"
  certificate_arn   = var.certificate_arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "X-Origin-Header Not found"
      status_code  = "403"
    }
  }
}

# -----------------------------------------------
# 라우팅 규칙 - HTTPS (모든 규칙에 X-Origin-Secret 헤더 검증 필수)
# -----------------------------------------------
resource "aws_lb_listener_rule" "https_auth" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 2

  action {
    type             = "forward"
    target_group_arn = data.aws_lb_target_group.ec2_2.arn
  }

  condition {
    path_pattern {
      values = ["/login*", "/signup*", "/main*", "/api/auth/*"]
    }
  }

  condition {
    http_header {
      http_header_name = "X-Origin-Secret"
      values           = [var.x_origin_secret]
    }
  }
}

resource "aws_lb_listener_rule" "https_order" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 3

  action {
    type             = "forward"
    target_group_arn = data.aws_lb_target_group.ec2_4.arn
  }

  condition {
    path_pattern {
      values = ["/api/checkout", "/api/orders", "/api/orders/*", "/api/wallets/*"]
    }
  }

  condition {
    http_header {
      http_header_name = "X-Origin-Secret"
      values           = [var.x_origin_secret]
    }
  }
}

resource "aws_lb_listener_rule" "https_inventory" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 5

  action {
    type             = "forward"
    target_group_arn = data.aws_lb_target_group.ec2_3.arn
  }

  condition {
    path_pattern {
      values = ["/inventory/*"]
    }
  }

  condition {
    http_header {
      http_header_name = "X-Origin-Secret"
      values           = [var.x_origin_secret]
    }
  }
}

# X-Origin-Secret 있는 모든 요청의 기본 라우팅 → EC2-1 product
resource "aws_lb_listener_rule" "https_product" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 6

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ec2_1.arn
  }

  condition {
    http_header {
      http_header_name = "X-Origin-Secret"
      values           = [var.x_origin_secret]
    }
  }
}
