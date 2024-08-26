resource "aws_lb" "http" {
  name               = "${var.name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_groups
  subnets            = var.subnets

  enable_deletion_protection = false
  enable_http2               = true
  idle_timeout               = 60
  drop_invalid_header_fields = true
  enable_cross_zone_load_balancing = true
  
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.http.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.ecs_tg.arn
  }
}

resource "aws_lb_target_group" "ecs_tg" {
  name     = "${var.name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "ip" 
  health_check {
    interval            = 30
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener_rule" "default" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 1

  action {
    type = "forward"
    forward {
      target_group {
        arn = aws_lb_target_group.ecs_tg.arn
      }
    }
  }

  condition {
    host_header {
      values = [var.host_header]
    }
  }
}
