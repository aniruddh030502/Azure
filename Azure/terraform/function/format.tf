locals {
 format_list = formatlist("Hello, %s!", ["A", "B", "C"])
}

output "format_list" {
 value = local.format_list
}