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

resource "aws_security_group" "alb" {
  name        = "alb-${var.vpc_name}"
  description = "alb sg for ${var.vpc_name}"
  vpc_id      = aws_vpc.default.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    prefix_list_ids = ["pl-22a6434b"]
    description     = "http cloudfront inbound"
  }

  egress {
    to_port     = 80
    from_port   = 80
    protocol    = "tcp"
    description = "http cloudfront outbound"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-${var.vpc_name}"
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
