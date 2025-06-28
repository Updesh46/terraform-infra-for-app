module "resource_group" {
  source = "../../modules/azurerm_resource_group"

  resource_group_name     = var.resource_group_name
  resource_group_location = var.resource_group_location
}


module "virtual_network" {
  depends_on = [module.resource_group]
  source     = "../../modules/azurerm_virtual_network"

  virtual_network_name     = var.vnet_name
  virtual_network_location = "westus"
  resource_group_name      = var.resource_group_name
  address_space            = ["10.0.0.0/16"]
}


module "subnet_frontend" {
  depends_on = [module.virtual_network]
  source     = "../../modules/azurerm_subnet"

  subnet_name          = var.subnet_frontend_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.resource_group_name
  address_prefixes     = ["10.0.1.0/24"]
}


module "subnet_backend" {
  depends_on = [module.virtual_network]
  source     = "../../modules/azurerm_subnet"

  subnet_name          = "subnetbackend"
  virtual_network_name = var.vnet_name
  resource_group_name  = var.resource_group_name
  address_prefixes     = ["10.0.2.0/24"]
}


module "key_vault" {
  depends_on = [ module.resource_group ]
  source = "../../modules/azurerm_key_vault"

  key_vault_name = var.key_vault_name
  key_vault_location = "westus"
  resource_group_name = var.resource_group_name
}


module "vm_username" {
  depends_on = [ module.key_vault ]
  source = "../../modules/azurerm_key_vault_secret"

  secret_name         = "vm-username"
  secret_value        = "azureuser"
  key_vault_name      = var.key_vault_name
  resource_group_name = var.resource_group_name
  
}


module "vm_password" {
  depends_on = [ module.key_vault ]
  source = "../../modules/azurerm_key_vault_secret"

  secret_name         = "vm-password"
  secret_value        = "p@ssw0rd12345"
  key_vault_name      = var.key_vault_name
  resource_group_name = var.resource_group_name
}

module "sql_server" {
  depends_on = [module.resource_group]
  source     = "../../modules/azurerm_sql_server"

  resource_group_name     = var.resource_group_name
  sql_server_location  = "westus"
  sql_server_name         = "sqlserverinfra"
 administrator_login  = "sqladmin"
  administrator_login_password = "Adminupdeshazurerm@1234"

}

module "sql_database" {
  depends_on = [module.sql_server]

  source     = "../../modules/azurerm_sql_database"
  sql_database = "sqldatabase"
resource_group_name = var.resource_group_name
  sql_server_name = "sqlserverinfra"
  
}


module "public_ip" {
  depends_on = [module.subnet_frontend, module.key_vault, module.vm_username, module.vm_password]
  source              = "../../modules/azurerm_public_ip"
  frontend_ip_name      = "pip-todoapp-frontend"
  public_ip_location  = "westus"
  resource_group_name = var.resource_group_name
}



module "virtual_machine_frontend" {
  depends_on = [module.public_ip,module.subnet_frontend, module.key_vault, module.vm_username, module.vm_password, ]
  source     = "../../modules/azurerm_virtual_machine"

  resource_group_name     = var.resource_group_name
  location               = "westus"
  vm_name                = "vm-frontend2"
  vm_size                = "Standard_B1s"
  image_publisher        = "Canonical"
  image_offer            = "0001-com-ubuntu-server-focal"
  image_sku              = "20_04-lts"
  image_version          = "latest"
  nic_name               = "nic-vm-frontend2"
  frontend_ip_name       = "pip-todoapp-frontend"
  virtual_network_name   = var.vnet_name
  frontend_subnet_name   = var.subnet_frontend_name
  key_vault_name         =  var.key_vault_name
  username_secret_name   = "vm-username"
  password_secret_name   = "vm-password"
}

