config {
  format = "compact"

  # Disable the call_module_type check since we use a flat structure
  call_module_type = "none"
}

# Only built-in rules — the Lucky3028/discord provider does not have a
# tflint ruleset, so we intentionally do not load one.
