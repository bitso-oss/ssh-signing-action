# Changelog

## [Unreleased]

### Added

- Initial implementation of the Configure SSH Commit Signing Action
- Composite action with `ssh-signing-key`, `ssh-key-path`, and `gpgsign` inputs
- Input validation (fails on empty key)
- Secure file permissions (700 for directory, 600 for key)
- Configures `gpg.format`, `user.signingkey`, `commit.gpgsign`, and `tag.gpgsign`
- CI test workflow covering happy path, missing key, custom path, signed commit, and gpgsign-disabled scenarios
- OS matrix testing on Ubuntu and macOS
