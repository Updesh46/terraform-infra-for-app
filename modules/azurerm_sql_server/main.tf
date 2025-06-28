resource "azurerm_mssql_server" "sql_server" {
  name                         = var.sql_server_name
  location                     = var.sql_server_location
  resource_group_name          = var.resource_group_name
  version                      = "12.0"
  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_login_password


}