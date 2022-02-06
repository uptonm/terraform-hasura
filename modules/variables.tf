variable "environment_namespace" {
  type        = string
  description = "The namespace where all objects will be stored"
}

variable "hasura_graphql_url" {
  type        = string
  description = "The url that the hasura console + graphql endpoint will be hosted from"
}
variable "hasura_graphql_admin_secret" {
  type        = string
  description = "Admin secret key, required to access this instance. This is mandatory when you use webhook or JWT."
}
variable "hasura_graphql_dev_mode" {
  type        = bool
  description = "Set dev mode for GraphQL requests; include the internal key in the errors extensions of the response (if required). (Available for versions > v1.2.0)"
}

variable "postgres_db" {
  type        = string
  description = "The PostgreSQL database name"
}
variable "postgres_user" {
  type        = string
  description = "The PostgreSQL username"
}
variable "postgres_password" {
  type        = string
  description = "The PostgreSQL password"
}
