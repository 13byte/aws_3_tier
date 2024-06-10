resource "aws_lb" "origin_lb" {
  name               = "origin-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = [for subnet in aws_subnet.public.* : subnet.id]

  tags = {
    Name = "origin-alb-${var.vpc_name}"
  }
}

resource "aws_lb_target_group" "was_tg" {
  name     = "lb-tg-${var.vpc_name}"
  port     = "8080"
  protocol = "HTTP"
  vpc_id   = aws_vpc.default.id

  health_check {
    path = "/api/health"
  }
}

resource "aws_lb_listener" "backend" {
  load_balancer_arn = aws_lb.origin_lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = aws_acm_certificate.alb.arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Forbidden"
      status_code  = "403"
    }
  }
}

resource "aws_lb_listener_rule" "host_based_weighted_routing" {
  listener_arn = aws_lb_listener.backend.arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.was_tg.arn
  }

  condition {
    http_header {
      http_header_name = "X-Custom-Header"
      values           = ["}Y$ILp#~sY{qAA1"]
    }
  }
}
