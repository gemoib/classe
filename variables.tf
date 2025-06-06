# variables.tf
# Región de AWS donde desplegar la infraestructura (por defecto us-east-1)

variable "aws_region" {
description = "Región de AWS donde se desplegarán los recursos"
type = string
default = "us-east-1"
}

# Prefijo para nombres de recursos (por ejemplo, usar tus iniciales oproyecto)
variable "project_name" {
description = "Prefijo identificador para nombres de recursos en AWS"
type = string
default = "tfaws"
}

# VPC CIDR principal
variable "vpc_cidr" {
description = "Bloque CIDR para la VPC"
type = string
default = "10.0.0.0/16"
}

# Subredes públicas (lista de CIDR, una por zona de disponibilidad)
variable "public_subnets_cidrs" {
description = "Lista de bloques CIDR para subredes públicas"
type = list(string)
default = ["10.0.1.0/24", "10.0.2.0/24"]
}

# Subredes privadas (para base de datos/servidores privados)
variable "private_subnets_cidrs" {
description = "Lista de bloques CIDR para subredes privadas"
type = list(string)
default = ["10.0.101.0/24", "10.0.102.0/24"]
}

# Nombre de par de claves SSH existente (opcional, si se desea acceso SSH a instancia)
variable "key_name" {
description = "Nombre de la key pair de EC2 para SSH"
type = string
default = "" # dejar vacío si no se usará SSH manual
}

# Tipo de instancia EC2 para los servidores web
variable "instance_type" {
description = "Tipo de instancia EC2 para los servidores web"
type = string
default = "t3.micro"
}

# Parámetros para la base de datos (RDS MySQL)
# Referencia al secreto
# Nombre de la base de datos de WordPress en RDS
data "aws_secretsmanager_secret" "db_name" {
  name = "/wordpress/db_name"
}

data "aws_secretsmanager_secret_version" "db_name" {
  secret_id = data.aws_secretsmanager_secret.db_name.id
}

# Usuario administrador de la base de datos RDS
data "aws_secretsmanager_secret" "db_username" {
  name = "/wordpress/db_name"
}

data "aws_secretsmanager_secret_version" "db_username" {
  secret_id = data.aws_secretsmanager_secret.db_username.id
}

# Contraseña del usuario de la base de datos RDS
data "aws_secretsmanager_secret" "db_password" {
  name = "/wordpress/db_name"
}

data "aws_secretsmanager_secret_version" "db_password" {
  secret_id = data.aws_secretsmanager_secret.db_password.id
}

# Dominio para la instalación de WordPress
data "aws_secretsmanager_secret" "DOMAIN_NAME" {
  name = "/wordpress/db_name"
}

data "aws_secretsmanager_secret_version" "DOMAIN_NAME" {
  secret_id = data.aws_secretsmanager_secret.domain_name.id
}

# Usuario administrador para WordPress
data "aws_secretsmanager_secret" "DEMO_USERNAME" {
  name = "/wordpress/db_name"
}

data "aws_secretsmanager_secret_version" "DEMO_USERNAME" {
  secret_id = data.aws_secretsmanager_secret.demo_username.id
}

# Contraseña administrador para WordPress
data "aws_secretsmanager_secret" "DEMO_PASSWORD" {
  name = "/wordpress/db_name"
}

data "aws_secretsmanager_secret_version" "DEMO_PASSWORD" {
  secret_id = data.aws_secretsmanager_secret.demo_password.id
}

# Email administrador para WordPress
data "aws_secretsmanager_secret" "DEMO_EMAIL" {
  name = "/wordpress/db_name"
}

data "aws_secretsmanager_secret_version" "DEMO_EMAIL" {
  secret_id = data.aws_secretsmanager_secret.demo_email.id
}

