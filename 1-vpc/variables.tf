variable "aws_access_key" {
  description = "KEYAWS"
}

variable "aws_secret_key" {
  description = "SECRETAWS"
}

variable "aws_region" {
  description = "AWS Region"
  default     = "us-east-1"
}

variable "aws_region_zone_1" {
  description = "AWS Region"
  default     = "us-east-1a"
}

variable "aws_region_zone_2" {
  description = "AWS Region"
  default     = "us-east-1b"
}

variable "aws_dominio" {
  description = "Ejemplo de dominio"
  default     = "DOMINIO.CL"
}
