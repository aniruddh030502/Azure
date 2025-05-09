variable "cidr_block" {
 type    = string
 default = "10.0.0.0/8"
 validation {
   condition     = split("/", var.cidr_block)[1] > 16 && split("/", var.cidr_block)[1] < 30
   error_message = "Your vpc cidr is not between 16 and 30"
 }
}

output "cidr"{
    value=var.cidr_block
}