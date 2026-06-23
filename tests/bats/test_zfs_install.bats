#!/usr/bin/env bats
# BATS tests for ubuntu-26.04/src/zfs-install.sh
#
# zfs-install requires root and a real disk to operate.
# These tests validate script structure, usage messages, and error handling.

setup() {
  REPO_ROOT="$(cd "${BATS_TEST_DIRNAME}/../.." && pwd)"
  ZFS_INSTALL="${REPO_ROOT}/ubuntu-26.04/src/zfs-install.sh"
}

# ── existence and shebang ──────────────────────────────────────────────────

@test "zfs-install.sh: exists and is executable" {
  run test -x "${ZFS_INSTALL}"
  [ "$status" -eq 0 ]
}

@test "zfs-install.sh: has bash shebang" {
  run head -1 "${ZFS_INSTALL}"
  [[ "$output" =~ ^#!/.*bash ]] || [[ "$output" =~ ^#!/.*sh ]]
}

@test "zfs-install.sh: has set -euo pipefail" {
  run grep 'set -euo pipefail' "${ZFS_INSTALL}"
  [ "$status" -eq 0 ]
}

# ── argument validation ────────────────────────────────────────────────────

@test "zfs-install.sh: fails with usage when called with no arguments" {
  run bash "${ZFS_INSTALL}"
  [ "$status" -ne 0 ]
  [[ "$output" =~ Usage ]] || [[ "$output" =~ usage ]]
}

@test "zfs-install.sh: fails with error when called with nonexistent disk" {
  run bash "${ZFS_INSTALL}" /dev/nonexistent-disk
  [ "$status" -ne 0 ]
}

# ── helper functions ───────────────────────────────────────────────────────

@test "zfs-install.sh: defines die() helper" {
  run grep 'die()' "${ZFS_INSTALL}"
  [ "$status" -eq 0 ]
}

@test "zfs-install.sh: defines info() helper" {
  run grep 'info()' "${ZFS_INSTALL}"
  [ "$status" -eq 0 ]
}

@test "zfs-install.sh: defines require_cmd() helper" {
  run grep 'require_cmd()' "${ZFS_INSTALL}"
  [ "$status" -eq 0 ]
}

# ── shellcheck ─────────────────────────────────────────────────────────────

@test "zfs-install.sh: passes shellcheck" {
  if command -v shellcheck &>/dev/null; then
    run shellcheck "${ZFS_INSTALL}"
    [ "$status" -eq 0 ]
  else
    skip "shellcheck not installed"
  fi
}
