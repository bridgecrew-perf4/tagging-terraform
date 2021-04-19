resource "azurerm_resource_group" "main" {
  name     = "rg-${var.app_name}-${var.environment}-${var.owner}"
  location = var.location
  tags = {
    application = var.app_name
    environment = var.environment
    owner       = var.owner
  }
}
resource "azurerm_app_service_plan" "main" {
  name                = "asp-${var.app_name}-${var.environment}-${var.owner}"
  location            = azurerm_resource_group.main.location
  tags = {
    application = var.app_name
    environment = var.environment
    owner       = var.owner
  }
  resource_group_name = azurerm_resource_group.main.name
  kind                = "FunctionApp"
  reserved            = false

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_storage_account" "main" {
  name                     = "st${var.app_name}${var.environment}${var.owner}"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  tags = {
    application = var.app_name
    environment = var.environment
    owner      = var.owner
  }
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_function_app" "main" {
  name                      = "ft-${var.app_name}-${var.environment}-${var.owner}"
  resource_group_name       = azurerm_resource_group.main.name
  location                  = azurerm_resource_group.main.location
  tags = {
    application = var.app_name
    environment = var.environment
    owner      = var.owner
  }
  app_service_plan_id        = azurerm_app_service_plan.main.id
  storage_account_name       = azurerm_storage_account.main.name
  storage_account_access_key = azurerm_storage_account.main.primary_access_key


  app_settings = {
    APPINSIGHTS_INSTRUMENTATIONKEY = azurerm_application_insights.main.instrumentation_key
    FUNCTIONS_WORKER_RUNTIME = "powershell"
  }
  
  identity {
    type = "SystemAssigned"   
  }
}

resource "azurerm_application_insights" "main" {
  name                = "api-${var.app_name}-${var.environment}-${var.owner}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  tags = {
    application = var.app_name
    environment = var.environment
    owner      = var.owner
  }
  application_type    = "web"
}

data "azurerm_subscription" "primary" {
}

resource "azurerm_role_assignment" "reader" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = var.role_reader
  principal_id         = azurerm_function_app.main.identity.0.principal_id
}

resource "azurerm_role_assignment" "tag-contributor" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = var.role_tag
  principal_id         = azurerm_function_app.main.identity.0.principal_id
}