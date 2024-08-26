resource "aws_security_group" "mysql_sg" {
  name        = var.name
  description = "Security Group for ${var.name}"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.name}:csgtest"
  }
}

resource "aws_security_group_rule" "allow_mysql_rds" {
  type                     = "ingress"
  description              = "Allow HTTP inbound traffic"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  # cidr_ipv4               = "10.123.3.0/24"
  security_group_id        = aws_security_group.mysql_sg.id
  source_security_group_id = var.security_group_ecs_id

  depends_on = [aws_security_group.mysql_sg]
}

resource "aws_security_group_rule" "allow_mysql_outbound" {
  type                     =  "egress"
  description              = "Allow MYSQL outbound traffic from RDS"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "TCP"
  cidr_blocks                 = ["0.0.0.0/0"]
  security_group_id        = aws_security_group.mysql_sg.id

  depends_on = [aws_security_group.mysql_sg]
}