# Creación de IP Pública
resource "azurerm_public_ip" "appgw_pip" {
  name                = "appgw-public-ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.rgproyecto.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Application Gateway con WAF habilitado
resource "azurerm_application_gateway" "main" {
  name                = "appgw-${var.name_Project}-${var.enviroment}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rgproyecto.name

  sku {
    name     = "WAF_v2"
    tier     = "WAF_v2"
    capacity = 1
  }

  gateway_ip_configuration {
    name      = "appgw-ip-config"
    subnet_id = azurerm_subnet.appgw_subnet.id # Asegúrate de tener este subnet definido
  }

  frontend_port {
    name = "http-port"
    port = 80
  }

  frontend_port {
    name = "https-port"
    port = 443
  }

  frontend_ip_configuration {
    name                 = "appgw-frontend-ip"
    public_ip_address_id = azurerm_public_ip.appgw_pip.id
  }

  backend_address_pool {
    name = "backend-pool"
    # Configura según tu backend (IPs o FQDNs)
    fqdns = ["backend.azurewebsites.net"] 
  }

  backend_http_settings {
    name                  = "http-settings"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = "http-listener"
    frontend_ip_configuration_name = "appgw-frontend-ip"
    frontend_port_name             = "http-port"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "routing-rule"
    rule_type                  = "Basic"
    priority                   = 100
    http_listener_name         = "http-listener"
    backend_address_pool_name  = "backend-pool"
    backend_http_settings_name = "http-settings"
  }

  # Configuración WAF actualizada para azurerm >= 3.0
  waf_configuration {
    enabled          = true
    firewall_mode    = "Detection" 
    rule_set_type    = "OWASP"
    rule_set_version = "3.2"

    # Configuración opcional de reglas deshabilitadas
    disabled_rule_group {
      rule_group_name = "REQUEST-942-APPLICATION-ATTACK-SQLI"
      rules           = [942100, 942110] 
    }

    request_body_check       = true
    max_request_body_size_kb = 128
    file_upload_limit_mb     = 100
  }

  tags = var.tags
}