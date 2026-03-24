# Setup Guide — Connecting Terraform to Your Discord Server

This guide walks you through everything you need to do **once** before Terraform can manage your Discord server.  No prior experience needed.

---

## Overview

Terraform talks to Discord through a **bot**.  Think of the bot as a robot admin account that Terraform logs in as to make changes (create channels, roles, etc.).

You need to:
1. Create the bot in the Discord Developer Portal
2. Give the bot admin rights on your server
3. Copy the bot's secret token
4. Tell Terraform (and GitHub) about the token

The whole process takes about 10 minutes.

---

## Step 1 — Create a Discord Application

1. Open your browser and go to: **<https://discord.com/developers/applications>**
2. Log in with your Discord account if prompted.
3. Click the blue **"New Application"** button in the top-right corner.
4. Type a name for the application — e.g. `LAN Preservation Terraform Bot` — then click **Create**.

You are now on the application settings page.  The application ID shown here is **not** the bot token — keep reading.

---

## Step 2 — Create a Bot User

1. In the left sidebar, click **"Bot"**.
2. Click **"Add Bot"**, then confirm by clicking **"Yes, do it!"**.

You now have a bot user attached to your application.

### Copy the Bot Token

> ⚠️ **The token is a password.  Anyone who has it can control your Discord server.  Never share it, never paste it into a chat, never commit it to Git.**

1. Under the bot's username, click **"Reset Token"** (or **"Copy"** if a token is already shown).
2. Click **"Yes, do it!"** to confirm the reset.
3. Click **"Copy"** to copy the token to your clipboard.
4. Paste it somewhere safe **right now** (e.g. a password manager) — Discord will not show it to you again without resetting it.

The token looks something like:
```
MTQ4NjAxNDI3NjI3NDc1MzY5Nw.GaBcDe.xYz1234567890abcdefghij
```

### Disable Public Bot (Recommended)

While on the Bot page, scroll down and make sure **"Public Bot"** is turned **off**.  This stops strangers from inviting your bot to their servers.

---

## Step 3 — Invite the Bot to Your Server

The bot needs to be a member of your server before it can make any changes.

1. In the left sidebar, click **"OAuth2"** → **"URL Generator"**.
2. Under **"Scopes"**, tick the **`bot`** checkbox.
3. Under **"Bot Permissions"**, tick **"Administrator"**.

   > This gives the bot full control, which Terraform needs to create channels, roles, and categories.  You can restrict permissions later once you are comfortable with how it works.

4. Scroll down — a URL will have been generated in the **"Generated URL"** box.  Click **"Copy"**.
5. Paste the URL into your browser's address bar and press Enter.
6. A Discord page opens.  In the **"Add to Server"** dropdown, select **"LAN Preservation Society"**, then click **"Continue"** → **"Authorize"**.
7. Complete any CAPTCHA if shown.

The bot now appears in your server's member list (it will be offline — that is normal, it only "wakes up" when Terraform runs).

---

## Step 4 — Local Setup (Run Terraform on Your Computer)

Do this if you want to run `terraform plan` / `terraform apply` yourself before relying on GitHub Actions.

### 4a — Install Terraform

| OS      | How to install |
|---------|---------------|
| macOS   | `brew tap hashicorp/tap && brew install hashicorp/tap/terraform` |
| Windows | Download the zip from <https://developer.hashicorp.com/terraform/install>, unzip, and add to PATH |
| Linux   | Follow the instructions at <https://developer.hashicorp.com/terraform/install> for your distro |

Verify it works:
```bash
terraform version
# Should print: Terraform v1.9.x or similar
```

### 4b — Create Your Local Variables File

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
```

Open `terraform/terraform.tfvars` in any text editor and fill in your bot token:

```hcl
discord_token = "paste-your-bot-token-here"
server_id     = "1486014276274753697"
```

> 🔒 `terraform.tfvars` is listed in `.gitignore` so it will **never** be accidentally committed to Git.

### 4c — Initialise Terraform

This downloads the Discord provider plugin (like installing an npm package):

```bash
cd terraform
terraform init
```

You should see:
```
Terraform has been successfully initialized!
```

### 4d — Preview the Changes

```bash
terraform plan
```

Terraform will print a list of everything it wants to create (roles, categories, channels).  **Nothing is changed yet** — this is just a preview.

Read through the plan to make sure it looks right.

### 4e — Apply the Changes

```bash
terraform apply
```

Terraform prints the plan again and asks:
```
Do you want to perform these actions? Enter a value:
```

Type `yes` and press Enter.

Terraform will now create all the channels, categories, and roles in your Discord server.  This takes about 30–60 seconds.

> ⚠️ **Existing channels and roles are NOT touched** unless you import them first (see the Importing Existing Resources section below).  Terraform only manages what it creates.

---

## Step 5 — Add the Token to GitHub (for the CI Pipeline)

This lets GitHub Actions run `terraform plan` automatically on every Pull Request.

1. Go to your repository on GitHub: `https://github.com/farflungfish/lan-preservation-society-discord`
2. Click **Settings** (the tab at the top of the repo page).
3. In the left sidebar, click **Secrets and variables** → **Actions**.
4. Click **"New repository secret"**.
5. Fill in:
   - **Name**: `DISCORD_TOKEN`
   - **Secret**: paste your bot token
6. Click **"Add secret"**.

That's it.  The CI workflow (`pr-validation.yml`) will now be able to run `terraform plan` on every PR and post the output as a comment.

---

## Step 6 — (Optional) Set Up a `production` Environment for Apply Protection

By default, `terraform apply` runs automatically when code is merged to `main`.  If you want a manual approval gate before apply runs:

1. In your repo on GitHub, go to **Settings** → **Environments**.
2. Click **"New environment"** and name it `production`.
3. Under **"Protection rules"**, tick **"Required reviewers"** and add yourself (`@farflungfish`).
4. Click **"Save protection rules"**.

Now the apply workflow will pause and wait for your approval before running.

---

## Importing Existing Resources

If your Discord server already has channels or roles that you want Terraform to manage (instead of creating duplicates), you need to **import** them.

Find the channel or role ID in Discord:
1. In Discord, go to **User Settings** → **Advanced** → enable **"Developer Mode"**.
2. Right-click any channel or role and choose **"Copy ID"**.

Then run:
```bash
# Example: import an existing channel
terraform import discord_text_channel.general_chat <channel-id>

# Example: import an existing role
terraform import discord_role.member <role-id>
```

After importing, run `terraform plan` — it should show no changes for the imported resource.

---

## Troubleshooting

| Problem | Likely cause | Fix |
|---------|-------------|-----|
| `Error: 403 Forbidden` | Bot doesn't have permission | Make sure the bot has Administrator permission in Server Settings → Roles |
| `Error: 401 Unauthorized` | Wrong token | Double-check the token in `terraform.tfvars` — reset it in the Developer Portal if unsure |
| Bot is not in the server | Skipped Step 3 | Follow Step 3 to invite the bot |
| `terraform: command not found` | Terraform not installed | Follow Step 4a |
| Duplicate channels appear | Existing channels not imported | Follow the "Importing Existing Resources" section above |

---

## Quick Reference — Useful Links

- Discord Developer Portal: <https://discord.com/developers/applications>
- Terraform Install: <https://developer.hashicorp.com/terraform/install>
- Lucky3028 Discord Provider docs: <https://registry.terraform.io/providers/Lucky3028/discord/latest/docs>
- Your repo: <https://github.com/farflungfish/lan-preservation-society-discord>
