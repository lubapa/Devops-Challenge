resource "aws_security_group" "allow_http_ecs" {
  name        = var.name
  description = "Security Group for ${var.name}"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.name}:csgtest"
  }
}

resource "aws_security_group_rule" "allow_http" {
  type                     = "ingress"
  description              = "Allow HTTP inbound traffic to ECS"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  # cidr_ipv4               = "0.0.0.0/0"
  security_group_id      = aws_security_group.allow_http_ecs.id
  source_security_group_id = var.security_group_alb_id

  depends_on = [aws_security_group.allow_http_ecs]
}

resource "aws_vpc_security_group_egress_rule" "allow_all_outbound" {
  description              = "Allow all outbound traffic"
  from_port                = 0
  to_port                  = 0
  ip_protocol                 = "-1"
  cidr_ipv4              = "0.0.0.0/0"
  security_group_id        = aws_security_group.allow_http_ecs.id

  depends_on = [aws_security_group.allow_http_ecs]

  tags = {
    Name = "allow_all_outbound_rule:csgtest"
  }
    lifecycle {
    ignore_changes = [
      from_port,
      to_port,
    ]
  }
}
