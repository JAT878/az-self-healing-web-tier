variable "resource_group_name" {
  description = "Name of the resource group to deploy the load balancer into."
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

variable "tags" {
  description = "Common tags applied to all resources."
  type        = map(string)
  default     = {}
}
