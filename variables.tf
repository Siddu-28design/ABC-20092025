variable "prefix" {
  description = "Prefix for all resources"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "backend_ips" {
  description = "List of backend IPs (VM1 private IP and VM2 public IP)"
  type        = list(string)
}

