# Third-Party Notices

o4 includes software derived from third-party open-source projects, and its
binaries link many open-source Rust crates. This file records the attribution
those licenses require. It must ship alongside every binary distribution of
o4 (it is published in the releases repository).

## Adapted source code

The following o4 modules contain code adapted from **OpenAI Codex**
(<https://github.com/openai/codex>), used under the **Apache License 2.0**.
Upstream files are pinned at the revision they were ported from:

| o4 module | Upstream file (revision) |
| --- | --- |
| `o4-coding-agent` frame rate limiter | `codex-rs/tui/src/tui/frame_rate_limiter.rs` (`ee0247f9`) |
| `o4-coding-agent` frame requester | `codex-rs/tui/src/tui/frame_requester.rs` (`ee0247f9`) |
| `o4-coding-agent` scroll event helper | `codex-rs/tui/src/scroll_event_helper.rs` (`b90cf2a`) |
| `o4-tui` terminal palette cache | `codex-rs/tui/src/terminal_palette.rs` (`ee0247f9`) |
| `o4-tui` terminal startup probe | `codex-rs/tui/src/terminal_probe.rs` (`ee0247f9`) |

Copyright (c) OpenAI. Licensed under the Apache License, Version 2.0; you may
obtain a copy of the license at <https://www.apache.org/licenses/LICENSE-2.0>.
The adapted code is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
CONDITIONS OF ANY KIND, either express or implied.

## Bundled crates

The o4 binaries statically link Rust crates published on crates.io under
their respective licenses (predominantly MIT and Apache-2.0). A complete,
per-release manifest of crate names, versions, and licenses can be produced
from the source lockfile with `cargo license` and is available on request
via the issue tracker of the releases repository.
