// deployment flags / environment variables
variable "namespace" {
  type        = string
  description = "K8s deployment namespace (default: default)"
  default     = "default"
}
variable "replicas" {
  type        = number
  description = "K8s deployment replicas (default: 1)"
  default     = 1
  validation {
    condition     = var.replicas > 0
    error_message = "The variable replicas must be greater than 0."
  }
}

// graphql-engine command flags / environment variables
variable "hasura_graphql_database_url" {
  type        = string
  description = "PostgreSQL database URL"
}
variable "hasura_graphql_metadata_database_url" {
  type        = string
  description = "PostgreSQL database URL that will be used to store the Hasura metadata. By default the database configured using var.hasura_graphql_metadata_database_url will be used to store the metadata."
  default     = null
}

// serve sub-command flags / environment variables¶
variable "hasura_graphql_server_port" {
  type        = number
  description = "Port on which graphql-engine should be served (default: 8080)"
  default     = 8080
}
variable "hasura_graphql_server_host" {
  type        = string
  description = "Host on which graphql-engine will listen (default: *)"
  default     = "*"
}
variable "hasura_graphql_enable_console" {
  type        = bool
  description = "Enable the Hasura Console (served by the server on / and /console) (default: false)"
  default     = false
}
variable "hasura_graphql_admin_secret" {
  type        = string
  description = "Admin secret key, required to access this instance. This is mandatory when you use webhook or JWT."
  default     = null
}
variable "hasura_graphql_auth_hook" {
  type        = string
  description = "URL of the authorization webhook required to authorize requests. See auth webhooks docs for more details."
  default     = null
}
variable "hasura_graphql_auth_hook_mode" {
  type        = string
  description = "HTTP method to use for the authorization webhook (default: GET)"
  default     = "GET"
  validation {
    condition     = contains(["GET", "POST"], var.hasura_graphql_auth_hook_mode)
    error_message = "The variable hasura_graphql_auth_hook_mode must be in allowed modes = ['GET', 'POST']."
  }
}
variable "hasura_graphql_jwt_secret" {
  type        = string
  description = "A JSON string containing type and the JWK used for verifying (and other optional details). Example: {\"type\": \"HS256\", \"key\": \"3bd561c37d214b4496d09049fadc542c\"}. See the JWT docs for more details."
  default     = null
}
variable "hasura_graphql_unauthorized_role" {
  type        = string
  description = "Unauthorized role, used when access-key is not sent in access-key only mode or the Authorization header is absent in JWT mode. Example: anonymous. Now whenever the “authorization” header is absent, the request’s role will default to anonymous."
  default     = null
}
variable "hasura_graphql_cors_domain" {
  type        = list(string)
  description = "List of domains, incuding scheme (http/https) and port, to allow for CORS. Wildcard domains are allowed. (See Configure CORS)"
  default     = null
}
variable "hasura_graphql_disable_cors" {
  type        = bool
  description = "Disable CORS. Do not send any CORS headers on any request."
  default     = null
}
variable "hasura_graphql_ws_read_cookie" {
  type        = bool
  description = "Read cookie on WebSocket initial handshake even when CORS is disabled. This can be a potential security flaw! Please make sure you know what you’re doing. This configuration is only applicable when CORS is disabled. (default: false)"
  default     = false
}
variable "hasura_graphql_enable_telemetry" {
  type        = bool
  description = "Enable anonymous telemetry (default: true)"
  default     = true
}
variable "hasura_graphql_events_http_pool_size" {
  type        = number
  description = "Maximum number of concurrent http workers delivering events at any time (default: 100)"
  default     = 100
}
variable "hasura_graphql_events_fetch_interval" {
  type        = number
  description = "Interval in milliseconds to sleep before trying to fetch events again after a fetch returned no events from postgres"
  default     = null
}
variable "hasura_graphql_events_fetch_batch_size" {
  type        = number
  description = "Maximum number of events to be fetched from the DB in a single batch (default: 100) (Available for versions > v2.0.0)"
  default     = 100
}
variable "hasura_graphql_async_actions_fetch_interval" {
  type        = number
  description = "Interval in milliseconds to sleep before trying to fetch events again after a fetch returned no events from postgres"
  default     = null
}
variable "hasura_graphql_pg_stripes" {
  type        = number
  description = "Number of stripes (distinct sub-pools) to maintain with Postgres (default: 1). New connections will be taken from a particular stripe pseudo-randomly."
  default     = 1
}
variable "hasura_graphql_stringify_numeric_types" {
  type        = bool
  description = "Stringify certain Postgres numeric types, specifically bigint, numeric, decimal and double precision as they don’t fit into the IEEE-754 spec for JSON encoding-decoding. (default: false)"
  default     = false
}
variable "hasura_graphql_enabled_apis" {
  type        = list(string)
  description = "Comma separated list of APIs (options: metadata, graphql, pgdump, config) to be enabled. (default: metadata,graphql,pgdump,config)"
  default     = ["metadata", "graphql", "pgdump", "config"]
  validation {
    condition     = length([
    for o in var.hasura_graphql_enabled_apis : true
    if contains(["metadata", "graphql", "pgdump", "config"], o)
    ]) == length(var.hasura_graphql_enabled_apis)
    error_message = "The variable hasura_graphql_enabled_apis may only include allowed apis = ['metadata', 'graphql', 'pgdump', 'config']."
  }
}
variable "hasura_graphql_live_queries_multiplexed_refetch_interval" {
  type        = number
  description = "Updated results (if any) will be sent at most once in this interval (in milliseconds) for live queries which can be multiplexed. Default: 1000 (1sec)"
  default     = 1000
}
variable "hasura_graphql_live_queries_multiplexed_batch_size" {
  type        = number
  description = "Multiplexed live queries are split into batches of the specified size. Default: 100"
  default     = 100
}
variable "hasura_graphql_enable_allowlist" {
  type        = bool
  description = "Restrict queries allowed to be executed by the GraphQL engine to those that are part of the configured allow-list. Default: false"
  default     = false
}
variable "hasura_graphql_console_assets_dir" {
  type        = string
  description = "Set the value to /srv/console-assets for the console to load assets from the server itself instead of CDN"
  default     = null
}
variable "hasura_graphql_enabled_log_types" {
  type        = list(string)
  description = "Set the enabled log types. This is a comma-separated list of log-types to enable. Default: startup, http-log, webhook-log, websocket-log. See log types for more details."
  default     = ["startup", "http-log", "webhook-log", "websocket-log"]
  validation {
    condition     = length([
    for o in var.hasura_graphql_enabled_log_types : true
    if contains(["startup", "http-log", "webhook-log", "websocket-log"], o)
    ]) == length(var.hasura_graphql_enabled_log_types)
    error_message = "The variable hasura_graphql_enabled_log_types may only include allowed log types = ['startup', 'http-log', 'webhook-log', 'websocket-log']."
  }
}
variable "hasura_graphql_log_level" {
  type        = string
  description = "Set the logging level. Default: info. Options: debug, info, warn, error."
  default     = "info"
  validation {
    condition     = contains(["debug", "info", "warn", "error"], var.hasura_graphql_log_level)
    error_message = "The variable hasura_graphql_log_level may only include allowed log types = ['debug', 'info', 'warn', 'error']."
  }
}
variable "hasura_graphql_dev_mode" {
  type        = bool
  description = "Set dev mode for GraphQL requests; include the internal key in the errors extensions of the response (if required). (Available for versions > v1.2.0)"
  default     = null
}
variable "hasura_graphql_admin_internal_errors" {
  type        = bool
  description = "Include the internal key in the errors extensions of the response for GraphQL requests with the admin role (if required). (Available for versions > v1.2.0)"
  default     = null
}
variable "hasura_graphql_enable_remote_schema_permissions" {
  type        = bool
  description = "Enable remote schema permissions (default: false) (Available for versions > v2.0.0)"
  default     = null
}
variable "hasura_graphql_infer_function_permissions" {
  type        = bool
  description = "When the --infer-function-permissions flag is set to false, a function f, stable, immutable or volatile is only exposed for a role r if there is a permission defined on the function f for the role r, creating a function permission will only be allowed if there is a select permission on the table type. When the --infer-function-permissions flag is set to true or the flag is omitted (defaults to true), the permission of the function is inferred from the select permissions from the target table of the function, only for stable/immutable functions. Volatile functions are not exposed to any of the roles in this case. (Available for versions > v2.0.0)"
  default     = null
}
variable "hasura_graphql_schema_sync_poll_interval" {
  type        = number
  description = "Interval to poll metadata storage for updates in milliseconds - Default 1000 (1s) - Set to 0 to disable. (Available for versions > v2.0.0)"
  default     = 1000
}
variable "hasura_graphql_experimental_features" {
  type        = list(string)
  description = "List of experimental features to be enabled. A comma separated value is expected. Options: inherited_roles. (Available for versions > v2.0.0)"
  default     = []
  validation {
    condition     = length([
    for o in var.hasura_graphql_experimental_features : true
    if contains(["inherited_roles"], o)
    ]) == length(var.hasura_graphql_experimental_features)
    error_message = "The variable hasura_graphql_experimental_features may only include allowed experimental features = ['inherited_roles']."
  }
}
variable "hasura_graphql_graceful_shutdown_timeout" {
  type        = number
  description = "Timeout (in seconds) to wait for the in-flight events (event triggers and scheduled triggers) and async actions to complete before the server shuts down completely (default: 60 seconds). If the in-flight events are not completed within the timeout, those events are marked as pending. (Available for versions > v2.0.0)"
  default     = 60
}
variable "hasura_graphql_enable_maintenance_mode" {
  type        = bool
  description = "Disable updating of metadata on the server (default: false) (Available for versions > v2.0.0)"
  default     = false
}
variable "hasura_graphql_connection_compression" {
  type        = bool
  description = "Enable WebSocket permessage-deflate compression (default: false) (Available for versions > v2.0.0)"
  default     = null
}
variable "hasura_graphql_websocket_keepalive" {
  type        = number
  description = "Used to set the Keep Alive delay for client that use the subscription-transport-ws (Apollo) protocol. For graphql-ws clients the graphql-engine sends PING messages instead. (default: 5) (Available for versions > v2.0.0)"
  default     = 5
}
variable "hasura_graphql_websocket_connection_init_timeout" {
  type        = number
  description = "Used to set the connection initialisation timeout for graphql-ws clients. This is ignored for subscription-transport-ws (Apollo) clients. (default: 3)"
  default     = 3
}
