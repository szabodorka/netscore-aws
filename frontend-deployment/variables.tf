variable "project_name" {
  description = "The name of the project"
  type = string
  default = "netscore"
}

variable "region" {
  description = "Default region specified in terraform.tfvars file"
  type = string
}

variable "cluster_name" {
  description = "Default EKS cluster name specified in terraform.tfvars file"
  type = string
}

variable "replicas" {
  description = "Number of replicas of Kubernetes deployment"
  type        = number
  default     = 2
}

variable "image" {
  description = "ECR frontend image reference specified in terraform.tfvars file"
  type        = string
}