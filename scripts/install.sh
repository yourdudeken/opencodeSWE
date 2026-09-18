#!/usr/bin/env bash
set -euo pipefail

readonly repository="${OPENCODE_SWE_REPOSITORY:-yourdudeken/opencodeSWE}"
readonly release_url="https://github.com/${repository}/releases/latest/download/opencode-swe.tar.gz"
readonly target="${OPENCODE_SWE_TARGET:-$PWD}"

if [[ ! -d "$target" ]]; then
  printf 'Target directory does not exist: %s\n' "$target" >&2
  exit 1
fi

if ! command -v curl >/dev/null 2>&1; then
  printf 'curl is required to install OpenCode SWE.\n' >&2
  exit 1
fi

temporary_directory="$(mktemp -d)"
cleanup() {
  rm -rf "$temporary_directory"
}
trap cleanup EXIT

archive="$temporary_directory/opencode-swe.tar.gz"
curl --fail --location --silent --show-error "$release_url" --output "$archive"
tar -xzf "$archive" -C "$temporary_directory"

for required_path in opencode.jsonc AGENTS.md .opencode; do
  if [[ ! -e "$temporary_directory/$required_path" ]]; then
    printf 'Release archive is missing %s\n' "$required_path" >&2
    exit 1
  fi
done

cp "$temporary_directory/opencode.jsonc" "$target/opencode.jsonc"
cp "$temporary_directory/AGENTS.md" "$target/AGENTS.md"
rm -rf "$target/.opencode"
cp -a "$temporary_directory/.opencode" "$target/.opencode"

printf 'Installed the latest OpenCode SWE release in %s.\n' "$target"
