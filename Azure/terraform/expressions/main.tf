variable "people" {
  default = [
    {
      name = "Alice"
      age  = 30
    },
    {
      name = "Bob"
      age  = 40
    }
  ]
}

output "names" {
  value = var.people[*].age
}
