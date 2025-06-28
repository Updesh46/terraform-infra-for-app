resource "azurerm_public_ip" "public_ip" {
  name                = var.frontend_ip_name
  location            = var.public_ip_location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"

}