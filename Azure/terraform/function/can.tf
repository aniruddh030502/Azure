variable "a" {
 type = number
 validation {
   condition     = can(tonumber(var.a))
   error_message = format("This is not a number: %v", var.a)
 }
 default = "1234"
}