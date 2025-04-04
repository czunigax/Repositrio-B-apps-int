variable "subscription_id" {
  type        = string
  description = "ID de la suscripción de Azure"
}

variable "tags" {
  type        = map(string)
  description = "Etiquetas para los recursos"
  default = {
    environment = "produccion"
    date        = "2025-13-03"
    createdBy   = "Cris"
  }
}

variable "name_Project" {
  type        = string
  description = "Nombre del proyecto"
  default     = "proyecto1"
}

variable "enviroment" {
  type        = string
  description = "Entorno de despliegue (ej. dev, prod)"
  default     = "dev"
}

variable "location" {
  type        = string
  description = "Ubicación de los recursos de Azure"
  default     = "Central US"
}

variable "administrator_login_password" {
  type        = string
  description = "Contraseña para la autenticación de los administradores"
}

# Variables relacionadas con el Storage
variable "storage_account_name" {
  type        = string
  description = "Nombre de la cuenta de almacenamiento"
  default     = "st"  # No puedes usar interpolación aquí
}

variable "container_name" {
  type        = string
  description = "Nombre del contenedor en Storage"
  default     = "imgs"
}

# Variables para el Service Bus y la Cola
variable "servicebus_name" {
  type        = string
  description = "Nombre del namespace de Azure Service Bus"
  default     = "sb"  # No puedes usar interpolación aquí
}

variable "queue_name" {
  type        = string
  description = "Nombre de la cola en Azure Service Bus"
  default     = "procesos"  # No puedes usar interpolación aquí
}

