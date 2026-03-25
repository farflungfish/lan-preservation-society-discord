# Security Policy

## Scope

This repository manages the **LAN Preservation Society Discord server** using
Terraform. The attack surface is limited to:

- Terraform configuration files that define Discord server structure (channels,
  roles, permissions).
- GitHub Actions workflows that automate issue creation and CI validation.

Sensitive values (Discord bot token, HCP Terraform credentials) are **never**
stored in this repository — they are held as encrypted secrets in HCP Terraform
and GitHub Actions.

## Reporting a Vulnerability

If you discover a security issue in this repository (for example, a workflow
that leaks secrets, an overly permissive role definition, or an injection
vector in a workflow script), please **do not open a public GitHub issue**.

Instead, use GitHub's private vulnerability reporting:

1. Go to the **Security** tab of this repository.
2. Click **Report a vulnerability**.
3. Fill in the details and submit.

A maintainer will respond within **7 days** and work with you to address the
issue before any public disclosure.

## What is Out of Scope

- General Discord server feature requests or channel suggestions — please open
  a regular GitHub issue or raise a request in the Discord server.
- Vulnerabilities in third-party services (Discord itself, HCP Terraform,
  GitHub).

## Security Best Practices for Contributors

- **Never** commit `terraform.tfvars` or any file containing real tokens or
  IDs (the `.gitignore` already excludes `*.tfvars`).
- Reference all sensitive values via `var.*` and Terraform/GitHub secrets.
- Keep workflow permissions as narrow as possible (prefer `contents: read` and
  only elevate where strictly necessary).

---

## Security Audit — Public Launch Review

The following findings were documented as part of the pre-public-launch security audit (March 2026).

### 1. Discord Bot Token

**Finding:** No Discord bot token is present anywhere in the codebase.

**Status:** ✅ Safe — The token is stored as a sensitive environment variable in HCP Terraform (`DISCORD_TOKEN`) and is never logged or printed. The `.gitignore` excludes `*.tfvars` to prevent accidental commits of local credential files.

---

### 2. Discord Server ID

**Finding:** The Discord server ID (`1486014276274753697`) is visible in `terraform/variables.tf` (as a default value) and in `README.md`.

**Status:** ⚠️ Low risk — Discord server IDs are not secret credentials. They are publicly discoverable by any user who interacts with the server or uses Discord's developer tools. The ID alone grants no elevated access. However, pairing it with a leaked bot token would allow unauthorised API access, so keeping the token out of the repository is the critical control.

**Mitigation:** The server ID default is retained in `variables.tf` for convenience. Production deployments override it via a Terraform variable, and the bot token is never stored in the repository.

---

### 3. GitHub Actions Secrets

**Finding:** Workflows use only `GITHUB_TOKEN`, which is the automatic, scoped token provided by GitHub Actions. No long-lived personal access tokens or third-party secrets are stored in the repository.

**Status:** ✅ Safe — `GITHUB_TOKEN` permissions are explicitly scoped per job (e.g. `issues: write`). No secrets are printed to logs.

---

### 4. Terraform State

**Finding:** Terraform state is stored remotely in HCP Terraform (not in this repository). Local state files (`*.tfstate`) and variable files (`*.tfvars`) are excluded by `.gitignore`.

**Status:** ✅ Safe

---

### 5. Hardcoded Credentials Scan

**Finding:** A scan of the full repository history found no hardcoded passwords, API keys, webhook URLs, or other credentials.

**Status:** ✅ Safe

---

### Summary

| Item | Risk Level | Status |
| ---- | ---------- | ------ |
| Discord bot token | Critical | ✅ Not in repo — stored in HCP Terraform |
| Discord server ID | Low | ⚠️ Present in repo — acceptable, no secret value |
| GitHub Actions secrets | Low | ✅ Only `GITHUB_TOKEN` used, scoped per job |
| Terraform state | Medium | ✅ Remote state only, local files gitignored |
| Hardcoded credentials | Critical | ✅ None found |

The repository is considered safe for public visibility provided the Discord bot token remains outside the repository.
