# Configure SSH Commit Signing Action

[![Test Action](https://github.com/bitso-oss/configure-ssh-signing-action/actions/workflows/test.yml/badge.svg)](https://github.com/bitso-oss/configure-ssh-signing-action/actions/workflows/test.yml)

A GitHub Action that configures Git to sign commits and tags using an SSH key. Simple composite action — no Docker, no Node.js.

## Inputs

| Input | Required | Default | Description |
|---|---|---|---|
| `ssh-signing-key` | Yes | — | Private SSH key content used for signing |
| `ssh-key-path` | No | `~/.ssh/signing_key` | Path to write the SSH signing key |
| `gpgsign` | No | `true` | Enable `commit.gpgsign` and `tag.gpgsign` |

## Usage

### Minimal

```yaml
- uses: bitso-oss/configure-ssh-signing-action@v1
  with:
    ssh-signing-key: ${{ secrets.SSH_SIGNING_KEY }}
```

### Full example

```yaml
jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: bitso-oss/configure-ssh-signing-action@v1
        with:
          ssh-signing-key: ${{ secrets.SSH_SIGNING_KEY }}

      - name: Configure git identity
        run: |
          git config --global user.name "releasebot"
          git config --global user.email "releasebot@example.com"

      - name: Create signed commit
        run: |
          echo "release" >> RELEASE
          git add RELEASE
          git commit -m "chore: release"
```

### Custom key path, signing disabled

```yaml
- uses: bitso-oss/configure-ssh-signing-action@v1
  with:
    ssh-signing-key: ${{ secrets.SSH_SIGNING_KEY }}
    ssh-key-path: ~/.ssh/my_key
    gpgsign: "false"
```

## What it does

1. Validates that the signing key is not empty
2. Writes the key to disk with secure permissions (`600`)
3. Configures `gpg.format = ssh` and `user.signingkey`
4. Optionally enables `commit.gpgsign` and `tag.gpgsign`

## Security

- Store your SSH signing key as a **repository secret** or **organization secret** — never hard-code it.
- The key is written to the runner filesystem, which is ephemeral. GitHub-hosted runners are destroyed after each job.
- The key file is created with `600` permissions (owner read/write only).

## License

[MIT](LICENSE)
