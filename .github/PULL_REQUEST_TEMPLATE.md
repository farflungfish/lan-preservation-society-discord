## Description

<!-- What does this PR do? Link the related issue if applicable (e.g. Closes #123) -->

## Type of Change

- [ ] New Discord resource (channel, role, category, etc.)
- [ ] Modification to existing Discord resource
- [ ] Pipeline / workflow change
- [ ] Documentation update
- [ ] Other (describe below)

## Terraform Plan Output

<!-- Paste the relevant section of `terraform plan` output, or note if no infra changes -->

<details>
<summary>Show plan</summary>

```
(paste here)
```

</details>

## Checklist

- [ ] `terraform fmt -recursive` has been run and code is properly formatted
- [ ] `terraform validate` passes locally (or CI is green)
- [ ] The Terraform plan in the CI comment looks correct
- [ ] Sensitive values (tokens, IDs) are referenced via variables / secrets and not hardcoded
- [ ] `CONTRIBUTORS.md` is updated if this is a first contribution

## Related Issues

Closes #<!-- issue number -->
