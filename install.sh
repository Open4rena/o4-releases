#!/usr/bin/env bash
set -euo pipefail

# o4 installer — downloads a published o4 binary package from GitHub.
#
# Usage:
#   curl -fsSL https://install.open4rena.ai/install.sh | bash
#
# Environment variables:
#   O4_INSTALL_DIR  — override install directory (default: ~/.local/bin)
#   O4_VERSION      — pin an exact package version instead of the latest release

# Releases are published to a separate public repo — not the source repo.
RELEASES_REPO="Open4rena/o4-releases"
INSTALL_DIR="${O4_INSTALL_DIR:-$HOME/.local/bin}"
VERSION="${O4_VERSION:-}"

# --- Helpers ---

info()  { printf "\033[1;34m%s\033[0m %s\n" ">" "$*"; }
ok()    { printf "\033[1;32m%s\033[0m %s\n" "✓" "$*"; }
err()   { printf "\033[1;31m%s\033[0m %s\n" "✗" "$*" >&2; }

need_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    err "required command not found: $1"
    exit 1
  fi
}

# --- Preflight ---

for cmd in curl tar; do
  need_cmd "$cmd"
done

# Detect checksum tool (shasum on macOS, sha256sum on Linux)
if command -v sha256sum >/dev/null 2>&1; then
  SHA_CMD="sha256sum"
elif command -v shasum >/dev/null 2>&1; then
  SHA_CMD="shasum -a 256"
else
  err "neither sha256sum nor shasum found"
  exit 1
fi

# --- Detect platform ---

detect_os() {
  local os
  os="$(uname -s)"
  case "$os" in
    Linux*)  echo "linux" ;;
    Darwin*) echo "macos" ;;
    *)       err "unsupported OS: $os"; exit 1 ;;
  esac
}

detect_arch() {
  local arch
  arch="$(uname -m)"
  case "$arch" in
    x86_64|amd64)  echo "x86_64" ;;
    aarch64|arm64) echo "arm64" ;;
    *)             err "unsupported architecture: $arch"; exit 1 ;;
  esac
}

OS="$(detect_os)"
ARCH="$(detect_arch)"
ARTIFACT="o4-${OS}-${ARCH}"

info "Platform: ${OS}/${ARCH}"

# --- Resolve version ---

if [ -n "$VERSION" ]; then
  VERSION="${VERSION#v}"
  info "Release: exact version pin"
else
  info "Release: latest stable"
  info "Resolving latest published release..."
  if ! RELEASES_JSON="$(curl -fsSL \
    "https://api.github.com/repos/${RELEASES_REPO}/releases/latest")"; then
    err "could not query the latest release"
    err "retry later or set O4_VERSION to an exact version"
    exit 1
  fi
  VERSION="$(printf '%s\n' "$RELEASES_JSON" | sed -n \
    's/.*"tag_name":[[:space:]]*"v\([^"]*\)".*/\1/p' | sed -n '1p')"

  if [ -z "$VERSION" ]; then
    err "no published release could be resolved"
    err "check: https://github.com/${RELEASES_REPO}/releases"
    exit 1
  fi
fi

info "Version: ${VERSION}"

# --- Download ---

TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT

TARBALL="${ARTIFACT}.tar.gz"
CHECKSUM="${ARTIFACT}.tar.gz.sha256"
BASE_URL="https://github.com/${RELEASES_REPO}/releases/download/v${VERSION}"

info "Downloading ${TARBALL}..."
if ! curl -fsSL -o "${TMPDIR}/${TARBALL}" "${BASE_URL}/${TARBALL}"; then
  err "download failed — does version ${VERSION} exist for ${OS}/${ARCH}?"
  err "check: https://github.com/${RELEASES_REPO}/releases"
  exit 1
fi

info "Downloading checksum..."
if ! curl -fsSL -o "${TMPDIR}/${CHECKSUM}" "${BASE_URL}/${CHECKSUM}"; then
  err "checksum download failed"
  exit 1
fi

# --- Verify checksum ---

info "Verifying checksum..."
EXPECTED="$(awk '{print $1}' "${TMPDIR}/${CHECKSUM}")"
ACTUAL="$($SHA_CMD "${TMPDIR}/${TARBALL}" | awk '{print $1}')"

if [ "$EXPECTED" != "$ACTUAL" ]; then
  err "checksum mismatch!"
  err "  expected: $EXPECTED"
  err "  got:      $ACTUAL"
  exit 1
fi
ok "Checksum verified"

# --- Extract and install ---

info "Extracting..."
tar -xzf "${TMPDIR}/${TARBALL}" -C "${TMPDIR}"

mkdir -p "$INSTALL_DIR"
install -m 755 "${TMPDIR}/${ARTIFACT}" "${INSTALL_DIR}/o4"
ok "Installed to ${INSTALL_DIR}/o4"

if ! INSTALLED_VERSION="$("${INSTALL_DIR}/o4" --version)"; then
  err "installed binary did not start successfully"
  exit 1
fi

# --- PATH check ---

case ":${PATH}:" in
  *":${INSTALL_DIR}:"*) ;;
  *)
    info "NOTE: ${INSTALL_DIR} is not in your PATH."
    echo ""
    echo "  Add it to your shell profile:"
    echo ""
    if [ -f "$HOME/.zshrc" ]; then
      echo "    echo 'export PATH=\"${INSTALL_DIR}:\$PATH\"' >> ~/.zshrc"
    elif [ -f "$HOME/.bashrc" ]; then
      echo "    echo 'export PATH=\"${INSTALL_DIR}:\$PATH\"' >> ~/.bashrc"
    else
      echo "    export PATH=\"${INSTALL_DIR}:\$PATH\""
    fi
    echo ""
    ;;
esac

# --- Next steps ---

echo ""
ok "${INSTALLED_VERSION} installed successfully!"
echo ""
echo "  Next steps:"
echo "    1. Set an API key:  export ANTHROPIC_API_KEY=sk-ant-..."
echo "    2. Start a session: o4"
echo ""
echo "  Other providers:  o4 --list-models"
echo "  Documentation:    https://github.com/Open4rena/o4-releases#readme"
echo ""
