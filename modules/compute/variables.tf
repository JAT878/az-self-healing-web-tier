variable "resource_group_name" {
  description = "Name of the resource group to deploy compute resources into."
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

variable "project_name" {
  description = "Project name, surfaced on the demo web page."
  type        = string
}

variable "environment" {
  description = "Environment name, surfaced on the demo web page."
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID the scale set's NICs are attached to."
  type        = string
}

variable "backend_address_pool_ids" {
  description = "Load balancer backend address pool IDs to associate with the scale set."
  type        = list(string)
}

variable "health_probe_id" {
  description = "Load balancer probe ID used for automatic instance repair."
  type        = string
}

variable "vm_size" {
  description = "VM size for each instance."
  type        = string
  default     = "Standard_B1ls"
}

variable "instance_count" {
  description = "Steady-state (and minimum) number of instances - the N+1 capacity floor."
  type        = number
  default     = 2

  validation {
    condition     = var.instance_count >= 2
    error_message = "instance_count must be at least 2 to satisfy the N+1 requirement."
  }
}

variable "admin_username" {
  description = "Local admin username for the VMs."
  type        = string
  default     = "azureuser"
}

variable "admin_ssh_public_key" {
  description = "SSH public key for the admin user (password auth is disabled)."
  type        = string
}

variable "zones" {
  description = "Availability zones to spread instances across."
  type        = list(string)
  default     = ["1", "2", "3"]
}

variable "container_image" {
  description = <<-EOT
    Optional container image (e.g. "ghcr.io/owner/webtier-nginx:latest") to
    run via Docker on each instance instead of installing NGINX natively.
    Leave empty (default) to serve the static page directly from NGINX -
    see container/ for the Dockerfile this image is built from.
  EOT
  type        = string
  default     = ""
}

variable "tags" {
  description = "Common tags applied to all resources."
  type        = map(string)
  default     = {}
}
