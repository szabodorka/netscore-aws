variable "project_name" {
  description = "The name of the project used for tagging and resource naming"
  type        = string
}

variable "organization_name" {
  description = "Organization name for TLS certificates"
  type        = string
}

variable "vpn_domain" {
  description = "Domain name for the VPN server"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the Client VPN endpoint"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs to associate with the VPN endpoint"
  type        = map(string)
}

variable "nat_subnet_id" {
  description = "The subnet whose NAT Gateway is used by VPN clients for internet access"
  type        = string
}

variable "clients" {
  type    = list(string)
  description = "List of client names for VPN certificates"
}