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

# Project Zomboid
output "category_project_zomboid_id" {
  description = "ID of the PROJECT ZOMBOID category."
  value       = discord_category_channel.project_zomboid.id
}

output "channel_zomboid_text_id" {
  description = "ID of the #zomboid-text channel."
  value       = discord_text_channel.zomboid_text.id
}

output "channel_zomboid_voice_id" {
  description = "ID of the Zomboid voice channel."
  value       = discord_voice_channel.zomboid_voice.id
}

output "message_zomboid_server_details_id" {
  description = "ID of the pinned Project Zomboid server details message in #zomboid-text."
  value       = discord_message.zomboid_server_details.id
}

# The Workbench
output "category_the_workbench_id" {
  description = "ID of the THE WORKBENCH category."
  value       = discord_category_channel.the_workbench.id
}

output "channel_the_workbench_text_id" {
  description = "ID of the #the-workbench-text channel."
  value       = discord_text_channel.the_workbench_text.id
}

output "channel_the_workbench_voice_id" {
  description = "ID of the The Workbench Voice channel."
  value       = discord_voice_channel.the_workbench_voice.id
}
