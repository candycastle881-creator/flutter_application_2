#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <url>"
  exit 2
fi

URL="$1"
EXPECTED='google.com, pub-6695784329123227, DIRECT, f08c47fec0942fa0'

echo "Checking $URL for expected record..."
HTTP=$(curl -fsS "$URL" || { echo "Cannot fetch $URL"; exit 3; })

if echo "$HTTP" | grep -Fq "$EXPECTED"; then
  echo "OK: expected record found."
  exit 0
else
  echo "FAIL: expected record not found." >&2
  exit 1
fi
