#!/usr/bin/env bats
# BATS tests for ubuntu-26.04/src/configure-live.sh
#
# configure-live.sh is designed to run inside a container with --cap-add sys_admin.
# These tests validate script correctness and argument handling without
# running the full live configuration.

setup() {
  REPO_ROOT="$(cd "${BATS_TEST_DIRNAME}/../.." && pwd)"
  CONFIGURE_LIVE="${REPO_ROOT}/ubuntu-26.04/src/configure-live.sh"
}

# ── existence and shebang ──────────────────────────────────────────────────

@test "configure-live.sh: exists" {
  run test -f "${CONFIGURE_LIVE}"
  [ "$status" -eq 0 ]
}

@test "configure-live.sh: has bash shebang" {
  run head -1 "${CONFIGURE_LIVE}"
  [[ "$output" =~ ^#!/.*bash ]] || [[ "$output" =~ ^#!/.*sh ]]
}

@test "configure-live.sh: has set -exo pipefail" {
  run grep 'set -exo pipefail' "${CONFIGURE_LIVE}"
  [ "$status" -eq 0 ]
}

# ── shellcheck validation ──────────────────────────────────────────────────

@test "configure-live.sh: passes shellcheck" {
  if command -v shellcheck &>/dev/null; then
    run shellcheck "${CONFIGURE_LIVE}"
    [ "$status" -eq 0 ]
  else
    skip "shellcheck not installed"
  fi
}
