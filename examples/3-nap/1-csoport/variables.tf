variable "name" {
  type    = string
  default = "uni1"
}

variable "azs" {
  type    = list(string)
  default = ["euc1-az1", "euc1-az2"]
}
