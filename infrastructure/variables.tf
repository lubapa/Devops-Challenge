# variable "container_name" {
#   description = "Container name based on branch and commit"
#   type        = string
# }

variable "container_image" {
  description = "Container image name based on branch and commit"
  type        = string
}
variable "aws_secret_pull" {
  description = "aws secret for pull docker"
  type        = string
}

variable "app_name" {
  description = "App name for naming resources"
  type        = string
}
variable "branch_name" {
  description = "Git Branch name for naming resources"
  type        = string
}
variable "aws_rds_username" {
  description = "aws rds username"
  type        = string
}
variable "aws_rds_password" {
  description = "aws rds password"
  type        = string
}