# LAN Preservation Society — Discord IaC

Infrastructure-as-code for the **LAN Preservation Society** Discord server, managed with [Terraform](https://www.terraform.io/) and the [`Lucky3028/discord`](https://registry.terraform.io/providers/Lucky3028/discord) provider.

All server structure changes — channels, roles, categories, permissions — are made by editing Terraform files and opening a Pull Request. **Never apply changes directly**; always go through the PR pipeline so that `terraform plan` output is visible and reviewed before anything is applied.

---

## Repository Layout

```
.github/
  agents/                     # GitHub Copilot agent definitions
  workflows/                  # GitHub Actions CI/CD pipelines
  CODEOWNERS                  # Required reviewers for every PR
  PULL_REQUEST_TEMPLATE.md    # Standard PR checklist
  copilot-instructions.md     # Workspace instructions for GitHub Copilot
terraform/
  versions.tf                 # Provider & Terraform version pins
  variables.tf                # Input variables (token, server ID)
  main.tf                     # Roles, categories, channels
  outputs.tf                  # Exported resource IDs
  terraform.tfvars.example    # Template — copy to terraform.tfvars locally
CONTRIBUTORS.md               # How to contribute and contributor list
SETUP.md                      # Step-by-step first-time setup guide
```

---

## Contributing

You do **not** need to know Terraform to contribute.  This repository uses **GitHub Copilot** agents to guide contributors from idea to merged PR.

### Using GitHub Copilot to Contribute

1. **Describe your change** — Open a Copilot chat and say:
   ```
   @issue-consultant I'd like to add a #resources channel under PRESERVATION.
   ```
   The agent will ask a few clarifying questions and then create a GitHub Issue.

2. **Implement the change** — Reference the issue number with the developer agent:
   ```
   @terraform-developer Implement issue #42.
   ```
   The agent writes the Terraform code and opens a PR for you.

3. **Review the PR** — Request an automated review:
   ```
   @code-reviewer Please review PR #43.
   ```

GitHub Copilot uses the instructions in `.github/copilot-instructions.md` to understand this repository's conventions, so its suggestions will already follow the project's standards.

See [CONTRIBUTORS.md](CONTRIBUTORS.md) for the full contribution guide and [SETUP.md](SETUP.md) for environment setup instructions.

---

## PR Pipeline

Every pull request targeting `main` automatically runs:

| Check | What it does |
|-------|-------------|
| `terraform fmt -check` | Enforces canonical Terraform formatting |
| `terraform validate` | Validates syntax and schema |
| `tflint` | Best-practice linting |
| `terraform plan` | Posts plan output as a PR comment |

**All checks must pass and at least one reviewer must approve before a PR can be merged.**

---

## Branch Protection

The `main` branch is protected:

- Direct pushes are blocked — all changes must come via a Pull Request.
- The PR pipeline (above) must pass before merging.
- At least one approving review from a code owner is required.

See [SETUP.md](SETUP.md) for instructions on configuring these rules in a fork.

---

## Secrets & Variables

| Type | Name | Location | Description |
|------|------|----------|-------------|
| Secret | `DISCORD_TOKEN` | GitHub → Settings → Secrets → Actions | Discord bot token |
| Secret | `TF_API_TOKEN` | GitHub → Settings → Secrets → Actions | Terraform Cloud token |
| Variable | `TF_CLOUD_ORGANIZATION` | GitHub → Settings → Variables → Actions | Terraform Cloud org name |
