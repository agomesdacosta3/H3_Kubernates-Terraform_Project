# Configurez le fournisseur Azure
provider "azurerm" {
  features {}
}

# Créez un groupe de ressources pour la base de données MySQL
resource "azurerm_resource_group" "caps_group" {
  name     = "caps-group"
  location = "West Europe"
}

# Configurez les ressources Kubernetes pour la base de données MySQL
resource "kubernetes_deployment" "mysql_deployment" {
  metadata {
    name      = "mysql-deployment"
    namespace = "default"
    labels = {
      app = "caps-mysql"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "caps-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "caps-app"
        }
      }

      spec {
        container {
          name  = "caps-mysql-container"
          image = "mysql:5.7"
          ports {
            container_port = 3306
          }
          env {
            name  = "MYSQL_ROOT_PASSWORD"
            value = var.mysql_admin_password
          }
          env {
            name  = "MYSQL_DATABASE"
            value = "mydatabase"
          }
          env {
            name  = "MYSQL_USER"
            value = var.mysql_admin_username
          }
          env {
            name  = "MYSQL_PASSWORD"
            value = var.mysql_admin_password
          }
        }
      }
    }
  }
}

# Service Kubernetes pour exposer la base de données MySQL
resource "kubernetes_service" "caps_mysql_service" {
  metadata {
    name      = "caps-mysql-service"
    namespace = "default"
  }

  spec {
    selector = {
      app = "caps-app"
    }

    port {
      protocol    = "TCP"
      port        = 3306
      target_port = 3306
    }

    type = "LoadBalancer"
  }
}
