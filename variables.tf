variable "project_name" {
  description = "Short project name used as a prefix for all resource names (lowercase alphanumeric and hyphens only)."
  type        = string
  default     = "webtier"

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{1,16}$", var.project_name))
    error_message = "project_name must be 2-17 lowercase alphanumeric characters or hyphens, starting with a letter."
  }
}

variable "environment" {
  description = "Environment name (e.g. dev, staging, prod)."
  type        = string
  default     = "dev"

  validation {
    condition     = can(regex("^[a-z][a-z0-9]{1,9}$", var.environment))
    error_message = "environment must be 2-10 lowercase alphanumeric characters, starting with a letter."
  }
}

variable "location" {
  description = "Azure region for all resources."
  type        = string
  default     = "australiaeast"
}

variable "vm_size" {
  description = "VM size for each web tier instance. Standard_B1ls is the smallest burstable SKU - sufficient for an NGINX welcome page."
  type        = string
  default     = "Standard_B1ls"
}

variable "instance_count" {
  description = "Steady-state (and minimum) number of instances - the N+1 capacity floor. Must be >= 2."
  type        = number
  default     = 2
}

variable "admin_username" {
  description = "Local admin username for the VMs."
  type        = string
  default     = "azureuser"
}

variable "admin_ssh_public_key" {
  description = "SSH public key for the admin user. Generate one with: ssh-keygen -t ed25519 -C \"webtier\" -f ./id_ed25519_webtier"
  type        = string

  validation {
    condition     = can(regex("^(ssh-ed25519|ssh-rsa|ecdsa-sha2-nistp[0-9]+) ", var.admin_ssh_public_key))
    error_message = "admin_ssh_public_key must be a public key starting with ssh-ed25519, ssh-rsa or ecdsa-sha2-*."
  }
}

variable "zones" {
  description = "Availability zones to spread VMSS instances and the load balancer's public IP across."
  type        = list(string)
  default     = ["1", "2", "3"]
}

variable "tags" {
  description = "Additional tags merged into the common tag set on every resource."
  type        = map(string)
  default     = {}
}

variable "container_image" {
  description = <<-EOT
    Optional container image (e.g. "ghcr.io/owner/webtier-nginx:latest") to
    run via Docker on each instance instead of installing NGINX natively.
    Leave empty (default) to serve the static page directly from NGINX.
  EOT
  type        = string
  default     = ""
}
