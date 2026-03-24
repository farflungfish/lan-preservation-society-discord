terraform {
  required_version = ">= 1.9"

  required_providers {
    discord = {
      source  = "Lucky3028/discord"
      version = "~> 1.5"
    }
  }

  # Uncomment and configure to use Terraform Cloud for remote state:
  # cloud {
  #   organization = "lan-preservation-society"
  #   workspaces {
  #     name = "discord"
  #   }
  # }
}

provider "discord" {
  token = var.discord_token
}
