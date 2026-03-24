terraform {
  required_version = ">= 1.9"

  required_providers {
    discord = {
      source  = "Lucky3028/discord"
      version = "~> 1.5"
    }
  }

  cloud {
    # organization is read from the TF_CLOUD_ORGANIZATION environment variable
    workspaces {
      name = "lan-preservation-society-discord"
    }
  }
}

provider "discord" {
  token = var.discord_token
}
