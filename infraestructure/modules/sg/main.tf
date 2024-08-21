resource "aws_security_group" "this" {
  name        = var.name
  description = "Security Group for ${var.name}"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.name}:csgtest"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  description              = "Allow HTTP inbound traffic"
  from_port                = 80
  to_port                  = 80
  ip_protocol                 = "tcp"
  cidr_ipv4               = "0.0.0.0/0"
  security_group_id        = aws_security_group.this.id

  depends_on = [aws_security_group.this]

  tags = {
    Name = "allow_http_rule:csgtest"
  }
}

resource "aws_vpc_security_group_egress_rule" "allow_all_outbound" {
  description              = "Allow all outbound traffic"
  from_port                = 0
  to_port                  = 0
  ip_protocol                 = "-1"
  cidr_ipv4              = "0.0.0.0/0"
  security_group_id        = aws_security_group.this.id

  depends_on = [aws_security_group.this]

  tags = {
    Name = "allow_all_outbound_rule:csgtest"
  }
}
