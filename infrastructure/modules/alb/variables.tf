variable "name" {
    type        = string
}
variable "security_groups" {
  type = list(string)
}
variable "subnets" {
  type = list(string)
}
variable "vpc_id" {}
variable "host_header" {
  default = "*.lemichi.cl"
}
