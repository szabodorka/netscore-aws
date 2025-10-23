output "vpn_s3_config_paths" {
  description = "List of S3 paths for each client's VPN config file"
  value = module.vpn.s3_config_paths
}
