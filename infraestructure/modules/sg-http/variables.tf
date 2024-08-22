variable "name" {
  description = "Name of the Security Group"
  type        = string
}
variable "vpc_id" {
  description = "ID of the VPC to create security group"
  type        = string
}