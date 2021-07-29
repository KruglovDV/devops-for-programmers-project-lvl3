variable "do_token" {
  description = "Digital ocean access token"
  type        = string
  sensitive   = true
}

variable "datadog_api_key" {
  type      = string
  default   = ""
  sensitive = true
}

variable "datadog_app_key" {
  type      = string
  default   = ""
  sensitive = true
}
