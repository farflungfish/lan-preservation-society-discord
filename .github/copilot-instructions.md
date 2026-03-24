# Copilot Instructions — LAN Preservation Society Discord IaC

## Repository Purpose

This repository manages the **LAN Preservation Society Discord server** using Terraform infrastructure-as-code with the [`Lucky3028/discord`](https://registry.terraform.io/providers/Lucky3028/discord) provider.

All Discord server structure changes (channels, roles, categories, permissions) are made by editing the Terraform files in `terraform/` and opening a Pull Request.  **Never apply changes directly** — always go through the PR pipeline. This repository uses HCP Terraform with VCS OAuth integration, so plan and apply runs are triggered automatically by HCP Terraform when PRs are opened or merged.

---

## Repository Layout

```text
.github/
  agents/                     # Copilot agent definitions (see below)
  workflows/
    pr-validation.yml         # Runs on every PR: fmt → validate → tflint
  CODEOWNERS                  # @farflungfish must review all changes
  PULL_REQUEST_TEMPLATE.md    # Standard PR checklist
  copilot-instructions.md     # This file
terraform/
  versions.tf                 # Provider & Terraform version pins
  variables.tf                # Input variables (discord_token, server_id)
  main.tf                     # Core resources: roles, categories, channels
  outputs.tf                  # Exported IDs (channels, roles)
  terraform.tfvars.example    # Variable template — copy to terraform.tfvars locally
CONTRIBUTORS.md               # Contributor guide
README.md                     # Project overview
```

---

## Terraform Conventions

- **Formatting**: Always run `terraform fmt -recursive` before committing.
- **Naming**:
  - Terraform resource identifiers: `snake_case` (e.g., `discord_text_channel.general_chat`)
  - Discord channel names: `kebab-case` (e.g., `#general-chat`)
  - Discord role names: `Title Case` (e.g., `Moderator`)
  - Discord category names: `UPPER CASE` (e.g., `PRESERVATION`)
- **Variables**: All sensitive values come from `var.*` — never hardcode tokens or IDs.
- **Outputs**: Every new resource should export its ID in `outputs.tf`.
- **State**: State is stored remotely in Terraform Cloud.

---

## Discord Server Conventions

- **Categories** group related channels; their names appear in UPPER CASE in Discord.
- **Text channels** use lowercase `kebab-case` (`#general-chat`, `#lan-events`).
- **Voice channels** use Title Case with a 🔊 prefix in Discord UI.
- **Roles** use Title Case: `Admin`, `Moderator`, `Bot`, `Member`.
- Every text channel should have a `topic` attribute describing its purpose.

---

## Pull Request Process

1. Branch from `main`.
2. Make Terraform changes in `terraform/`.
3. Run `terraform fmt -recursive` locally.
4. Open a PR — CI runs `fmt`, `validate`, and `tflint`. HCP Terraform automatically runs a speculative plan via VCS OAuth and posts it as a GitHub check.
5. A code owner (see `CODEOWNERS`) must approve before merge.
6. After merge, HCP Terraform automatically applies the changes via its VCS OAuth integration.

---

## Copilot Agents

Agents are defined in `.github/agents/` and can be invoked in Copilot chat:

| Agent | Invocation | Role |
|-------|-----------|------|
| `issue-consultant` | `@issue-consultant` | Turns plain-English requests into structured GitHub Issues |
| `terraform-developer` | `@terraform-developer` | Given an issue, writes Terraform code and opens a PR |
| `code-reviewer` | `@code-reviewer` | Reviews a PR for correctness, naming, and security |
| `repo-manager` | `@repo-manager` | Housekeeping: labels, milestones, stale issues, PR nudges |

---

## Secrets Required

This repository uses HCP Terraform's VCS OAuth integration. Plan and apply runs are triggered automatically — no Terraform credentials are needed in GitHub Actions secrets.

| Secret | Description |
|--------|-------------|
| `DISCORD_TOKEN` | Discord bot token (mark as sensitive — never log or print) |
