#!/usr/bin/env bash
set -euo pipefail

# Download exact-match IPsec/XFRM kernel-module APKs built by the companion repo.
# Kept as a standalone helper so this fork can sync upstream with a tiny patch.

if [ "${ENABLE_IPSEC_KMODS:-no}" != "yes" ]; then
  echo "⚪️ 未启用 IPsec/XFRM kmod 集成"
  exit 0
fi

: "${IPSEC_KMOD_REPO:?IPSEC_KMOD_REPO is required when ENABLE_IPSEC_KMODS=yes}"
: "${IPSEC_KMOD_RELEASE:?IPSEC_KMOD_RELEASE is required when ENABLE_IPSEC_KMODS=yes}"
: "${IMMORTALWRT_VERSION:?IMMORTALWRT_VERSION is required}"
case "${IMMORTALWRT_VERSION}" in
  25.12.*) ;;
  *) echo "❌ IPsec kmod integration only supports ImmortalWrt 25.12+; got ${IMMORTALWRT_VERSION}"; exit 1 ;;
esac

TARGET="${TARGET:-x86/64}"
ARCH_PACKAGES="${ARCH_PACKAGES:-x86_64}"
BASE_URL="https://github.com/${IPSEC_KMOD_REPO}/releases/download/${IPSEC_KMOD_RELEASE}"
DEST="/home/build/immortalwrt/packages"
TMP="/tmp/ipsec-kmods"
mkdir -p "$TMP" "$DEST"
cd "$TMP"
rm -f ./*

echo "🔐 集成 IPsec/XFRM kmod: ${IPSEC_KMOD_REPO}@${IPSEC_KMOD_RELEASE}"
curl -fsSLO "${BASE_URL}/buildinfo.txt"
curl -fsSLO "${BASE_URL}/SHA256SUMS"

grep -qx "IMMORTALWRT_VERSION=${IMMORTALWRT_VERSION}" buildinfo.txt || { echo "❌ version mismatch"; cat buildinfo.txt; exit 1; }
grep -qx "TARGET=${TARGET}" buildinfo.txt || { echo "❌ target mismatch"; cat buildinfo.txt; exit 1; }
grep -qx "ARCH_PACKAGES=${ARCH_PACKAGES}" buildinfo.txt || { echo "❌ arch mismatch"; cat buildinfo.txt; exit 1; }

curl -fsSLo /tmp/ipsec-kmod-assets.txt "${BASE_URL}/assets.txt"
required='kmod-ipsec kmod-ipsec4 kmod-ipsec6 kmod-ipt-ipsec'
for pkg in $required; do
  grep -q "^${pkg}_.*\.apk$" /tmp/ipsec-kmod-assets.txt || {
    echo "❌ missing required kmod asset: ${pkg}"
    cat /tmp/ipsec-kmod-assets.txt
    exit 1
  }
done

while IFS= read -r asset; do
  [ -n "$asset" ] || continue
  echo "⬇️  $asset"
  curl -fsSLO "${BASE_URL}/${asset}"
done < /tmp/ipsec-kmod-assets.txt

sha256sum -c SHA256SUMS
cp -v ./*.apk "$DEST"/
echo 'kmod-ipsec kmod-ipsec4 kmod-ipsec6 kmod-ipt-ipsec kmod-xfrm-interface kmod-nft-xfrm iptables-mod-ipsec' > /tmp/ipsec-kmod-packages.env
echo "✅ IPsec/XFRM kmod APKs copied into ${DEST}"
