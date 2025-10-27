variable "subnet_ids" {
  description = "Private DB subnet IDs"
  type = list(string)
}

variable "subnet_cidr_blocks" {
  description = "CIDR Blocks of private DB subnets"
  type = list(string)
}

variable "vpc_id" {
  description = "The ID of the main VPC"
  type = string
}

variable "vpc_cidr_block" {
  description = "The CIDR Block of the main VPC"
  type = string
}

variable "project_name" {
  description = "The name of the project"
  type = string
}

variable "db_username" {
  description = "The username of the Postgres database admin"
  type = string
  sensitive = true
}

variable "db_password" {
  description = "The password of the Postgres database admin"
  type = string
  sensitive = true
}