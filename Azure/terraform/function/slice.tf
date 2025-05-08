locals {
 slice_list = slice([1, 2, 3, 4], 2, 4)
}


output "slice_list" {
 value = local.slice_list
}