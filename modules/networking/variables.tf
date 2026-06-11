variable "resource_group_name" {
  description = "Name of the resource group to deploy networking resources into."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "name_prefix" {
  description = "Prefix used to build resource names, e.g. 'webtier-dev'."
  type        = string
}

variable "vnet_address_space" {
  description = "Address space for the virtual network."
  type        = list(string)
  default     = ["10.20.0.0/16"]
}

variable "subnet_address_prefixes" {
  description = "Address prefixes for the web subnet."
  type        = list(string)
  default     = ["10.20.1.0/24"]
}

variable "tags" {
  description = "Common tags applied to all resources."
  type        = map(string)
  default     = {}
}
