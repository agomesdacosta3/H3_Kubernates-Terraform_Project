# Configurez le fournisseur Azure
provider "azurerm" {
  features {}
}

# Créez un groupe de ressources pour le cluster Kubernetes
resource "azurerm_resource_group" "caps_group" {
  name     = "caps-group"
  location = "West Europe"
}

# main.tf

# Configurez le fournisseur Azure
provider "azurerm" {
  features {}
}

# Créez un groupe de ressources pour la base de données MySQL
resource "azurerm_resource_group" "mysql_group" {
  name     = "mysql-group"
  location = "West Europe"
}

# Créez une instance MySQL
resource "azurerm_mysql_server" "mysql" {
  name                = "caps-mysql-server"
  location            = azurerm_resource_group.caps_group.location
  resource_group_name = azurerm_resource_group.caps_group.name
  sku_name            = "B_Gen5_1"
  version             = "5.7"
  administrator_login = "mysqladmin"
  administrator_login_password = "Pass"
}

# Output pour afficher les informations de connexion
output "mysql_connection_string" {
  value = "Server=${azurerm_mysql_server.mysql.fqdn};Port=3306;Database=mydatabase;User Id=mysqladmin;Password=Pass;"
}

# Créez un cluster Kubernetes
resource "azurerm_kubernetes_cluster" "caps_cluster" {
  name                = "caps-cluster"
  location            = azurerm_resource_group.caps_group.location
  resource_group_name = azurerm_resource_group.caps_group.name
  dns_prefix          = "caps-cluster-dns"

  default_node_pool {
    name            = "caps_node_pool"
    node_count      = 3
    vm_size         = "Standard_DS2_v2"
  }

  tags = {
    environment = "production"
  }
}
