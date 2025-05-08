locals {
 key_value_map = {
   "key1" : "value1",
   "key2" : "value2"
 }
 key_list   = keys(local.key_value_map)
 value_list = values(local.key_value_map)
}

output "key_list" {
 value = local.key_list
}

output "value_list" {
 value = local.value_list
}