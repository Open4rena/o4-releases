# o4

o4 is an agentic coding assistant for your terminal — a fast TUI that pairs
frontier and local models with a full tool harness: file editing, shell,
search, test runners, LSP, MCP servers, plugins, skills, multi-agent
campaigns, and session continuity.

This repository hosts **binary releases** of o4. The source code is not
public.

## Install

```sh
curl -fsSL https://install.open4rena.ai/o4 | bash
```

Or download a release directly from the
[releases page](https://github.com/Open4rena/o4-releases/releases) and put the
binary on your `PATH`.

Options:

```sh
O4_INSTALL_DIR=~/bin  # override install directory (default: ~/.local/bin)
O4_VERSION=0.32.97    # pin a specific version instead of latest
```

Every artifact ships with a SHA-256 checksum that the installer verifies
before installing.

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
