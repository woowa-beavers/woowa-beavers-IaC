# terraform/modules/cdn/main.tf
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
# 타겟 그룹 - EC2-2, 3, 4, 5
# -----------------------------------------------
resource "aws_lb_target_group" "ec2_2" {
  name     = "woowa-beavers-shop-EC2-2"
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

  tags = { Name = "woowa-beavers-shop-EC2-2" }
}

resource "aws_lb_target_group_attachment" "ec2_2" {
  target_group_arn = aws_lb_target_group.ec2_2.arn
  target_id        = var.ec2_2_instance_id
  port             = 8000
}

resource "aws_lb_target_group" "ec2_3" {
  name     = "woowa-beavers-shop-EC2-3"
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

  tags = { Name = "woowa-beavers-shop-EC2-3" }
}

resource "aws_lb_target_group_attachment" "ec2_3" {
  target_group_arn = aws_lb_target_group.ec2_3.arn
  target_id        = var.ec2_3_instance_id
  port             = 8000
}

resource "aws_lb_target_group" "ec2_4" {
  name     = "woowa-beavers-shop-EC2-4"
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

  tags = { Name = "woowa-beavers-shop-EC2-4" }
}

resource "aws_lb_target_group_attachment" "ec2_4" {
  target_group_arn = aws_lb_target_group.ec2_4.arn
  target_id        = var.ec2_4_instance_id
  port             = 8000
}

resource "aws_lb_target_group" "ec2_5" {
  name     = "woowa-beavers-shop-EC2-5"
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

  tags = { Name = "woowa-beavers-shop-EC2-5" }
}

resource "aws_lb_target_group_attachment" "ec2_5" {
  target_group_arn = aws_lb_target_group.ec2_5.arn
  target_id        = var.ec2_5_instance_id
  port             = 8000
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
      message_body = "X-Origin-Secret Not found"
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
    target_group_arn = aws_lb_target_group.ec2_2.arn
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
    target_group_arn = aws_lb_target_group.ec2_4.arn
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
    target_group_arn = aws_lb_target_group.ec2_3.arn
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

# -----------------------------------------------
# CloudFront — Origin Access Control (S3용)
# -----------------------------------------------
resource "aws_cloudfront_origin_access_control" "s3" {
  name                              = "woowa-beavers-shop-static-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# -----------------------------------------------
# CloudFront Distribution
# -----------------------------------------------
resource "aws_cloudfront_distribution" "main" {
  enabled         = true
  aliases         = ["*.woowabeavers.cloud"]
  price_class     = "PriceClass_All"
  web_acl_id      = var.waf_web_acl_arn
  http_version    = "http2"
  is_ipv6_enabled = true

  # Origin 1: ALB (동적 요청)
  origin {
    domain_name = aws_lb.main.dns_name
    origin_id   = "alb-origin"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }

    custom_header {
      name  = "X-Origin-Secret"
      value = var.x_origin_secret
    }
  }

  # Origin 2: S3 (정적 파일)
  origin {
    domain_name              = "${var.shop_static_bucket_name}.s3.ap-northeast-2.amazonaws.com"
    origin_id                = "s3-static-origin"
    origin_access_control_id = aws_cloudfront_origin_access_control.s3.id
  }

  # 동작 0: /static/* → S3 (캐싱 최적화)
  ordered_cache_behavior {
    path_pattern           = "/static/*"
    target_origin_id       = "s3-static-origin"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]

    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6" # Managed-CachingOptimized
  }

  # 동작 기본: * → ALB (캐싱 비활성화, 모든 헤더 전달)
  default_cache_behavior {
    target_origin_id       = "alb-origin"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]

    cache_policy_id          = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad" # Managed-CachingDisabled
    origin_request_policy_id = "216adef6-5c7f-47e4-b989-5492eafa07d3" # Managed-AllViewer
  }

  viewer_certificate {
    acm_certificate_arn      = var.cloudfront_certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Name = "woowa-beavers-shop-cloudfront"
  }
}

# -----------------------------------------------
# S3 버킷 정책 — CloudFront OAC 접근 허용
# -----------------------------------------------
resource "aws_s3_bucket_policy" "shop_static_cloudfront" {
  bucket = var.shop_static_bucket_name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudFrontServicePrincipal"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "arn:aws:s3:::${var.shop_static_bucket_name}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.main.arn
          }
        }
      }
    ]
  })
}
