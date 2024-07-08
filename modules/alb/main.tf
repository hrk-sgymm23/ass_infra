# ロードバランサー用セキュリティグループ
module "http_security_group" {
  source              = "../sg"
  security_group_name = "${var.common_name}-http"
  vpc_id              = var.vpc_id
  port                = 80
  cidr_blocks         = ["0.0.0.0/0"]
}

module "https_security_group" {
  source              = "../sg"
  security_group_name = "${var.common_name}-https"
  vpc_id              = var.vpc_id
  port                = 443
  cidr_blocks         = ["0.0.0.0/0"]
}

module "http_redirect_security_group" {
  source              = "../sg"
  security_group_name = "${var.common_name}-http-redirect"
  vpc_id              = var.vpc_id
  port                = 3000
  cidr_blocks         = ["0.0.0.0/0"]
}

# ログをS3を吐き出すために必要なロードバランサーサービスアカウント
data "aws_elb_service_account" "main" {}

# ロードバランサー
resource "aws_lb" "main" {
  name               = "${var.common_name}-alb-${var.environment}"
  internal           = false
  load_balancer_type = "application"
  security_groups = [
    module.https_security_group.security_group_id,
    module.http_redirect_security_group.security_group_id,
    module.http_security_group.security_group_id
  ]
  subnets = var.public_subnet_ids

  enable_deletion_protection = false
  access_logs {
    bucket  = aws_s3_bucket.alb_log_stg.bucket
    enabled = true
  }
}

# ターゲットグループ
resource "aws_lb_target_group" "main" {
  name                 = "${var.common_name}-tg-${var.environment}"
  vpc_id               = var.vpc_id
  port                 = 80
  target_type          = "ip"
  protocol             = "HTTP"
  deregistration_delay = 300
  health_check {
    path                = "/api/health_checks"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = 200
    port                = "traffic-port"
    protocol            = "HTTP"
  }
  depends_on = [
    aws_lb.main
  ]
}

# リスナーグループ
# HTTP
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type = "redirect"

    redirect {
      status_code = "HTTP_301"
      path        = "/*"
      protocol    = "HTTPS"
      port        = 443
    }
  }
}

resource "aws_lb_listener_rule" "http" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}

# TODO: 証明書を作成した際にコメント外す
# HTTPS
# resource "aws_lb_listener" "https" {
#   load_balancer_arn = aws_lb.main.arn
#   port              = 80
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   # TODO: remove　comment after create acm   
#   #   certificate_arn = var.aws_acm_certificate_arn
#   default_action {
#     type = "fixed-response"
#     fixed_response {
#       content_type = "text/plain"
#       status_code  = 200
#     }
#   }
#   depends_on = [
#     var.acm_depends_on
#   ]
# }

# resource "aws_lb_listener_rule" "https" {
#   listener_arn = aws_lb_listener.https.arn
#   priority     = 100
#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.main.arn
#   }
#   condition {
#     path_pattern {
#       values = ["/*"]
#     }
#   }
# }

# ログ用S3
# バケット
resource "aws_s3_bucket" "alb_log_stg" {
  bucket = "${var.common_name}-alb-log-${var.environment}"
}

# ACL
# resource "aws_s3_bucket_acl" "alb_log_stg" {
#   bucket = aws_s3_bucket.alb_log_stg.id
#   acl    = "private"
# }

# ライフサイクル
resource "aws_s3_bucket_lifecycle_configuration" "alb_log_stg" {
  bucket = aws_s3_bucket.alb_log_stg.id
  rule {
    id = "${var.common_name}-alb-log-${var.environment}"
    filter {
      prefix = "logs/"
    }
    expiration {
      days = 90
    }
    status = "Enabled"
  }
}

# ログ用S3バケットポリシー
resource "aws_s3_bucket_policy" "alb_log" {
  bucket = aws_s3_bucket.alb_log_stg.id
  policy = data.aws_iam_policy_document.alb_log.json
}

data "aws_iam_policy_document" "alb_log" {
  statement {
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.alb_log_stg.id}/*"]
    principals {
      type        = "AWS"
      identifiers = [data.aws_elb_service_account.main.arn]
    }
  }
}
