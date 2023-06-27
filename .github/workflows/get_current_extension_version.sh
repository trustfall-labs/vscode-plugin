#!/usr/bin/env bash

# Script requirements:
# - jq

# Fail on first error, on undefined variables, and on failures in pipelines.
set -euo pipefail

# Go to the repo root directory.
cd "$(git rev-parse --show-toplevel)"

jq --exit-status -r '.version' package.json
