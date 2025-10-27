output "s3_config_paths" {
  description = "List of S3 paths for each client's VPN config file"
  value = [
    for client in var.clients :
    "s3://${aws_s3_bucket.vpn_configs.bucket}/vpn-configs/${var.project_name}-client-${client}.ovpn"
  ]
}
