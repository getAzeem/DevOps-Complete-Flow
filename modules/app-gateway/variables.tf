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

variable "gw_subnet_id" {
  description = "Subnet ID where Application Gateway will be deployed (obfuscated)."
  type        = string
}

variable "backend_list" {
  description = "List of backend IPs (obfuscated)."
  type        = list(string)
  default     = []
}