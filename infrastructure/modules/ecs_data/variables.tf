variable "container_name" {
  description = "Container name based on branch and commit"
  type        = string
}

variable "container_image" {
  description = "Container image name based on branch and commit"
  type        = string
}
variable "aws_secret_pull" {
  description = "aws secret for pull docker"
  type        = string
}