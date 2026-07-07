#!/usr/bin/env bash
# Read LZY package profile. Format: packages... # description
# Comment/uncomment whole lines to select packages.
set -euo pipefail
PROFILE_FILE="${LZY_PACKAGE_PROFILE:-/home/build/immortalwrt/.lzy/packages-x86-64-25.12.conf}"

if [ ! -f "$PROFILE_FILE" ]; then
  echo "⚪️ LZY package profile not found: $PROFILE_FILE"
  return 0 2>/dev/null || exit 0
fi

echo "📦 Loading LZY package profile: $PROFILE_FILE"
while IFS= read -r line || [ -n "$line" ]; do
  line="${line%%#*}"
  # trim leading/trailing whitespace
  line="$(printf '%s' "$line" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
  [ -z "$line" ] && continue
  CUSTOM_PACKAGES="$CUSTOM_PACKAGES $line"
done < "$PROFILE_FILE"
export CUSTOM_PACKAGES
