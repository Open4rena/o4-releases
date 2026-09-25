# Security Policy

## Supported versions

Only the latest release of o4 is supported. Update with the install command before reporting an issue:

```sh
curl -fsSL https://open4rena.ai/install.sh | bash
```

If you installed with Homebrew, update with `brew upgrade o4`.

## Reporting a vulnerability

Report vulnerabilities privately through [GitHub security advisories](https://github.com/Open4rena/o4-releases/security/advisories/new). Do not open a public issue for security reports.

Include the o4 version (`o4 --version`), your OS and architecture, and steps to reproduce. We aim to acknowledge reports within 72 hours.

## Scope

o4 runs locally and connects only to the model providers you configure. Reports about provider APIs themselves are out of scope; anything about the o4 binary, the installer, or this distribution channel is in scope.
