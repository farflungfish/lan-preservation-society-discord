terraform {
  required_version = ">= 1.9"

  required_providers {
    discord = {
      source  = "Lucky3028/discord"
      version = "~> 1.5"
    }
  }

  # Remote state is stored in Terraform Cloud (HCP Terraform) free tier.
  # Set the TF_CLOUD_ORGANIZATION GitHub variable to your HCP Terraform org name.
  # See SETUP.md for step-by-step instructions.
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
