#!/usr/bin/env bash
# Check that the example policy lowers with the pinned Wesley and hashes to the
# recorded value.
#
# Requires:    wesley (wesley-cli at the version in WESLEY_VERSION), cat, mktemp, rm.
# Arguments:   none.
# Environment: TMPDIR, optional, is the parent of the scratch directory.
# Output:      one line on stdout naming the hash that matched.
# Effects:     creates one scratch directory and removes it on exit.
# Exit status: 0  the hash matches.
#              1  Wesley rejects the policy, or the hash differs.
#              2  a required tool or file is missing, or Wesley is the wrong version.

WESLEY_VERSION='0.3.0-alpha.3'
owned_scratch_dir=''

remove_owned_scratch_dir() {
  if [[ -n $owned_scratch_dir && -d $owned_scratch_dir ]]; then
    rm -rf -- "$owned_scratch_dir"
  fi
}

fail() {
  # fail STATUS MESSAGE: report on stderr and return STATUS.
  local status=$1 message=$2
  printf 'check-example-policy: %s\n' "$message" >&2 || :
  return "$status"
}

main() {
  set -euo pipefail
  if ((BASH_VERSINFO[0] > 4 || (BASH_VERSINFO[0] == 4 && BASH_VERSINFO[1] >= 4))); then
    shopt -s inherit_errexit
  fi
  unset CDPATH GLOBIGNORE

  if (($# != 0)); then
    fail 2 'takes no arguments' || return
  fi

  local source_path=${BASH_SOURCE[0]} script_dir
  script_dir=${source_path%/*}
  if [[ $script_dir == "$source_path" ]]; then
    script_dir=.
  fi
  local fixture_dir=$script_dir/../fixtures/example-policy

  if ! command -v wesley >/dev/null; then
    fail 2 "wesley is not on PATH; install wesley-cli $WESLEY_VERSION" || return
  fi
  local found_version
  if ! found_version=$(wesley --version); then
    fail 2 'wesley --version failed' || return
  fi
  if [[ $found_version != "$WESLEY_VERSION" ]]; then
    fail 2 "wesley is version $found_version; this check needs $WESLEY_VERSION" || return
  fi

  # Order matters: the hash is of the three files concatenated in this order.
  local -a sources=(
    "$fixture_dir/bricks/standard.graphql"
    "$fixture_dir/profiles/determinism.graphql"
    "$fixture_dir/subjects/warp-core.graphql"
  )
  local hash_file=$fixture_dir/schema-hash.txt path
  for path in "${sources[@]}" "$hash_file"; do
    if [[ ! -r $path ]]; then
      fail 2 "cannot read $path" || return
    fi
  done

  local expected=''
  if ! IFS= read -r expected <"$hash_file"; then
    fail 2 "$hash_file has no complete first line" || return
  fi

  if ! owned_scratch_dir=$(mktemp -d "${TMPDIR:-/tmp}/regulate-example-policy.XXXXXXXXXX"); then
    owned_scratch_dir=''
    fail 2 'could not create a scratch directory' || return
  fi
  trap remove_owned_scratch_dir EXIT

  local combined=$owned_scratch_dir/policy.graphql
  if ! cat -- "${sources[@]}" >"$combined"; then
    fail 2 'could not concatenate the policy files' || return
  fi

  local actual
  if ! actual=$(wesley schema hash --schema "$combined"); then
    fail 1 'Wesley rejected the example policy' || return
  fi

  if [[ $actual != "$expected" ]]; then
    fail 1 "schema hash is $actual; fixtures/example-policy/schema-hash.txt records $expected" || return
  fi
  printf 'example policy lowers; schema hash %s\n' "$actual"
}

if [[ ${BASH_SOURCE[0]} == "$0" ]]; then
  main "$@"
fi
