// deployment flags / environment variables
variable "namespace" {
  type        = string
  description = "The K8s deployment namespace"
}

// postgres flags / environment variables
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
