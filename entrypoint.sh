#!/usr/bin/env bash
set -euo pipefail

# --- Validate inputs ---

if [ -z "${SSH_SIGNING_KEY:-}" ]; then
  echo "::error::ssh-signing-key input is required and must not be empty"
  exit 1
fi

# --- Resolve key path ---

KEY_PATH="${SSH_KEY_PATH:-$HOME/.ssh/signing_key}"
# Expand tilde manually since it doesn't expand inside quotes
KEY_PATH="${KEY_PATH/#\~/$HOME}"

KEY_DIR="$(dirname "$KEY_PATH")"

# --- Write the key ---

if [ ! -d "$KEY_DIR" ]; then
  mkdir -p "$KEY_DIR"
  chmod 700 "$KEY_DIR"
fi

printf '%s\n' "$SSH_SIGNING_KEY" > "$KEY_PATH"
chmod 600 "$KEY_PATH"

echo "SSH signing key written to $KEY_PATH"

# --- Configure git ---

git config --global gpg.format ssh
git config --global user.signingkey "$KEY_PATH"

if [ "${GPGSIGN:-true}" = "true" ]; then
  git config --global commit.gpgsign true
  git config --global tag.gpgsign true
  echo "Commit and tag signing enabled"
else
  echo "Automatic signing not enabled (gpgsign=false)"
fi

# --- Register cleanup ---

# Composite actions don't support post: steps natively, so we use
# the GITHUB_STATE mechanism to schedule cleanup via a separate step
# or rely on the ephemeral runner teardown.
if [ -n "${GITHUB_STATE:-}" ]; then
  echo "key_path=$KEY_PATH" >> "$GITHUB_STATE"
fi

echo "SSH commit signing configured successfully"
