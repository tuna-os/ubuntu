#!/usr/bin/env bats
# BATS tests for .github/scripts/mount_btrfs.sh
#
# mount_btrfs.sh sets up btrfs loopback devices for container storage.
# These tests validate script structure and environment variable handling.

setup() {
  REPO_ROOT="$(cd "${BATS_TEST_DIRNAME}/../.." && pwd)"
  MOUNT_BTRFS="${REPO_ROOT}/.github/scripts/mount_btrfs.sh"
}

# ── existence and shebang ──────────────────────────────────────────────────

@test "mount_btrfs.sh: exists" {
  run test -f "${MOUNT_BTRFS}"
  [ "$status" -eq 0 ]
}

@test "mount_btrfs.sh: has bash shebang" {
  run head -1 "${MOUNT_BTRFS}"
  [[ "$output" =~ ^#!/.*bash ]] || [[ "$output" =~ ^#!/.*sh ]]
}

@test "mount_btrfs.sh: has set -eo pipefail" {
  run grep 'set -eo pipefail' "${MOUNT_BTRFS}"
  [ "$status" -eq 0 ]
}

# ── environment variables ──────────────────────────────────────────────────

@test "mount_btrfs.sh: defines BTRFS_TARGET_DIR with default" {
  run grep 'BTRFS_TARGET_DIR=' "${MOUNT_BTRFS}"
  [[ "$output" =~ "/var/lib/containers" ]]
}

@test "mount_btrfs.sh: defines BTRFS_MOUNT_OPTS with default" {
  run grep 'BTRFS_MOUNT_OPTS=' "${MOUNT_BTRFS}"
  [[ "$output" =~ "zstd:1" ]]
}

@test "mount_btrfs.sh: defines BTRFS_LOOPBACK_FREE with default" {
  run grep 'BTRFS_LOOPBACK_FREE=' "${MOUNT_BTRFS}"
  [ "$status" -eq 0 ]
}

# ── shellcheck ─────────────────────────────────────────────────────────────

@test "mount_btrfs.sh: passes shellcheck" {
  if command -v shellcheck &>/dev/null; then
    run shellcheck "${MOUNT_BTRFS}"
    [ "$status" -eq 0 ]
  else
    skip "shellcheck not installed"
  fi
}
