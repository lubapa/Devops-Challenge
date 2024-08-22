output "vpc_id" {
  value = aws_security_group.mysql_sg.vpc_id
}
output "security_group_id" {
  value = aws_security_group.mysql_sg.id
}