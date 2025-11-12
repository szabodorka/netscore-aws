variable "project_name" {
  description = "The name of the project"
  type = string
}


variable "ec2_private_subnet_id" {
  description = "Private subnet ID for EC2"
  type        = string
}


variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.medium"
}


variable "key_name" {
  description = "Optional SSH key pair name"
  type        = string
}

variable "ebs_volume_id" {
  description = "Existing EBS volume ID to attach to the Jenkins EC2 instance"
  type        = string
}

variable "instance_root_size" {
  description = "Size of the jenkins ec2 instance root storage in GB"
  type = number
  default = 30
}