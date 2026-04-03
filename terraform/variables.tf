variable "server_id" {
  description = "The ID of the LAN Preservation Society Discord server."
  type        = string
  default     = "1486014276274753697"
}

variable "discord_token" {
  description = "Discord bot token. Optional here so HCP Terraform tfvars do not warn if this is set."
  type        = string
  sensitive   = true
  default     = null
}
