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

resource "discord_text_channel" "announcements" {
  server_id                = var.server_id
  name                     = "announcements"
  topic                    = "Official announcements from the server team."
  position                 = 2
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

# ---------------------------------------------------------------------------
# Permissions: gated access
# ---------------------------------------------------------------------------
locals {
  view_channel_permission = 1024

  gated_categories = {
    general      = discord_category_channel.general.id
    gaming       = discord_category_channel.gaming.id
    preservation = discord_category_channel.preservation.id
  }

  gated_roles = {
    bot       = discord_role.bot.id
    member    = discord_role.member.id
    moderator = discord_role.moderator.id
  }
}

resource "discord_channel_permission" "gated_everyone" {
  for_each = local.gated_categories

  channel_id   = each.value
  overwrite_id = var.server_id
  type         = "role"
  deny         = local.view_channel_permission
}

resource "discord_channel_permission" "gated_access" {
  for_each = {
    for pair in setproduct(keys(local.gated_categories), keys(local.gated_roles)) :
    "${pair[0]}_${pair[1]}" => {
      category_id = local.gated_categories[pair[0]]
      role_id     = local.gated_roles[pair[1]]
    }
  }

  channel_id   = each.value.category_id
  overwrite_id = each.value.role_id
  type         = "role"
  allow        = local.view_channel_permission
}
