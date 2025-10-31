variable "project_name" {
  description = "The name of the project"
  type = string
  default = "netscore"
}

variable "region" {
  description = "Default region specified in terraform.tfvars file"
  type = string
}

variable "vpn_clients" {
  description = "VPN client list"
  type = list(string)
}


variable "db_username" {
  description = "The username of the Postgres database admin"
  sensitive = true
}

variable "db_password" {
  description = "The password of the Postgres database password"
  sensitive = true
}

variable "jenkins_key_name" {
  description = "The key name for ssh into the jenkins ec2 instance"
}

variable "jenkins_ebs_volume_id" {
  description = "Existing EBS volume ID to attach to the Jenkins EC2 instance"
  type        = string
}