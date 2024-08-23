variable "db_identifier" {
  description = "Identificador de la base de datos RDS"
  type        = string
}

variable "engine" {
  description = "Motor de la base de datos"
  type        = string
}

variable "instance_class" {
  description = "Clase de instancia para RDS"
  type        = string
}

variable "allocated_storage" {
  description = "Almacenamiento asignado para la base de datos"
  type        = number
}

variable "db_name" {
  description = "Nombre de la base de datos"
  type        = string
}

variable "username" {
  description = "Usuario para la base de datos"
  type        = string
}

variable "password" {
  description = "Contraseña para la base de datos"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "Lista de Security Groups para RDS"
  type        = list(string)
}

variable "db_subnet_group_name" {
  description = "Nombre del grupo de subnets para RDS"
  type        = string
}

variable "subnets" {
  description = "Lista de subnets"
  type        = list(string)
}
