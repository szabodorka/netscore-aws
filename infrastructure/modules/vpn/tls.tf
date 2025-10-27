resource "tls_private_key" "ca_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}


resource "tls_self_signed_cert" "ca_cert" {
  private_key_pem = tls_private_key.ca_key.private_key_pem

  subject {
    common_name  = "VPN Root CA"
    organization = var.organization_name
    country      = "HU"
  }

  validity_period_hours = 87600
  is_ca_certificate     = true

  allowed_uses = [
    "cert_signing",
    "crl_signing",
    "digital_signature",
    "key_encipherment"
  ]
}


resource "tls_private_key" "vpn_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}


resource "tls_cert_request" "vpn_csr" {
  private_key_pem = tls_private_key.vpn_key.private_key_pem

  subject {
    common_name  = var.vpn_domain
    organization = var.organization_name
    country      = "HU"
  }
}


resource "tls_locally_signed_cert" "vpn_cert" {
  cert_request_pem   = tls_cert_request.vpn_csr.cert_request_pem
  ca_private_key_pem = tls_private_key.ca_key.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.ca_cert.cert_pem

  validity_period_hours = 8760

  allowed_uses = [
    "digital_signature",
    "key_encipherment",
    "server_auth",
    "client_auth",
  ]

  set_subject_key_id = true
}


resource "tls_private_key" "client_key" {
  for_each  = toset(var.clients)
  algorithm = "RSA"
  rsa_bits  = 2048
}



resource "tls_cert_request" "client_csr" {
  for_each        = toset(var.clients)
  private_key_pem = tls_private_key.client_key[each.key].private_key_pem
  subject {
    common_name  = "client-${each.key}.${var.vpn_domain}"
    organization = var.organization_name
    country      = "US"
  }
}



resource "tls_locally_signed_cert" "client_cert" {
  for_each          = toset(var.clients)
  cert_request_pem  = tls_cert_request.client_csr[each.key].cert_request_pem
  ca_private_key_pem = tls_private_key.ca_key.private_key_pem
  ca_cert_pem       = tls_self_signed_cert.ca_cert.cert_pem
  validity_period_hours = 8760
  allowed_uses = [
    "digital_signature",
    "key_encipherment",
    "client_auth",
  ]
  set_subject_key_id = true
}