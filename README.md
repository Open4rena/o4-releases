# o4

o4 is an agentic coding assistant for your terminal — a fast TUI that pairs
frontier and local models with a full tool harness: file editing, shell,
search, test runners, LSP, MCP servers, plugins, skills, multi-agent
campaigns, and session continuity.

This repository hosts **binary releases** of o4. The source code is not
public.

## Test candidate

The default installer channel tracks the newest published `*-test.*` package.
It is available for cross-machine testing, but it is not the final production
release. A source version does not enter the channel until both supported
archives and checksums are published. A release-triggered installer smoke then
verifies the exact package and default channel on macOS and Linux immediately.

```sh
curl -fsSL https://install.open4rena.ai/install.sh | bash
```

Or download a release directly from the
[releases page](https://github.com/Open4rena/o4-releases/releases) and put the
binary on your `PATH`.

Options:

```sh
curl -fsSL https://install.open4rena.ai/install.sh |
  O4_INSTALL_DIR=~/bin bash

curl -fsSL https://install.open4rena.ai/install.sh |
  O4_VERSION=0.0.81-test.1 bash

curl -fsSL https://install.open4rena.ai/install.sh |
  O4_CHANNEL=stable bash
```

Every artifact ships with a SHA-256 checksum that the installer verifies
before installing.

The channel and publication contract is documented in [SPEC.md](SPEC.md).

The production command will return to `https://open4rena.ai/install.sh` after
the remaining launch gates pass.

## Supported platforms

| Platform | Artifact |
| --- | --- |
| macOS (Apple Silicon) | `o4-macos-arm64.tar.gz` |
| Linux (x86_64) | `o4-linux-x86_64.tar.gz` |

## Getting started

```sh
o4              # start the interactive TUI in the current project
o4 --help       # CLI reference
o4 --list-models
```

On first run, o4 walks you through connecting a model provider — bring your
own API key, use a Claude Code or Codex subscription, or run fully local
models through Ollama.

## License

The o4 binary is proprietary software, distributed under the terms in
[LICENSE](LICENSE). Issues and feedback are welcome on this repository's
issue tracker.
