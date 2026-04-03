output "server_id" {
  description = "The Discord server ID being managed."
  value       = var.server_id
}

# Roles
output "role_admin_id" {
  description = "ID of the Admin role."
  value       = discord_role.admin.id
}

output "role_moderator_id" {
  description = "ID of the Moderator role."
  value       = discord_role.moderator.id
}

output "role_member_id" {
  description = "ID of the Member role."
  value       = discord_role.member.id
}

output "role_bot_id" {
  description = "ID of the Bot role."
  value       = discord_role.bot.id
}

# Channel IDs
output "channel_text_id" {
  description = "ID of the #text channel."
  value       = discord_text_channel.text.id
}

output "channel_voice_id" {
  description = "ID of the #voice channel."
  value       = discord_voice_channel.voice.id
}

# Pinned message IDs
output "message_rules_id" {
  description = "ID of the pinned rule message in #text."
  value       = discord_message.rules_message.id
}
