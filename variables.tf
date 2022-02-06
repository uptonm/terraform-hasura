variable "host" {
  type        = string
  description = "K8s cluster host"
}
variable "token" {
  type        = string
  description = "K8s cluster token"
}
variable "cluster_ca_certificate" {
  type        = string
  description = "K8s cluster certificate authority data"
}

variable "environments" {
  type = list(object({
    environment_namespace       = string
    hasura_graphql_dev_mode     = bool
    hasura_graphql_admin_secret = string
    hasura_graphql_url          = string
    postgres_db                 = string
    postgres_password           = string
    postgres_user               = string
  }))
  description = "List of environments to create/update"
  default = [
    {
      environment_namespace       = "dev"
      hasura_graphql_dev_mode     = true
      hasura_graphql_admin_secret = "test"
      hasura_graphql_url          = "graphql-dev.mydomain.com"
      postgres_db                 = "postgres"
      postgres_password           = "postgres"
      postgres_user               = "postgres"
    }
  ]
}
