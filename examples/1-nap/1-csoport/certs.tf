resource "tls_private_key" "requester" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_cert_request" "requester" {
  for_each = toset([for s in var.hostnames : lower(s)])

  private_key_pem = tls_private_key.requester.private_key_pem

  subject {
    common_name  = join(".", [each.value, "example.com"])
    organization = "ACME Examples, Inc"
  }
}

resource "tls_locally_signed_cert" "requester" {
  for_each = toset([for s in var.hostnames : lower(s)])

  cert_request_pem   = tls_cert_request.requester[lower(each.key)].cert_request_pem
  ca_private_key_pem = tls_private_key.ca.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.ca.cert_pem

  validity_period_hours = 24

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}
