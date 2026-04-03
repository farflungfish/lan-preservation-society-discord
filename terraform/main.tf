# ---------------------------------------------------------------------------
# Roles
# ---------------------------------------------------------------------------
resource "discord_role" "admin" {
  server_id   = var.server_id
  name        = "Admin"
  color       = 15158332 # #e74c3c red
  hoist       = true
  mentionable = true
  permissions = 8 # Administrator
}

resource "discord_role" "moderator" {
  server_id   = var.server_id
  name        = "Moderator"
  color       = 15105570 # #e67e22 orange
  hoist       = true
  mentionable = true
  permissions = 1275853888 # Manage messages, kick, ban, mute, deafen, move members
}

resource "discord_role" "bot" {
  server_id   = var.server_id
  name        = "Bot"
  color       = 3447003 # #3498db blue
  hoist       = true
  mentionable = false
  permissions = 805306368 # Send messages, embed links, attach files, read message history
}

resource "discord_role" "member" {
  server_id   = var.server_id
  name        = "Member"
  color       = 3066993 # #2ecc71 green
  hoist       = false
  mentionable = false
  permissions = 104324160 # View channels, send messages, read message history, add reactions, connect, speak
}

# ---------------------------------------------------------------------------
# Channels — minimal start
# ---------------------------------------------------------------------------

# #announcements was deleted from Discord directly; remove from state only.
removed {
  from = discord_text_channel.announcements
  lifecycle {
    destroy = false
  }
}

removed {
  from = discord_message.minimal_start_announcement
  lifecycle {
    destroy = false
  }
}

resource "discord_text_channel" "text" {
  server_id = var.server_id
  name      = "text"
  topic     = "General conversation."
  position  = 1
}

resource "discord_message" "rules_message" {
  channel_id = discord_text_channel.text.id
  content    = "Don't be a dick."
  pinned     = true
}

resource "discord_voice_channel" "voice" {
  server_id = var.server_id
  name      = "voice"
  position  = 2
}

# ---------------------------------------------------------------------------
# Channels — Project Zomboid
# ---------------------------------------------------------------------------
resource "discord_category_channel" "project_zomboid" {
  server_id = var.server_id
  name      = "PROJECT ZOMBOID"
  position  = 3
}

resource "discord_text_channel" "project_zomboid" {
  server_id = var.server_id
  name      = "project-zomboid"
  topic     = "Project Zomboid server info and coordination. Address: windurst.ddns.net:16261. Password shared here when rotated and pinned."
  position  = 0
  category  = discord_category_channel.project_zomboid.id
}

resource "discord_message" "project_zomboid_details" {
  channel_id = discord_text_channel.project_zomboid.id
  content    = <<-EOT
    🧟 **Project Zomboid Server**

    - Address: `windurst.ddns.net:16261`
    - Password: A password is required; the current password will be shared in this channel and kept pinned when rotated.
    - Notes: Event coordination and bot updates for the Zomboid server live here.
  EOT
  pinned     = true
}

resource "discord_voice_channel" "project_zomboid" {
  server_id = var.server_id
  name      = "🔊 Project Zomboid"
  position  = 1
  category  = discord_category_channel.project_zomboid.id
}
