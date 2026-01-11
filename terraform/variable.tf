variable "twingate_api_token" {
  type        = string
  description = "Twingate API token from GitHub Secrets"
}

variable "twingate_network" {
  type        = string
  description = "The twingate network name"
  default     = "ssltd"

}