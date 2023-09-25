variable "hostnames" {
  type    = map(number)

  // hostname -> key_size of the private key
  // toset(["one", "two", ...])

  default = {
    "ONe"   = 2048
    "tWo"   = 4096
    "THrEE" = 2048
  }
}
