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

  lifecycle {
    ignore_changes = [position]
  }
}

resource "discord_role" "moderator" {
  server_id   = var.server_id
  name        = "Moderator"
  color       = 15105570 # #e67e22 orange
  hoist       = true
  mentionable = true
  permissions = 1275853888 # Manage messages, kick, ban, mute, deafen, move members

  lifecycle {
    ignore_changes = [position]
  }
}

resource "discord_role" "bot" {
  server_id   = var.server_id
  name        = "Bot"
  color       = 3447003 # #3498db blue
  hoist       = true
  mentionable = false
  permissions = 805306368 # Send messages, embed links, attach files, read message history

  lifecycle {
    ignore_changes = [position]
  }
}

resource "discord_role" "member" {
  server_id   = var.server_id
  name        = "Member"
  color       = 3066993 # #2ecc71 green
  hoist       = false
  mentionable = false
  permissions = 104324160 # View channels, send messages, read message history, add reactions, connect, speak

  lifecycle {
    ignore_changes = [position]
  }
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

  lifecycle {
    ignore_changes = [position, sync_perms_with_category]
  }
}

resource "discord_voice_channel" "voice" {
  server_id = var.server_id
  name      = "voice"
  position  = 2

  lifecycle {
    ignore_changes = [position, sync_perms_with_category, user_limit]
  }
}

# ---------------------------------------------------------------------------
# Channels — Project Zomboid
# ---------------------------------------------------------------------------
resource "discord_category_channel" "project_zomboid" {
  server_id = var.server_id
  name      = "PROJECT ZOMBOID"
  position  = 3

  lifecycle {
    ignore_changes = [position]
  }
}

resource "discord_text_channel" "zomboid_text" {
  server_id = var.server_id
  name      = "zomboid-text"
  topic     = "Project Zomboid server details and event updates."
  position  = 0
  category  = discord_category_channel.project_zomboid.id

  lifecycle {
    ignore_changes = [position, sync_perms_with_category]
  }
}

resource "discord_message" "zomboid_server_details" {
  channel_id = discord_text_channel.zomboid_text.id
  content = trimspace(<<-EOT
    📣 **Project Zomboid Server Details**

    Server: `windurst.ddns.net:16261`
    Password: shared in this channel when rotated and pinned to the top.

    Regular events will be announced here.
  EOT
  )
  pinned = true
}

resource "discord_voice_channel" "zomboid_voice" {
  server_id = var.server_id
  name      = "Zomboid Voice"
  position  = 1
  category  = discord_category_channel.project_zomboid.id

  lifecycle {
    ignore_changes = [position, sync_perms_with_category, user_limit]
  }
}
