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