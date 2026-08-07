variable "twingate_api_token" {
  type        = string
  description = "Twingate API token from GitHub Secrets"
}

// Check why this isnt working correctly.
variable "twingate_network" {
  type        = string
  description = "The twingate network name"
  default     = "sayedsylvainltd"

}