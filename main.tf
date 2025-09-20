locals {
  vnet_name       = "agw"
  agw_subnet_name = "agw-subnet"
  vm_subnet_name  = "vm-subnet"
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = local.vnet_name
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "agw_subnet" {
  name                 = local.agw_subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "vm_subnet" {
  name                 = local.vm_subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "agw_pip" {
  name                = "${var.prefix}-agw-pip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_application_gateway" "agw" {
  name                = "${var.prefix}-agw"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 1
  }

  gateway_ip_configuration {
    name      = "gatewayIpConfig"
    subnet_id = azurerm_subnet.agw_subnet.id
  }

  frontend_port {
    name = "frontendPort80"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "publicFrontend"
    public_ip_address_id = azurerm_public_ip.agw_pip.id
  }

  backend_address_pool {
    name        = "backendPool"
    ip_addresses = var.backend_ips
  }

  backend_http_settings {
    name                  = "httpSetting"
    port                  = 8080
    protocol              = "Http"
    cookie_based_affinity = "Disabled"
    request_timeout       = 30
    probe_name            = "httpProbe"
  }

  probe {
    name                = "httpProbe"
    protocol            = "Http"
    path                = "/"
    interval            = 30
    timeout             = 10
    unhealthy_threshold = 3
    port                = 8080
    host                = "127.0.0.1"
  }

  http_listener {
    name                           = "listener80"
    frontend_ip_configuration_name = "publicFrontend"
    frontend_port_name             = "frontendPort80"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "rule1"
    rule_type                  = "Basic"
    http_listener_name         = "listener80"
    backend_address_pool_name  = "backendPool"
    backend_http_settings_name = "httpSetting"
    priority                   = 100
  }
}

