resource "aws_security_group" "vpn" {
  name_prefix = "${var.project_name}-client-vpn-sg"
  description = "Security group for Client VPN endpoint"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-vpn-sg"
  }
}


resource "aws_ec2_client_vpn_endpoint" "vpn" {
  description            = "Client VPN endpoint"
  server_certificate_arn = aws_acm_certificate.vpn_cert.arn
  client_cidr_block      = "10.0.100.0/22"
  vpc_id                 = var.vpc_id
  split_tunnel           = false

  authentication_options {
    type                       = "certificate-authentication"
    root_certificate_chain_arn = aws_acm_certificate.ca_cert.arn
  }

  transport_protocol = "udp"
  security_group_ids = [aws_security_group.vpn.id]

  connection_log_options {
    enabled               = false
  }

  dns_servers = ["169.254.169.253"]

  session_timeout_hours = 8

  tags = {
    Name = "${var.project_name}-client-vpn"
  }
}


resource "aws_ec2_client_vpn_network_association" "vpn_subnet" {
  for_each               = var.subnet_ids
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpn.id
  subnet_id              = each.value
}

resource "aws_ec2_client_vpn_authorization_rule" "vpn_auth_rule" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpn.id
  target_network_cidr    = "10.0.0.0/16"
  authorize_all_groups   = true
}

resource "aws_ec2_client_vpn_authorization_rule" "vpn_internet_access" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpn.id
  target_network_cidr    = "0.0.0.0/0"
  authorize_all_groups   = true
  description            = "Allow VPN clients to access the internet"
}

resource "aws_ec2_client_vpn_route" "internet_access" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpn.id
  destination_cidr_block = "0.0.0.0/0"
  target_vpc_subnet_id   = var.nat_subnet_id
  description            = "Route internet traffic through NAT Gateway"

  timeouts {
    create = "10m"
    delete = "10m"
  }
}
