locals {
 a_map = {
   "key1" : "value1",
   "key2" : "value2"
 }
 lookup_in_a_map = lookup(local.a_map, "key3", "test")
}


output "lookup_in_a_map" {
 value = local.lookup_in_a_map
}