output "application_gateway_public_ip" {
  description = "Public IP of the Application Gateway"
  value       = azurerm_public_ip.agw_pip.ip_address
}

output "application_gateway_name" {
  description = "Application Gateway name"
  value       = azurerm_application_gateway.agw.name
}

output "backend_ips_used" {
  description = "List of backend IPs configured in the AGW"
  value       = var.backend_ips
}

