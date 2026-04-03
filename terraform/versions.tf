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
  # Token is read from the DISCORD_TOKEN environment variable automatically.
  # Set DISCORD_TOKEN as a workspace environment variable in HCP Terraform.
  token = var.discord_token
}
