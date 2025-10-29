variable "vpc_id" {
  description = "The ID of the main VPC"
  type = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs"
  type = list(string)
}

variable "public_subnet_ids" {
  description = "Public subnet IDs"
  type = list(string)
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type = string
}

variable "project_name" {
  description = "The name of the project"
  type = string
}

variable "region" {
  description = "Default region specified in terraform.tfvars file"
  type = string
}