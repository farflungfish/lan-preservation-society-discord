# LAN Preservation Society — Discord IaC

Infrastructure-as-code for the **LAN Preservation Society** Discord server (ID: `1486014276274753697`), managed with [Terraform](https://www.terraform.io/) and the [`Lucky3028/discord`](https://registry.terraform.io/providers/Lucky3028/discord) provider.

---

## Repository Layout

```
.github/
  agents/                     # GitHub Copilot agent definitions
    issue-consultant.md       # Turns plain-English requests into GitHub Issues
    terraform-developer.md    # Writes Terraform code and opens PRs
    code-reviewer.md          # Reviews PRs for correctness
    repo-manager.md           # Housekeeping: labels, milestones, stale issues
  workflows/
    pr-validation.yml         # Runs on every PR: fmt → validate → tflint → plan
    terraform-apply.yml       # Runs on merge to main: terraform apply
  CODEOWNERS                  # Required reviewers
  PULL_REQUEST_TEMPLATE.md    # Standardised PR template
  copilot-instructions.md     # Context for GitHub Copilot
terraform/
  versions.tf                 # Provider & Terraform version pins
  variables.tf                # Input variables (token, server ID)
  main.tf                     # Roles, categories, channels
  outputs.tf                  # Outputs (IDs for roles, channels, etc.)
  terraform.tfvars.example    # Template — copy to terraform.tfvars locally
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

## 🚀 First-Time Setup

**New here?  Start with the [Setup Guide (SETUP.md)](SETUP.md).**  It walks you step-by-step through creating the Discord bot, giving it permissions, and wiring the token into Terraform and GitHub — no prior experience needed.

---

## Contributing (Without Knowing Terraform)

Use the GitHub Copilot agents to contribute without writing any Terraform:

1. **Describe your change** — Open a Copilot chat and say `@issue-consultant I'd like to add a #resources channel under PRESERVATION`.  The agent will create a GitHub Issue for you.
2. **Implement the change** — Use `@terraform-developer` and reference the issue number.  It will write the Terraform code and open a PR.
3. **Review the PR** — Use `@code-reviewer` to get an automated review of the PR.

---

## Prerequisites (Local Development)

| Tool        | Version  | Notes                                      |
|-------------|----------|--------------------------------------------|
| Terraform   | >= 1.9   | <https://developer.hashicorp.com/terraform/install> |
| TFLint      | latest   | `brew install tflint` or see [releases](https://github.com/terraform-linters/tflint/releases) |

### Local Setup

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars — add your Discord bot token
terraform init
terraform plan
```

---

## Secrets

| Secret Name     | Where to set                         | Description                  |
|-----------------|--------------------------------------|------------------------------|
| `DISCORD_TOKEN` | GitHub → Settings → Secrets → Actions | Discord bot token            |
| `TF_API_TOKEN`  | GitHub → Settings → Secrets → Actions | Terraform Cloud token (optional) |

---

## PR Pipeline

Every pull request targeting `main` automatically runs:

1. `terraform fmt -check` — format check
2. `terraform validate` — syntax and schema validation
3. `tflint` — best-practice linting
4. `terraform plan` — plan output posted as a PR comment

After merge to `main`, the **Terraform Apply** workflow applies the changes (requires a `production` environment approval if configured).
