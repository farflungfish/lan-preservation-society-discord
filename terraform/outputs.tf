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

# Category IDs
output "category_information_id" {
  description = "ID of the INFORMATION category channel."
  value       = discord_category_channel.information.id
}

output "category_general_id" {
  description = "ID of the GENERAL category channel."
  value       = discord_category_channel.general.id
}

output "category_gaming_id" {
  description = "ID of the GAMING category channel."
  value       = discord_category_channel.gaming.id
}

output "category_preservation_id" {
  description = "ID of the PRESERVATION category channel."
  value       = discord_category_channel.preservation.id
}

# Key channel IDs
output "channel_rules_id" {
  description = "ID of the #rules channel."
  value       = discord_text_channel.rules.id
}

output "channel_announcements_id" {
  description = "ID of the #announcements channel."
  value       = discord_text_channel.announcements.id
}

output "message_public_launch_announcement_id" {
  description = "ID of the public launch announcement message in #announcements."
  value       = discord_message.public_launch_announcement.id
}

output "channel_general_chat_id" {
  description = "ID of the #general-chat channel."
  value       = discord_text_channel.general_chat.id
}

output "channel_bug_reports_id" {
  description = "ID of the #bug-reports channel."
  value       = discord_text_channel.bug_reports.id
}
