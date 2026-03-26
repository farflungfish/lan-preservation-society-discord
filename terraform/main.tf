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
# CATEGORY: INFORMATION
# ---------------------------------------------------------------------------
resource "discord_category_channel" "information" {
  server_id = var.server_id
  name      = "INFORMATION"
  position  = 0
}

resource "discord_text_channel" "rules" {
  server_id                = var.server_id
  name                     = "rules"
  topic                    = "Server rules and guidelines. Accept these rules to gain access to the rest of the server."
  position                 = 0
  category                 = discord_category_channel.information.id
  sync_perms_with_category = true
}

resource "discord_message" "rules_onboarding" {
  channel_id = discord_text_channel.rules.id
  content    = <<-EOT
    Welcome to the LAN Preservation Society!

    Please read the rules and tap the **Accept Rules** prompt that Discord shows when you join. Once you accept, the rest of the server unlocks automatically—no need to wait for a moderator.

    React with ✅ after you have read and accepted the rules.
  EOT
  pinned     = true
}

data "discord_permission" "rules_allow_readonly" {
  view_channel         = "allow"
  read_message_history = "allow"
  add_reactions        = "allow"
}

data "discord_permission" "rules_deny_posting" {
  send_messages = "deny"
}

resource "discord_channel_permission" "rules_everyone_readonly" {
  channel_id   = discord_text_channel.rules.id
  overwrite_id = var.server_id
  type         = "role"
  allow        = data.discord_permission.rules_allow_readonly.allow_bits
  deny         = data.discord_permission.rules_deny_posting.deny_bits
}

resource "discord_text_channel" "announcements" {
  server_id                = var.server_id
  name                     = "announcements"
  topic                    = "Official announcements from the server team."
  position                 = 1
  category                 = discord_category_channel.information.id
  sync_perms_with_category = true
}

# ---------------------------------------------------------------------------
# CATEGORY: GENERAL
# ---------------------------------------------------------------------------
resource "discord_category_channel" "general" {
  server_id = var.server_id
  name      = "GENERAL"
  position  = 1
}

resource "discord_text_channel" "general_chat" {
  server_id                = var.server_id
  name                     = "general-chat"
  topic                    = "General conversation — anything goes (within the rules)."
  position                 = 0
  category                 = discord_category_channel.general.id
  sync_perms_with_category = true
}

resource "discord_text_channel" "bug_reports" {
  server_id = var.server_id
  name      = "bug-reports"
  topic     = "Report server issues and requests. Messages are mirrored to GitHub issues."
  position  = 1
  category  = discord_category_channel.general.id
}

# ---------------------------------------------------------------------------
# CATEGORY: GAMING
# ---------------------------------------------------------------------------
resource "discord_category_channel" "gaming" {
  server_id = var.server_id
  name      = "GAMING"
  position  = 2
}

resource "discord_text_channel" "lan_events" {
  server_id                = var.server_id
  name                     = "lan-events"
  topic                    = "Plan and recap LAN events — past and future."
  position                 = 0
  category                 = discord_category_channel.gaming.id
  sync_perms_with_category = true
}

resource "discord_voice_channel" "gaming_lounge" {
  server_id                = var.server_id
  name                     = "Gaming Lounge"
  position                 = 1
  category                 = discord_category_channel.gaming.id
  sync_perms_with_category = true
}

# ---------------------------------------------------------------------------
# CATEGORY: PRESERVATION
# ---------------------------------------------------------------------------
resource "discord_category_channel" "preservation" {
  server_id = var.server_id
  name      = "PRESERVATION"
  position  = 3
}

resource "discord_text_channel" "preservation_talk" {
  server_id                = var.server_id
  name                     = "preservation-talk"
  topic                    = "Discussion about preserving games, hardware, and software history."
  position                 = 0
  category                 = discord_category_channel.preservation.id
  sync_perms_with_category = true
}
