locals {
  integration = lower(replace(var.INTEGRATION_NAME, "/[^a-zA-Z0-9]/", ""))
  suffix      = random_string.suffix.result

  # e.g. rg-func-testintegration-dev-uks
  rg_name   = "rg-func-${local.integration}-${var.ENVIRONMENT}-${var.REGION}"
  plan_name = "asp-${local.integration}-${var.ENVIRONMENT}-${var.REGION}"
  app_name  = "func-${local.integration}-${var.ENVIRONMENT}-${var.REGION}-${local.suffix}"

  # Storage account names: 3-24 chars, lowercase letters and digits only
  sa_name = substr("stfn${substr(local.integration, 0, 10)}${var.ENVIRONMENT}${var.REGION}${local.suffix}", 0, 24)

  tags = {
    integration = var.INTEGRATION_NAME
    environment = var.ENVIRONMENT
    region      = var.REGION
    branch      = var.GITHUB_BRANCH_NAME
    managed_by  = "terraform"
  }
}

resource "random_string" "suffix" {
  length  = 4
  upper   = false
  special = false
}

resource "azurerm_resource_group" "this" {
  name     = local.rg_name
  location = var.LOCATION
  tags     = local.tags
}

# Storage account required by the Function App runtime
resource "azurerm_storage_account" "func" {
  name                     = local.sa_name
  resource_group_name      = azurerm_resource_group.this.name
  location                 = azurerm_resource_group.this.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
  tags                     = local.tags
}

resource "azurerm_service_plan" "this" {
  name                = local.plan_name
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  os_type             = "Linux"
  sku_name            = var.FUNCTION_PLAN_SKU
  tags                = local.tags
}

resource "azurerm_linux_function_app" "this" {
  name                = local.app_name
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  service_plan_id            = azurerm_service_plan.this.id
  storage_account_name       = azurerm_storage_account.func.name
  storage_account_access_key = azurerm_storage_account.func.primary_access_key
  https_only                 = true

  site_config {
    application_stack {
      node_version = "20"
    }
  }

  app_settings = {
    FUNCTIONS_WORKER_RUNTIME = "node"
  }

  tags = local.tags
}

