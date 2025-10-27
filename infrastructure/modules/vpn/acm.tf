resource "aws_acm_certificate" "vpn_cert" {
  private_key       = tls_private_key.vpn_key.private_key_pem
  certificate_body  = tls_locally_signed_cert.vpn_cert.cert_pem
  certificate_chain = tls_self_signed_cert.ca_cert.cert_pem

  tags = {
    Name = "${var.project_name}-vpn-cert"
  }
}

resource "aws_acm_certificate" "ca_cert" {
  private_key      = tls_private_key.ca_key.private_key_pem
  certificate_body = tls_self_signed_cert.ca_cert.cert_pem

  tags = {
    Name = "${var.project_name}-ca-cert"
  }
} 