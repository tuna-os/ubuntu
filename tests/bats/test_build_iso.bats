#!/usr/bin/env bats
# BATS tests for ubuntu-26.04/src/build-iso.sh
#
# Tests argument validation, usage messages, and error handling.
# Does NOT run the full ISO build (requires boot-files tar + squashfs).

setup() {
  REPO_ROOT="$(cd "${BATS_TEST_DIRNAME}/../.." && pwd)"
  BUILD_ISO="${REPO_ROOT}/ubuntu-26.04/src/build-iso.sh"
}

# ── existence and shebang ──────────────────────────────────────────────────

@test "build-iso.sh: exists and is executable" {
  run test -x "${BUILD_ISO}"
  [ "$status" -eq 0 ]
}

@test "build-iso.sh: has bash shebang" {
  run head -1 "${BUILD_ISO}"
  [[ "$output" =~ ^#!/.*bash ]] || [[ "$output" =~ ^#!/.*sh ]]
}

@test "build-iso.sh: has set -euo pipefail" {
  run grep 'set -euo pipefail' "${BUILD_ISO}"
  [ "$status" -eq 0 ]
}

# ── argument validation ────────────────────────────────────────────────────

@test "build-iso.sh: fails with usage when called with no arguments" {
  run bash "${BUILD_ISO}"
  [ "$status" -ne 0 ]
  [[ "$output" =~ Usage ]] || [[ "$output" =~ usage ]]
}

@test "build-iso.sh: fails with usage when called with one argument" {
  run bash "${BUILD_ISO}" /tmp/boot.tar
  [ "$status" -ne 0 ]
  [[ "$output" =~ Usage ]] || [[ "$output" =~ usage ]]
}

@test "build-iso.sh: fails with usage when called with two arguments" {
  run bash "${BUILD_ISO}" /tmp/boot.tar /tmp/squashfs.img
  [ "$status" -ne 0 ]
  [[ "$output" =~ Usage ]] || [[ "$output" =~ usage ]]
}

@test "build-iso.sh: fails with error on missing boot tar" {
  run bash "${BUILD_ISO}" /tmp/nonexistent-boot.tar /tmp/squashfs.img /tmp/output.iso
  [ "$status" -ne 0 ]
  [[ "$output" =~ missing ]] || [[ "$output" =~ ERROR ]] || [[ "$output" =~ error ]]
}

@test "build-iso.sh: fails error on missing squashfs" {
  run bash "${BUILD_ISO}" "${BATS_TEST_DIRNAME}/fixtures/dummy-boot.tar" /tmp/nonexistent-squashfs.img /tmp/output.iso
  # The script should fail when it can't find boot files
  [ "$status" -ne 0 ]
}
