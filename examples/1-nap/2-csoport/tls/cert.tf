resource "tls_private_key" "requester" {
  for_each = {for k, v in var.hostnames : lower(k) => v}

  /*
    take (key,values) from the map hostnames, and create a new map with the new key being lower(k)
    and the new value being v
  */

  algorithm = "RSA"
  rsa_bits  = each.value
}

resource "tls_cert_request" "requester" {
  for_each = {for k, v in var.hostnames : lower(k) => v}

  private_key_pem = tls_private_key.requester[each.key].private_key_pem

  subject {
    common_name  = join(".", [each.key, local.domain])
    organization = "ACME INC."
  }
}

resource "tls_locally_signed_cert" "requester" {
  for_each = {for k, v in var.hostnames : lower(k) => v}

  cert_request_pem   = tls_cert_request.requester[each.key].cert_request_pem
  ca_private_key_pem = tls_private_key.ca.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.ca.cert_pem

  validity_period_hours = 24

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}
