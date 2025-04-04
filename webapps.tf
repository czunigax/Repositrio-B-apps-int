resource "azurerm_service_plan" "spproyecto" {
    name = "sp-${var.name_Project}-${var.enviroment}-proyecto"
    location = var.location
    resource_group_name = azurerm_resource_group.rgproyecto.name
    sku_name = "B1"
    os_type = "Linux"
    tags = var.tags

}

resource "azurerm_monitor_autoscale_setting" "autoscale_example" {
  name                = "autoscale-${var.name_Project}-${var.enviroment}"
  resource_group_name = azurerm_resource_group.rgproyecto.name
  target_resource_id  = azurerm_service_plan.spproyecto.id
  enabled             = true
  location            = var.location
  tags                = var.tags

  profile {
    name = "default-profile"

    capacity {
      default = 1
      minimum = 1
      maximum = 10
    }

    rule {
      metric_trigger {
        metric_name        = "CpuPercentage"
        metric_resource_id = azurerm_service_plan.spproyecto.id
        time_grain        = "PT1M"
        statistic         = "Average"
        time_window       = "PT5M"
        time_aggregation  = "Average"
        operator          = "GreaterThan"
        threshold         = 75
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT5M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "CpuPercentage"
        metric_resource_id = azurerm_service_plan.spproyecto.id
        time_grain        = "PT1M"
        statistic         = "Average"
        time_window       = "PT5M"
        time_aggregation  = "Average"
        operator          = "LessThan"
        threshold         = 25
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT5M"
      }
    }
  }
}

resource "azurerm_linux_web_app" "webappui" {
    name = "gui-${var.name_Project}-${var.enviroment}"
    location = var.location
    resource_group_name = azurerm_resource_group.rgproyecto.name
    service_plan_id = azurerm_service_plan.spproyecto.id

    site_config  {
        always_on = false
        application_stack {
            docker_registry_url = "https://index.docker.io/v1/"
            docker_image_name = "nginx:latest"
        }
    }

    app_settings = {
         WEBSITE_PORT = "88"
        STORAGE_ACCOUNT_NAME = "st${var.name_Project}${var.enviroment}proyecto"
        STORAGE_CONTAINER_NAME = "imgs"
    }


}

resource "azurerm_linux_web_app" "webapp_admin"{
    name = "admin-${var.name_Project}-${var.enviroment}"
    location = var.location
    resource_group_name = azurerm_resource_group.rgproyecto.name
    service_plan_id = azurerm_service_plan.spproyecto.id

    site_config  {
        always_on = false
        application_stack {
            docker_registry_url = "https://index.docker.io/v1/"
            docker_image_name = "org/admin-api:latest" #(reemplazar con la imagen de la API)
        }
    }

    app_settings = {
        WEBSITE_PORT ="5000" #Puerto de la API
    }
    
    tags = var.tags
}

