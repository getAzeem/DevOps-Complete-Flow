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

variable "jumpbox_subnet_id" {
  description = "Subnet ID for the jumpbox (obfuscated)."
  type        = string
}

variable "jumpbox_size" {
  description = "Size of the jumpbox VM (obfuscated)."
  type        = string
  default     = "Standard_B1s"
}

variable "admin_user" {
  description = "Admin username for jumpbox (obfuscated)."
  type        = string
}

variable "ssh_key" {
  description = "SSH public key for jumpbox (obfuscated)."
  type        = string
}

variable "ssh_allow_cidr" {
  description = "Allowed SSH CIDR (obfuscated)."
  type        = string
  default     = "*"
}
