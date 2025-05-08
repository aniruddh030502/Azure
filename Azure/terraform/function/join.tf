locals {
 join_string = join(",", ["a", "b", "c"])
}

output "join_string" {
 value = local.join_string
}