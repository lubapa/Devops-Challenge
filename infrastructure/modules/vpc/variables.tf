variable "name" {
  description = "Nombre del VPC"
  type        = string
}

variable "cidr_block" {
  description = "CIDR block para el VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "Lista de CIDRs para las subnets públicas"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "Lista de CIDRs para las subnets privadas"
  type        = list(string)
}

variable "azs" {
  description = "Lista de Availability Zones"
  type        = list(string)
}
