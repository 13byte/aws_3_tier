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

resource "aws_lb_listener" "back_end" {
  load_balancer_arn = aws_lb.origin_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.was_tg.arn
  }
}
