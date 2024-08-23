variable "role_name" {
  description = "Nombre del rol de IAM"
  type        = string
}

variable "assume_role_policy" {
  description = "Política de asunción de rol"
  type        = string
}

variable "policy" {
  description = "Política para el rol de IAM"
  type        = string
}
