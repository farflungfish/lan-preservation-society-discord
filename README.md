# LAN Preservation Society — Discord IaC

Infrastructure-as-code for the **LAN Preservation Society** Discord server (ID: `1486014276274753697`), managed with [Terraform](https://www.terraform.io/) and the [`Lucky3028/discord`](https://registry.terraform.io/providers/Lucky3028/discord) provider.

All server structure changes — channels, roles, categories, permissions — are made by editing Terraform files and opening a Pull Request. **Never apply changes directly**; always go through the PR pipeline so that `terraform plan` output is visible and reviewed before anything is applied.

---

## Repository Layout

```text
.github/
  agents/                     # GitHub Copilot agent definitions
    issue-consultant.md       # Turns plain-English requests into GitHub Issues
    terraform-developer.md    # Writes Terraform code and opens PRs
    code-reviewer.md          # Reviews PRs for correctness
    repo-manager.md           # Housekeeping: labels, milestones, stale issues
  workflows/
    pr-validation.yml         # Runs on every PR: fmt → validate → tflint
  CODEOWNERS                  # Required reviewers for every PR
  PULL_REQUEST_TEMPLATE.md    # Standard PR checklist
  copilot-instructions.md     # Workspace instructions for GitHub Copilot
terraform/
  versions.tf                 # Provider & Terraform version pins
  variables.tf                # Input variables (server ID)
  main.tf                     # Roles, categories, channels
  outputs.tf                  # Exported resource IDs
  terraform.tfvars.example    # Template — copy to terraform.tfvars locally
CONTRIBUTORS.md               # How to contribute and contributor list
```

---

## Discord Server Structure

| Category        | Channels                                            |
|-----------------|-----------------------------------------------------|
| INFORMATION     | #welcome, #rules, #announcements                    |
| GENERAL         | #general-chat, #introductions, #off-topic           |
| GAMING          | #gaming-general, #game-nights, #lan-events, 🔊 Gaming Lounge |
| PRESERVATION    | #preservation-talk, #hardware-help, #software-help, 🔊 Preservation Lab |

**Roles**: Admin · Moderator · Bot · Member

---

## Contributing

You do **not** need to know Terraform to contribute.  This repository uses **GitHub Copilot** agents to guide contributors from idea to merged PR.

### Using GitHub Copilot to Contribute

1. **Describe your change** — Open a Copilot chat and say:

   ```text
   @issue-consultant I'd like to add a #resources channel under PRESERVATION.
   ```

   The agent will ask a few clarifying questions and then create a GitHub Issue.

2. **Implement the change** — Reference the issue number with the developer agent:

   ```text
   @terraform-developer Implement issue #42.
   ```

   The agent writes the Terraform code and opens a PR for you.

3. **Review the PR** — Request an automated review:

   ```text
   @code-reviewer Please review PR #43.
   ```

GitHub Copilot uses the instructions in `.github/copilot-instructions.md` to understand this repository's conventions, so its suggestions will already follow the project's standards.

See [CONTRIBUTORS.md](CONTRIBUTORS.md) for the full contribution guide.

---

## Create GitHub Issues from Discord

The Discord bot can hand off requests directly into this repository by triggering a `repository_dispatch` event. A GitHub Actions workflow (`Discord Issue Bridge`) will convert the payload into a new issue.

1. **Create a GitHub token for the bot** — A fine-grained PAT with repository access to this repo is sufficient (Repository permissions: Contents **Read & Write**, Metadata **Read**). Store it safely on the bot side; it is **not** needed in this repository.
2. **POST a dispatch event from Discord** whenever a request is captured:

   ```bash
   curl -X POST \
     -H "Authorization: Bearer $GITHUB_PAT" \
     -H "Accept: application/vnd.github+json" \
     https://api.github.com/repos/farflungfish/lan-preservation-society-discord/dispatches \
     -d '{
       "event_type": "discord_issue",
       "client_payload": {
         "title": "Request: new #bug-reports channel",
         "body": "From @SomeUser in #suggestions:\n\nAdd a dedicated place to report issues.",
         "labels": ["from-discord", "community-request"],
         "discord_user": "SomeUser#1234",
         "discord_channel": "#suggestions",
         "discord_message_url": "https://discord.com/channels/.../..."
       }
     }'
   ```

   Only `title` is required. `labels` defaults to `from-discord` if omitted; `discord_user`, `discord_channel`, and `discord_message_url` are optional metadata that will be included at the top of the issue body.
3. **Test manually (optional)** — Trigger the workflow with `workflow_dispatch` inputs in the Actions tab to verify the bot payload format before wiring it up.

---

## PR Pipeline

Every pull request targeting `main` automatically runs:

| Check | What it does |
|-------|-------------|
| `terraform fmt -check` | Enforces canonical Terraform formatting |
| `terraform validate` | Validates syntax and schema |
| `tflint` | Best-practice linting |

**All checks must pass and at least one reviewer must approve before a PR can be merged.**

This repository uses **HCP Terraform with VCS OAuth integration**. When a PR is opened, HCP Terraform automatically runs a speculative plan and posts the result as a GitHub check. When a PR is merged to `main`, HCP Terraform automatically runs the full plan and apply — no separate apply workflow is needed.

---

## Branch Protection

The `main` branch is protected:

- Direct pushes are blocked — all changes must come via a Pull Request.
- The PR pipeline (above) must pass before merging.
- At least one approving review from a code owner is required.

---

## Secrets & Variables

This repository uses HCP Terraform's VCS OAuth integration. Plan and apply runs are triggered automatically by HCP Terraform when PRs are opened or merged — no Terraform credentials are needed in GitHub Actions secrets.

| Type | Name | Location | Description |
|------|------|----------|-------------|
| Environment variable | `DISCORD_TOKEN` | HCP Terraform → Workspace → Variables → Environment Variables | Discord bot token (sensitive). The provider reads this automatically — do **not** set it as a Terraform variable. |
