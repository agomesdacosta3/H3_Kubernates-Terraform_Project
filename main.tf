# Configurez le fournisseur Azure
provider "azurerm" {
  features {}
}

# Créez un groupe de ressources pour la base de données MySQL
resource "azurerm_resource_group" "caps_group" {
  name     = "caps-group"
  location = "West Europe"
}

# Créez une instance MySQL
resource "azurerm_mysql_flexible_server" "mysql" {
  name                   = "caps-mysql-server"
  location               = azurerm_resource_group.caps_group.location
  resource_group_name    = azurerm_resource_group.caps_group.name
  sku_name               = "GP_Standard_D2ds_v4"
  version                = "5.7"
  administrator_login    = var.mysql_admin_username
  administrator_password = var.mysql_admin_password
}

# Output pour afficher les informations de connexion
output "mysql_connection_string" {
  value = "Server=${azurerm_mysql_flexible_server.mysql.fqdn};Port=3306;Database=mydatabase;User Id=${var.mysql_admin_username};Password=${var.mysql_admin_password}"
}

# Créez un cluster Kubernetes
resource "azurerm_kubernetes_cluster" "caps_cluster" {
  name                = "caps-cluster"
  location            = azurerm_resource_group.caps_group.location
  resource_group_name = azurerm_resource_group.caps_group.name
  dns_prefix          = "caps-cluster-dns"

  default_node_pool {
    name            = "default"
    node_count      = 3
    vm_size         = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    environment = "production"
  }
}
