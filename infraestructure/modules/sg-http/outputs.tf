output "vpc_id" {
  value = aws_security_group.allow_http_ecs.vpc_id
}
output "security_group_id" {
  value = aws_security_group.allow_http_ecs.id
}