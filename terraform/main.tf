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

resource "discord_text_channel" "welcome" {
  server_id                = var.server_id
  name                     = "welcome"
  topic                    = "Welcome to the LAN Preservation Society! Read the rules here and accept them to unlock the rest of the server."
  position                 = 0
  category                 = discord_category_channel.information.id
  sync_perms_with_category = true
}

resource "discord_text_channel" "rules" {
  server_id                = var.server_id
  name                     = "rules"
  topic                    = "Server rules and guidelines. Accept these rules to gain access to the rest of the server."
  position                 = 1
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
  position                 = 2
  category                 = discord_category_channel.information.id
  sync_perms_with_category = true
}

resource "discord_message" "public_launch_announcement" {
  channel_id = discord_text_channel.announcements.id
  content    = <<-EOT
    📣 **Repository Public Launch — What's New**

    We've just shipped a set of improvements to make it easier for everyone to contribute and stay informed:

    🐛 **Issue Templates** — When you open a GitHub issue you'll now see structured forms for bug reports, feature requests, and general questions. Each type is automatically labelled so the right people get notified.

    🔎 **Daily Triage** — A scheduled workflow runs every morning and flags open issues that have gone quiet, have no label, or have no assignee, keeping things moving.

    🔒 **Security Audit** — A full pre-launch security review has been completed and documented in `SECURITY.md`. No credentials or sensitive data were found in the repository.

    🤖 **Agent Routing** — GitHub Copilot agent suggestions are now documented based on issue labels, so bug reports, feature ideas, and community requests can be routed to the right reviewer with minimal manual triage.

    See the full details in PR #25, or browse the updated README and SECURITY.md.
  EOT
  pinned     = true
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

resource "discord_text_channel" "introductions" {
  server_id                = var.server_id
  name                     = "introductions"
  topic                    = "Introduce yourself to the community!"
  position                 = 1
  category                 = discord_category_channel.general.id
  sync_perms_with_category = true
}

resource "discord_text_channel" "off_topic" {
  server_id                = var.server_id
  name                     = "off-topic"
  topic                    = "Everything that doesn't fit anywhere else."
  position                 = 2
  category                 = discord_category_channel.general.id
  sync_perms_with_category = true
}

resource "discord_text_channel" "bug_reports" {
  server_id = var.server_id
  name      = "bug-reports"
  topic     = "Report server issues and requests. Messages are mirrored to GitHub issues."
  position  = 3
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

resource "discord_text_channel" "gaming_general" {
  server_id                = var.server_id
  name                     = "gaming-general"
  topic                    = "General gaming discussion."
  position                 = 0
  category                 = discord_category_channel.gaming.id
  sync_perms_with_category = true
}

resource "discord_text_channel" "game_nights" {
  server_id                = var.server_id
  name                     = "game-nights"
  topic                    = "Organise and discuss upcoming game nights."
  position                 = 1
  category                 = discord_category_channel.gaming.id
  sync_perms_with_category = true
}

resource "discord_text_channel" "lan_events" {
  server_id                = var.server_id
  name                     = "lan-events"
  topic                    = "Plan and recap LAN events — past and future."
  position                 = 2
  category                 = discord_category_channel.gaming.id
  sync_perms_with_category = true
}

resource "discord_voice_channel" "gaming_voice" {
  server_id                = var.server_id
  name                     = "Gaming Lounge"
  position                 = 3
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

resource "discord_text_channel" "hardware_help" {
  server_id                = var.server_id
  name                     = "hardware-help"
  topic                    = "Get help with retro and legacy hardware."
  position                 = 1
  category                 = discord_category_channel.preservation.id
  sync_perms_with_category = true
}

resource "discord_text_channel" "software_help" {
  server_id                = var.server_id
  name                     = "software-help"
  topic                    = "Get help with retro and legacy software, emulation, and compatibility."
  position                 = 2
  category                 = discord_category_channel.preservation.id
  sync_perms_with_category = true
}

resource "discord_voice_channel" "preservation_voice" {
  server_id                = var.server_id
  name                     = "Preservation Lab"
  position                 = 3
  category                 = discord_category_channel.preservation.id
  sync_perms_with_category = true
}
