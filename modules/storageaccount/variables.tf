#START - common variables
variable "location" {
  type        = string
}
variable "env" {
  type        = string
}
variable "global_tags" {
  type = map(any)
}
#END - common variables

variable "resourcegroups" {
  type = list(any)
}