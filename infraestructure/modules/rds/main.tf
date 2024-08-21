resource "aws_db_instance" "this" {
  identifier        = var.db_identifier
  engine            = var.engine
  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage
  db_name           = var.db_name
  username          = var.username
  password          = var.password
  vpc_security_group_ids = var.vpc_security_group_ids
  db_subnet_group_name   = var.db_subnet_group_name
  skip_final_snapshot    = true
  tags = {
    Name = "${var.db_identifier}:cgstest"
  }
}

resource "aws_db_subnet_group" "this" {
  name       = var.db_subnet_group_name
  subnet_ids = var.subnets
  tags = {
    Name = "${var.db_subnet_group_name}:csgtest"
  }
}
