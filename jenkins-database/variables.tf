variable "project_name" {
  description = "Project name for tagging resources"
  type        = string
  default     = "netscore"
}

variable "availability_zone" {
    description = "Availability zone of elb"
    default = "eu-north-1a"
}

variable "region" {
  description = "Default region specified in terraform.tfvars file"
  type = string
  default = "eu-north-1"
}

variable "volume_size" {
  description = "Size of the ebs volume"
  type = number
  default = 10
}