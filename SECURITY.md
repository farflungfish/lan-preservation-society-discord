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
