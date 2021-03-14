
provider "azurerm" {
  features {}
}

terraform {
  backend "azurerm" {
    resource_group_name  = "NOTEJAM-DEMO-RG1"
    storage_account_name = "kkterraformrmstate"
    container_name       = "terraform-state"
    key                  = "terraform.tfstate"
  }
}
resource "azurerm_resource_group" "dev" {
  name     = var.rg_name
  location = var.location

}
resource "azurerm_postgresql_server" "dev" {
  name                = var.db_server
  location            = "${azurerm_resource_group.dev.location}"
  resource_group_name = "${azurerm_resource_group.dev.name}"

  sku_name = "B_Gen5_1"

  storage_mb                   = 51200
  backup_retention_days        = 7
  geo_redundant_backup_enabled = false
  auto_grow_enabled            = true

  administrator_login          = var.admin_login
  administrator_login_password = var.admin_pwd
  version                      = "11"
  ssl_enforcement_enabled      = true

}
resource "azurerm_postgresql_firewall_rule" "test" {
  name                = "notejamallowaccess"
  server_name         = "${azurerm_postgresql_server.dev.name}"
  resource_group_name = "${azurerm_resource_group.dev.name}"
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

resource "azurerm_postgresql_database" "dev" {
  name                = var.db_name
  server_name         = "${azurerm_postgresql_server.dev.name}"
  resource_group_name = "${azurerm_resource_group.dev.name}"
  charset             = "UTF8"
  collation           = "English_United States.1252"
  depends_on          = [azurerm_postgresql_server.dev]
}

resource "azurerm_app_service_plan" "dev" {
  name                = var.app_plan
  location            = "${azurerm_resource_group.dev.location}"
  resource_group_name = "${azurerm_resource_group.dev.name}"
  kind                = "Linux"
  reserved            = true
  sku {
    tier = "Free"
    size = "B1"
  }
}

resource "azurerm_app_service" "dev" {
  name                = var.app_name
  location            = "${azurerm_resource_group.dev.location}"
  resource_group_name = "${azurerm_resource_group.dev.name}"
  app_service_plan_id = "${azurerm_app_service_plan.dev.id}"

  depends_on = [azurerm_postgresql_database.dev]

  site_config {
    linux_fx_version = "Python|3.8"
  }
  app_settings = {
    "DBHOST" = "${azurerm_postgresql_server.dev.name}"
    "DBNAME" = "${azurerm_postgresql_database.dev.name}"
    "DBUSER" = var.admin_login
    "DBPASS" = var.admin_pwd
  }
}
