locals {
  a     = "hello"
  b     = "world!"
  digit = 6

  digits = [1, 2, 3, 4, 5, 6]

  defaultHostname = "localhost"

  derivedHostname = format("%s-%d", local.defaultHostname, local.digit)

  aMap = {
    "a" = "hello",
    "b" = "world",
    "c" = 3,
    "e" = {
      "x" = "y"
    }
  }

  helloworld = join(" ", [local.a, local.b])
}

variable "hostname" {
  type    = string
  default = "somethingelse"
}

output "helloworld" {
  value = local.helloworld
}

output "formattedValue" {
  value = format("%s-%d", local.a, local.digit)
}

output "formattedValues" {
  value = formatlist("hello-%d", local.digits)
}

// comment1
# comment2
/*
comment3
*/
output "hostnameDefaultingLogic" {
  value = coalesce(var.hostname, local.defaultHostname)
}

output "mapkeys" {
  value = keys(local.aMap)
}

locals {
  defaultLookupMap = {
    "default" = "true"
  }

  derivedSomeDeepValue = lookup(lookup(local.aMap, "e", local.defaultLookupMap), "x", "")
}

output "someDeepValue" {
  value = local.derivedSomeDeepValue
}

output "base64encodedHelloWorld" {
  value = base64encode(local.helloworld)
}