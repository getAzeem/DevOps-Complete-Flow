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

variable "net_space" {
  description = "VNet address space (obfuscated)."
  type        = list(string)
}

variable "priv_subnet" {
  description = "Private subnet CIDR (obfuscated)."
  type        = string
}

variable "pub_subnet" {
  description = "Public subnet CIDR (obfuscated)."
  type        = string
}
