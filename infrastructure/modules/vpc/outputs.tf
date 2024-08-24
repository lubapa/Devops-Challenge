output "vpc_id" {
  value = aws_vpc.this.id
}

output "container_subnet_cidrs" {
  value = aws_subnet.container[*].id
}

output "private_subnets" {
  value = aws_subnet.private[*].id
}
