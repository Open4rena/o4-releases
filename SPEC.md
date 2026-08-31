# Installer Release Specification

## Purpose

The public installer must select a published binary package, not infer a
version from the private source repository. A source version is installable
only after both supported archives and their checksums are present in a
published release.

## Release contract

- Public package tags have the form `v<BINARY_VERSION>`.
- The default installer resolves GitHub's latest stable release.
- `O4_VERSION=<PACKAGE_VERSION>` bypasses latest-release resolution and pins
  an exact package. A leading `v` is accepted and normalized.
- Draft and prerelease packages are never selected by the default installer.
- A stable release is published only after all required assets have uploaded
  and their checksums have been verified.

## Required assets

Every published package must contain:

- `o4-macos-arm64.tar.gz`
- `o4-macos-arm64.tar.gz.sha256`
- `o4-linux-x86_64.tar.gz`
- `o4-linux-x86_64.tar.gz.sha256`

The archive contains one executable whose name matches the archive stem.

## Promotion order

1. Select an exact clean source commit and record its binary version.
2. Build and smoke the two packaged binaries from that commit.
3. Create a draft release and upload all four required assets.
4. Verify asset names, sizes, and SHA-256 digests.
5. Publish the release as a normal stable release.
6. Let the release-triggered installer smoke verify both an explicit pin and
   the default latest-stable path on macOS and Linux.
7. Confirm the public installer reports the expected binary version from an
   anonymous clean install.

## Failure behavior

The installer fails closed when it cannot resolve a release, download either
the archive or checksum, verify the digest, extract the expected executable,
or start the installed binary. It never falls back silently to an older
package after selecting a release.
