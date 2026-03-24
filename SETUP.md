# Setup Guide

Step-by-step instructions for first-time contributors and repository maintainers.

---

## 1. Discord Bot Setup

1. Go to the [Discord Developer Portal](https://discord.com/developers/applications) and create a new application.
2. Under **Bot**, enable the **Server Members Intent** and **Message Content Intent** (if needed).
3. Copy the **Bot Token** — you will need it as the `DISCORD_TOKEN` secret.
4. Under **OAuth2 → URL Generator**, select the `bot` scope and the following permissions:
   - Manage Channels
   - Manage Roles
   - Send Messages
   - Read Message History
5. Use the generated URL to invite the bot to your Discord server.

---

## 2. Terraform Cloud (HCP Terraform) Setup

1. Sign up or log in at <https://app.terraform.io>.
2. Create a new **Organization**.
3. Create a new **Workspace** connected to this GitHub repository.
4. In the workspace **Variables**, add:
   - `discord_token` (sensitive) — your Discord bot token
   - `server_id` — your Discord server ID
5. Generate a **User or Team API Token** for use in CI.

---

## 3. GitHub Repository Secrets & Variables

Go to **Settings → Secrets and variables → Actions** and add:

| Type | Name | Value |
|------|------|-------|
| Secret | `DISCORD_TOKEN` | Your Discord bot token |
| Secret | `TF_API_TOKEN` | Your Terraform Cloud API token |
| Variable | `TF_CLOUD_ORGANIZATION` | Your Terraform Cloud organization name |

---

## 4. Local Development

```bash
# Clone the repository
git clone https://github.com/farflungfish/lan-preservation-society-discord.git
cd lan-preservation-society-discord

# Copy the example vars file and fill in your values
cp terraform/terraform.tfvars.example terraform/terraform.tfvars
# Edit terraform.tfvars — add discord_token and server_id

# Initialise Terraform
cd terraform
terraform init

# Preview changes
terraform plan

# Apply changes (only after PR approval in the real workflow!)
terraform apply
```

---

## 5. Branch Protection (Repository Maintainers)

To protect the `main` branch so that all PRs must pass CI and be reviewed before merging:

1. Go to **Settings → Branches** in the GitHub repository.
2. Click **Add branch protection rule**.
3. Set **Branch name pattern** to `main`.
4. Enable the following options:

   | Setting | Value |
   |---------|-------|
   | Require a pull request before merging | ✅ Enabled |
   | Require approvals | 1 (or more) |
   | Require review from Code Owners | ✅ Enabled |
   | Require status checks to pass before merging | ✅ Enabled |
   | Required status checks | `Markdown Lint`, `Terraform Format`, `Terraform Validate`, `TFLint` |
   | Require branches to be up to date before merging | ✅ Enabled |
   | Do not allow bypassing the above settings | ✅ Recommended |

5. Click **Save changes**.

> **Tip**: The required status check names must exactly match the `name:` field in `.github/workflows/pr-validation.yml`.

---

## 6. Terraform Production Environment Gate (Optional)

To require manual approval before `terraform apply` runs on merge:

1. Go to **Settings → Environments** and create an environment named `production`.
2. Add **Required reviewers** (e.g., `@farflungfish`).
3. The `terraform-apply.yml` workflow is already configured to use this environment.

---

## Troubleshooting

| Symptom | Likely Cause | Fix |
|---------|-------------|-----|
| `Error: Invalid provider configuration` | `discord_token` variable not set | Add `DISCORD_TOKEN` secret to GitHub Actions |
| `terraform plan` skipped in CI | Secrets not configured | Follow Section 3 above |
| `Error 403` from Discord API | Bot lacks permissions | Re-invite the bot with the correct OAuth2 scopes |
| `terraform init` fails with backend error | Terraform Cloud not configured | Follow Section 2, or use `terraform init -backend=false` for local validation |
