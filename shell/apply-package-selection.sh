#!/usr/bin/env bash
# Apply custom package selection as an extension of upstream custom package files.
# It never invents package names: every enabled selector must match a CUSTOM_PACKAGES line
# in shell/custom-packages.sh or shell/apk-custom-packages.sh.
set -euo pipefail

SELECTION_FILE="${PACKAGE_SELECTION:-shell/package-selection.conf}"
UPSTREAM_FILE="${UPSTREAM_PACKAGE_FILE:?UPSTREAM_PACKAGE_FILE is required}"
SOURCE_KIND="${PACKAGE_SOURCE:?PACKAGE_SOURCE is required}"  # apk or custom

if [ ! -f "$SELECTION_FILE" ]; then
  echo "⚪️ custom package selection not found: $SELECTION_FILE"
  return 0 2>/dev/null || exit 0
fi
if [ ! -f "$UPSTREAM_FILE" ]; then
  echo "❌ upstream package file not found: $UPSTREAM_FILE"
  return 1 2>/dev/null || exit 1
fi

echo "📦 Applying custom package selection: $SELECTION_FILE -> $UPSTREAM_FILE"

_trim() {
  sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'
}

_escape_regex() {
  printf '%s' "$1" | sed -e 's/[][\\.^$*+?{}|()]/\\&/g'
}

while IFS= read -r raw || [ -n "$raw" ]; do
  line="${raw%%#*}"
  line="$(printf '%s' "$line" | _trim)"
  [ -z "$line" ] && continue

  kind="$(printf '%s' "$line" | awk '{print $1}')"
  token="$(printf '%s' "$line" | awk '{print $2}')"
  [ -z "$kind" ] || [ -z "$token" ] && continue
  if [ "$kind" != "any" ] && [ "$kind" != "$SOURCE_KIND" ]; then
    continue
  fi

  token_re="$(_escape_regex "$token")"
  match="$(grep -E '^[[:space:]]*#?[[:space:]]*CUSTOM_PACKAGES=.*(^|[[:space:]])'"$token_re"'([[:space:]]|"|$)' "$UPSTREAM_FILE" | head -n 1 || true)"
  if [ -z "$match" ]; then
    echo "⚠️ skip: $token not found in $UPSTREAM_FILE"
    continue
  fi

  # Enable the exact upstream CUSTOM_PACKAGES line by removing only the leading comment marker.
  enabled="$(printf '%s\n' "$match" | sed -E 's/^[[:space:]]*#?[[:space:]]*//')"
  before="$CUSTOM_PACKAGES"
  eval "$enabled"
  if [ "$CUSTOM_PACKAGES" != "$before" ]; then
    echo "✅ selected from upstream: $token"
  fi
done < "$SELECTION_FILE"

export CUSTOM_PACKAGES
