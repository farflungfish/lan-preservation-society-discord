# Copilot Instructions — LAN Preservation Society Discord IaC

## Repository Purpose

This repository manages the **LAN Preservation Society Discord server** (ID: `1486014276274753697`) using Terraform infrastructure-as-code.  The Discord provider used is [`Lucky3028/discord`](https://registry.terraform.io/providers/Lucky3028/discord).

All Discord server structure changes (channels, roles, categories, permissions) are made by editing the Terraform files in `terraform/` and opening a Pull Request. **Never apply changes directly** — always go through the PR pipeline so that `terraform plan` output is visible before `terraform apply`.

## Repository Layout

```
.github/
  agents/              # Copilot agent definitions
  workflows/           # GitHub Actions pipelines
  CODEOWNERS           # Required reviewers
  PULL_REQUEST_TEMPLATE.md
  copilot-instructions.md   # This file
terraform/
  versions.tf          # Provider & Terraform version pins
  variables.tf         # Input variables
  main.tf              # Core Discord resources
  outputs.tf           # Outputs (channel/role IDs, etc.)
  terraform.tfvars.example  # Example variable values
```

## Terraform Conventions

- **Formatting**: Always run `terraform fmt -recursive` before committing.
- **Naming**: Resource names use `snake_case` and match the Discord channel/role name as closely as possible (spaces → underscores, lowercase).
- **Variables**: Sensitive values (bot token, server ID) come from `var.*` — never hardcode them.
- **State**: State is stored remotely (configure `backend` block if using Terraform Cloud / S3).
- **Modules**: Keep everything flat in `terraform/` until complexity warrants extracting a module.

## Discord Server Conventions

- **Categories** group related channels.  Category names are UPPER CASE in Discord.
- **Channels** use lowercase kebab-case (`#general-chat`, `#lan-events`).
- **Roles** use Title Case.
- Add a descriptive `topic` to every text channel so members know its purpose.

## Pull Request Process

1. Create a branch from `main`.
2. Make Terraform changes.
3. Open a PR — the CI pipeline runs `terraform fmt`, `terraform validate`, and posts a plan.
4. At least one reviewer (see `CODEOWNERS`) must approve before merge.
5. After merge, `terraform apply` is run manually (or via a separate apply workflow with environment protection).

## Secrets Required

| Secret Name         | Description                        |
|---------------------|------------------------------------|
| `DISCORD_TOKEN`     | Discord bot token (keep private!)  |

## How to Contribute Without Knowing Terraform

Use the Copilot agents defined in `.github/agents/`:

- **`issue-consultant`** — Describe what you want to change on the server; the agent turns it into a well-formed GitHub Issue.
- **`terraform-developer`** — Given an issue, writes the Terraform code and opens a PR.
- **`code-reviewer`** — Reviews an open PR for correctness and best practices.
- **`repo-manager`** — Helps with housekeeping tasks (labels, milestones, stale issues, etc.).
