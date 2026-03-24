variable "discord_token" {
  description = "Discord bot token used by Terraform to manage the server. Store as a GitHub secret (DISCORD_TOKEN) and never commit to source control."
  type        = string
  sensitive   = true
}

variable "server_id" {
  description = "The ID of the LAN Preservation Society Discord server."
  type        = string
  default     = "1486014276274753697"
}
