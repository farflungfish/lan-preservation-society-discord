# Setup Guide — Connecting Terraform to Your Discord Server

This guide walks you through everything you need to do **once** before Terraform can manage your Discord server.  No prior experience needed.

---

## Overview

Terraform talks to Discord through a **bot**.  Think of the bot as a robot admin account that Terraform logs in as to make changes (create channels, roles, etc.).

Terraform also needs somewhere to remember what it has already created — this is called **state**.  We store state in **Terraform Cloud (HCP Terraform)**, which is **free** and works natively with GitHub Actions.

You need to:
1. Create the bot in the Discord Developer Portal
2. Give the bot admin rights on your server
3. Copy the bot's secret token
4. Set up a free Terraform Cloud account (for state storage)
5. Tell GitHub about your tokens so the CI pipeline can run

The whole process takes about 20 minutes.

> ℹ️ **Does GitHub store Terraform state?**  No — GitHub has no native Terraform state backend.  The closest free option that integrates tightly with GitHub is [Terraform Cloud (HCP Terraform)](https://app.terraform.io), which this repo is already configured to use.

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

This downloads the Discord provider plugin and connects to Terraform Cloud for state storage.

You need to log in to Terraform Cloud first:

```bash
terraform login
```

Follow the prompts — it will open a browser window where you approve the login.  This saves a token in `~/.terraform.d/credentials.tfrc.json` so you don't need to repeat this.

Next, tell Terraform which organisation to use by setting the `TF_CLOUD_ORGANIZATION` environment variable to the organisation name you created in Step 5b:

**macOS / Linux:**
```bash
export TF_CLOUD_ORGANIZATION="your-org-name-here"
```

**Windows (PowerShell):**
```powershell
$env:TF_CLOUD_ORGANIZATION = "your-org-name-here"
```

Then initialise:

```bash
cd terraform
terraform init
```

You should see:
```
Terraform Cloud has been successfully initialized!
```

> If you haven't set up Terraform Cloud yet (Step 5), run `terraform init -backend=false` instead.  This skips state storage and still lets you validate the configuration locally.

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

## Step 5 — Set Up Terraform Cloud (Free State Storage)

Terraform needs to remember what resources it has already created in your Discord server.  This memory is called **state**.  We store it in **Terraform Cloud (HCP Terraform)**, which is free for up to 500 resources.

> **Why not store state in GitHub?**  GitHub has no native Terraform state backend — it can't safely track locks to prevent two people applying at the same time.  Terraform Cloud solves this and is purpose-built for the job.

### 5a — Create a Free Account

1. Go to **<https://app.terraform.io>** and click **"Sign up"**.
2. Enter your email, username, and a strong password, then click **"Create account"**.
3. Verify your email when prompted.

### 5b — Create an Organisation

An *organisation* is like a workspace folder.  You only need one.

1. After signing in, you will be prompted to **"Create your organization"**.
2. Enter an organisation name — e.g. `lan-preservation-society` (must be globally unique on the platform).
3. Click **"Create organization"**.

> 📝 Note this organisation name — you'll need it in Step 6.

### 5c — Create a Workspace

1. In your organisation, click **"New workspace"**.
2. Choose **"CLI-driven workflow"** (not the GitHub-connected option — we drive it from GitHub Actions ourselves).
3. Name the workspace exactly: `lan-preservation-society-discord`
4. Click **"Create workspace"**.

### 5d — Generate a Terraform Cloud API Token

This is how GitHub Actions authenticates to Terraform Cloud.

1. In the top-right corner of Terraform Cloud, click your **avatar** → **"Account Settings"**.
2. In the left sidebar, click **"Tokens"**.
3. Click **"Create an API token"**.
4. Give it a description like `GitHub Actions` and click **"Create API token"**.
5. Copy the token immediately — it is only shown once.

> ⚠️ **This token is a password.  Keep it safe.**  Anyone with it can manage your Terraform state.

---

## Step 6 — Add Tokens to GitHub

This wires everything together so the CI pipeline can run `terraform plan` and `terraform apply`.

1. Go to your repository: `https://github.com/farflungfish/lan-preservation-society-discord`
2. Click **Settings** (the tab at the top of the repo page).

### Add Secrets (sensitive values)

3. In the left sidebar, click **Secrets and variables** → **Actions**.
4. Click **"New repository secret"** and add each of the following:

| Secret name     | Value                                         |
|-----------------|-----------------------------------------------|
| `DISCORD_TOKEN` | Your Discord bot token (from Step 2)          |
| `TF_API_TOKEN`  | Your Terraform Cloud API token (from Step 5d) |

### Add a Variable (non-sensitive value)

5. Still on the **Secrets and variables → Actions** page, click the **"Variables"** tab.
6. Click **"New repository variable"** and add:

| Variable name           | Value                                              |
|-------------------------|----------------------------------------------------|
| `TF_CLOUD_ORGANIZATION` | Your Terraform Cloud org name (from Step 5b)       |

Once all three are saved, every new PR will automatically run `terraform plan` and post the output as a comment.

---

## Step 7 — (Optional) Set Up a `production` Environment for Apply Protection

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
| `Error: 401 Unauthorized` | Wrong Discord token | Double-check the token in `terraform.tfvars` — reset it in the Developer Portal if unsure |
| Bot is not in the server | Skipped Step 3 | Follow Step 3 to invite the bot |
| `terraform: command not found` | Terraform not installed | Follow Step 4a |
| Duplicate channels appear | Existing channels not imported | Follow the "Importing Existing Resources" section above |
| `Error: No Terraform Cloud organization` | `TF_CLOUD_ORGANIZATION` not set | Set the env var locally (`export TF_CLOUD_ORGANIZATION="your-org-name"` on macOS/Linux, or `$env:TF_CLOUD_ORGANIZATION = "your-org-name"` on Windows), then re-run `terraform init`. For CI, add the variable in GitHub (Step 6) |
| `Error: Unauthorized` on `terraform init` | Wrong or missing TFC token | Re-run `terraform login` locally, or check `TF_API_TOKEN` secret in GitHub |
| PR plan shows "Skipped (secrets not configured)" | Secrets/variable missing in GitHub | Add `DISCORD_TOKEN`, `TF_API_TOKEN`, and `TF_CLOUD_ORGANIZATION` (Step 6) |

---

## Quick Reference — Useful Links

- Discord Developer Portal: <https://discord.com/developers/applications>
- Terraform Install: <https://developer.hashicorp.com/terraform/install>
- Terraform Cloud (HCP Terraform): <https://app.terraform.io>
- Lucky3028 Discord Provider docs: <https://registry.terraform.io/providers/Lucky3028/discord/latest/docs>
- Your repo: <https://github.com/farflungfish/lan-preservation-society-discord>
