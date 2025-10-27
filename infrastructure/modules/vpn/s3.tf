resource "aws_s3_object" "vpn_config_upload" {
  for_each     = toset(var.clients)
  bucket       = aws_s3_bucket.vpn_configs.id
  key          = "vpn-configs/${var.project_name}-client-${each.key}.ovpn"
  content      = <<-EOT
client
dev tun
proto udp
remote ${aws_ec2_client_vpn_endpoint.vpn.dns_name} 443
remote-random-hostname
resolv-retry infinite
nobind
remote-cert-tls server
cipher AES-256-GCM
verify-x509-name ${var.vpn_domain} name
reneg-sec 0
verb 3
<ca>
${tls_self_signed_cert.ca_cert.cert_pem}
</ca>
<cert>
${tls_locally_signed_cert.client_cert[each.key].cert_pem}
</cert>
<key>
${tls_private_key.client_key[each.key].private_key_pem}
</key>
EOT
  content_type = "application/x-openvpn-profile"
  server_side_encryption = "AES256"
  depends_on = [
    aws_ec2_client_vpn_endpoint.vpn,
    tls_locally_signed_cert.client_cert,
    tls_private_key.client_key,
    tls_self_signed_cert.ca_cert,
    aws_s3_bucket.vpn_configs
  ]
}

resource "aws_s3_bucket" "vpn_configs" {
  bucket = "${var.project_name}-vpn-configs-${random_id.bucket_suffix.hex}"
  tags = {
    Name = "${var.project_name}-vpn-configs"
  }
}

resource "random_id" "bucket_suffix" {
  byte_length = 4
}


resource "aws_s3_bucket_versioning" "vpn_configs" {
  bucket = aws_s3_bucket.vpn_configs.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "vpn_configs" {
  bucket = aws_s3_bucket.vpn_configs.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "vpn_configs" {
  bucket = aws_s3_bucket.vpn_configs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
