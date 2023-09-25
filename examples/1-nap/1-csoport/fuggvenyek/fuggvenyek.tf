locals {
  a = "hello"
  b = "world!"

  szam = 7
  szamok = [1,2,3,4,5]

  egymap = {
    "a" = 1,
    "b" = 2,
    "c" = {
      "x" = "cica"
    }
  }

  defaultErtek = "negyvenketto"

}

variable "vilagErtelme" {
  type = string
}

output "helloworld" {
  value = join(" ", [local.a, local.b])
}

output "formazottszam" {
  value = format("%s-%d", local.a, local.szam)
}

output "formazottszamok" {
  value = formatlist("hello-%d", local.szamok)
}

output "mapkeys" {
  value = keys(local.egymap)
}

locals {
  szarmaztatottErtelem = coalesce(var.vilagErtelme, local.defaultErtek)
}

output "vilagTenylegesErtelme" {
  value = local.szarmaztatottErtelem
}

output "vilagErtelmeBase64Enc" {
  value = base64encode(local.szarmaztatottErtelem)
}

output "szamtoString" {
  value = tostring(local.szam)
}
