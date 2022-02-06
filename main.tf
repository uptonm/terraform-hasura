terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

provider "kubernetes" {
  host = var.host

  token                  = var.token
  cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
}

module "environment" {
  source = "./modules"
  count  = length(var.environments)

  environment_namespace       = var.environments[count.index].environment_namespace
  hasura_graphql_dev_mode     = var.environments[count.index].hasura_graphql_dev_mode
  hasura_graphql_admin_secret = var.environments[count.index].hasura_graphql_admin_secret
  hasura_graphql_url          = var.environments[count.index].hasura_graphql_url
  postgres_db                 = var.environments[count.index].postgres_db
  postgres_password           = var.environments[count.index].postgres_password
  postgres_user               = var.environments[count.index].postgres_user
}
