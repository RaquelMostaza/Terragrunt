variable "prefix" {
  type        = string
  default     = "git"
  description = "prefiy for env"
}
variable "location" {
  type        = string
  default     = "WestEurope"
  description = "Region to deploy to"
}

variable "rgname" {
  type        = string
  description = "Nameof the RG"
}
