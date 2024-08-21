variable "cluster_name" {
  description = "Nombre del ECS Cluster"
  type        = string
}

variable "task_family" {
  description = "Nombre de la familia de tareas de ECS"
  type        = string
}

variable "container_definitions" {
  description = "Definiciones del contenedor"
  type        = string
}

variable "cpu" {
  description = "CPU para la tarea"
  type        = string
}

variable "memory" {
  description = "Memoria para la tarea"
  type        = string
}

variable "execution_role_arn" {
  description = "ARN del rol de ejecución"
  type        = string
}

variable "task_role_arn" {
  description = "ARN del rol de la tarea"
  type        = string
}

variable "service_name" {
  description = "Nombre del servicio ECS"
  type        = string
}

variable "desired_count" {
  description = "Número de instancias deseadas para el servicio"
  type        = number
}

variable "subnets" {
  description = "Subnets para la configuración de red"
  type        = list(string)
}

variable "security_groups" {
  description = "Security Groups para la configuración de red"
  type        = list(string)
}