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
# Channels — minimal start: one text, one voice
# ---------------------------------------------------------------------------
resource "discord_text_channel" "text" {
  server_id = var.server_id
  name      = "text"
  topic     = "General conversation."
  position  = 0
}

resource "discord_voice_channel" "voice" {
  server_id = var.server_id
  name      = "Voice"
  position  = 1
}
