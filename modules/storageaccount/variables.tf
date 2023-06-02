variable "rg_name" {
  type        = string
  description = "Resource group name"
}

variable "location" {
  type        = string
  description = "Location of the resource group"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A mapping of tags which should be assigned to the Resource Group"
}

variable "prefix" {
  type        = string
  description = "Prefix for the module name"
}

variable "postfix" {
  type        = string
  description = "Postfix for the module name"
}

variable "env" {
  type        = string
  description = "Environment prefix"
}

variable "hns_enabled" {
  type        = bool
  description = "Hierarchical namespaces enabled/disabled"
  default     = true
}

variable "ip_ranges" {
  type    = set(string)
  default = []
}

variable "enable_aml_secure_workspace" {
  description = "Variable to enable or disable AML secure workspace"
}
variable "vnet_name" {
  type        = string
  description = "Name of the virtual network"
}

variable "vnet_rg" {
  type        = string
  description = "Name of the resource group containing the virtual network"
}

variable "subnet_name" {
  type        = string
  description = "Name of the subnet within the virtual network"
}

variable "private_link_access" {
  type        = list(string)
  default     = null
  description = "Define a list of endpoint id's to whitelist on network rules"
}
