variable "px" {
  description = "Project identifier (obfuscated)."
  type        = string
}

variable "env" {
  description = "Environment tag (obfuscated)."
  type        = string
}

variable "region" {
  description = "Azure region (obfuscated)."
  type        = string
}

variable "rg" {
  description = "Resource group name (obfuscated)."
  type        = string
}

variable "tags" {
  description = "Map of common tags (obfuscated)."
  type        = map(string)
  default     = {}
}

variable "replica_count" {
  description = "Number of VM replicas (obfuscated)."
  type        = number
  default     = 1
}

variable "inst_size" {
  description = "Instance size for VMs (obfuscated)."
  type        = string
  default     = "Standard_Av2"
}

variable "admin_user" {
  description = "Admin username for VMs (obfuscated)."
  type        = string
}

variable "ssh_key" {
  description = "SSH public key for VMs (obfuscated)."
  type        = string
}

variable "net_subnet_id" {
  description = "Subnet ID where VMs will be deployed (obfuscated)."
  type        = string
}