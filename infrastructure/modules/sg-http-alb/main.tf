resource "aws_security_group" "allow_http_alb" {
  name        = var.name
  description = "Security Group for ${var.name}"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.name}:csgtest"
  }
}

resource "aws_security_group_rule" "allow_http_inbound_alb" {
  description              = "Allow HTTP inbound traffic to ALB"
  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.allow_http_alb.id
}

resource "aws_security_group_rule" "allow_http_outbound_alb" {
  type                     =  "egress"
  description              = "Allow HTTP outbound traffic for ALB"
  from_port                = 80
  to_port                  = 80
  protocol                 = "TCP"
  cidr_blocks                 = ["0.0.0.0/0"]
  security_group_id        = aws_security_group.allow_http_alb.id

  depends_on = [aws_security_group.allow_http_alb]
}
resource "aws_security_group_rule" "allow_https_outbound_alb" {
  type                     =  "egress"
  description              = "Allow HTTPS outbound traffic for ALB"
  from_port                = 443
  to_port                  = 443
  protocol                 = "TCP"
  cidr_blocks                 = ["0.0.0.0/0"]
  security_group_id        = aws_security_group.allow_http_alb.id

  depends_on = [aws_security_group.allow_http_alb]
}