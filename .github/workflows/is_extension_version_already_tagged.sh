#!/usr/bin/env bash

# Script requirements:
# - jq

# Fail on first error, on undefined variables, and on failures in pipelines.
set -euo pipefail

# Go to the repo root directory.
cd "$(git rev-parse --show-toplevel)"

CURRENT_VERSION="$(.github/workflows/get_current_extension_version.sh)" || \
    (echo >&2 "Version information not found"; exit 1)

set +e
git fetch origin "v$CURRENT_VERSION" >/tmp/git-fetch-stdout.log 2>/tmp/git-fetch-stderr.log
EXIT_CODE="$?"
set -e
STDERR="$(cat /tmp/git-fetch-stderr.log)"

if [[ "$STDERR" == "fatal: couldn't find remote ref v$CURRENT_VERSION" ]]; then
    # Tag does not already exist.
    exit 0
elif [[ "$EXIT_CODE" == "$0" ]]; then
    # Tag already exists.
    exit 7
else
    # Unknown failure mode.
    STDOUT="$(cat /tmp/git-fetch-stdout.log)"
    echo >&2 "Failed to determine whether tag exists: 'git fetch' exit code $EXIT_CODE, stdout:\n$STDOUT\n\nstderr:\n$STDERR"
    exit 1
fi
