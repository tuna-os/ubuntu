#!/usr/bin/env bats
# BATS tests for ubuntu-26.04/src/install-flatpaks.sh
#
# install-flatpaks.sh requires network, dbus, and flatpak at container build time.
# These tests validate script structure without running the full flow.

setup() {
  REPO_ROOT="$(cd "${BATS_TEST_DIRNAME}/../.." && pwd)"
  INSTALL_FLATPAKS="${REPO_ROOT}/ubuntu-26.04/src/install-flatpaks.sh"
}

# ── existence and shebang ──────────────────────────────────────────────────

@test "install-flatpaks.sh: exists" {
  run test -f "${INSTALL_FLATPAKS}"
  [ "$status" -eq 0 ]
}

@test "install-flatpaks.sh: has bash shebang" {
  run head -1 "${INSTALL_FLATPAKS}"
  [[ "$output" =~ ^#!/.*bash ]] || [[ "$output" =~ ^#!/.*sh ]]
}

@test "install-flatpaks.sh: has set -exo pipefail" {
  run grep 'set -exo pipefail' "${INSTALL_FLATPAKS}"
  [ "$status" -eq 0 ]
}

# ── variable references ────────────────────────────────────────────────────

@test "install-flatpaks.sh: references FLATPAK_CACHE" {
  run grep 'FLATPAK_CACHE' "${INSTALL_FLATPAKS}"
  [ "$status" -eq 0 ]
}

@test "install-flatpaks.sh: references INSTALLER_CHANNEL" {
  run grep 'INSTALLER_CHANNEL' "${INSTALL_FLATPAKS}"
  [ "$status" -eq 0 ]
}

# ── shellcheck ─────────────────────────────────────────────────────────────

@test "install-flatpaks.sh: passes shellcheck" {
  if command -v shellcheck &>/dev/null; then
    run shellcheck "${INSTALL_FLATPAKS}"
    [ "$status" -eq 0 ]
  else
    skip "shellcheck not installed"
  fi
}
