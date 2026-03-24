# Contributors

Thank you for your interest in the LAN Preservation Society Discord server!

This file lists contributors and explains how to get involved — no Terraform experience required.

---

## How to Contribute

### Option A — Using GitHub Copilot (Recommended)

This repository has GitHub Copilot agents that guide you from idea to merged PR without writing a single line of Terraform.

1. **Open a Copilot chat** in your editor or on GitHub.com.

2. **Describe what you want to change** using the `@issue-consultant` agent:
   ```
   @issue-consultant I'd like to add a voice channel for movie nights under the GENERAL category.
   ```
   The agent will ask clarifying questions and create a structured GitHub Issue.

3. **Implement the change** using the `@terraform-developer` agent:
   ```
   @terraform-developer Please implement issue #12.
   ```
   The agent will write the Terraform code and open a draft PR.

4. **Review the PR** using the `@code-reviewer` agent:
   ```
   @code-reviewer Review PR #13 for correctness and best practices.
   ```

5. **Wait for CI to pass** and a maintainer to approve, then the change is merged and applied automatically.

### Option B — Manual Contribution

If you are comfortable with Terraform:

1. Fork the repository and create a feature branch from `main`.
2. Copy `terraform/terraform.tfvars.example` → `terraform/terraform.tfvars` and fill in your credentials.
3. Make changes in `terraform/`.
4. Run `terraform fmt -recursive` and `terraform validate` locally.
5. Open a Pull Request.  The CI pipeline will run `fmt`, `validate`, `tflint`, and post a `plan` as a PR comment.
6. Address review feedback until the PR is approved and CI is green.

---

## Contribution Guidelines

- **One change per PR** — keep changes small and focused to make reviews easy.
- **Descriptive commit messages** — explain *what* changed and *why*.
- **No secrets in code** — never commit `terraform.tfvars` or any token; it is gitignored.
- **Follow naming conventions** — channel names use `kebab-case`, role names use `Title Case`, resource identifiers use `snake_case`.
- **Update outputs** — if you add a new resource, export its ID in `terraform/outputs.tf`.

---

## Contributors

| Name | GitHub | Role |
|------|--------|------|
| farflungfish | [@farflungfish](https://github.com/farflungfish) | Maintainer |

_Want your name here? Open a PR!_
