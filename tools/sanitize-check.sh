#!/usr/bin/env bash
# sanitize-check.sh — refuse to publish identifying data.
#
# Runs over every tracked or staged text file and exits 1 on any hit.
# Two layers:
#   1. Generic shapes, defined here: IPv4 addresses, MAC addresses, email
#      addresses, long serial-like digit runs, 20-hex device identifiers.
#   2. A private denylist (names, network names, real hostnames, rooms),
#      kept OUTSIDE the repository and never committed. Its path comes from
#      $SANITIZE_DENYLIST, defaulting to ../Home-Lab.denylist. One
#      case-insensitive extended regex per line; blank lines and # ignored.
#
# Why the denylist is private: a public list of the words being hidden is
# itself a disclosure of those words. The source project learned this the
# hard way — its leak auditor printed the patterns it was checking for.
#
# Usage:  tools/sanitize-check.sh            (check the working tree)
#         tools/sanitize-check.sh --staged   (check what is staged)

set -u
cd "$(git rev-parse --show-toplevel)" || exit 2

denylist="${SANITIZE_DENYLIST:-../Home-Lab.denylist}"
mode="${1:-}"

# Dotted quads that are not locations: the RFC 1918 blocks as written in
# the firewall alias, the CARP/VRRP multicast group, and the iDRAC firmware
# version 2.65.65.65, which has the shape of an address and is not one.
allow_ipv4='^(10\.0\.0\.0|172\.16\.0\.0|192\.168\.0\.0|224\.0\.0\.18|2\.65\.65\.65)$'

if [ "$mode" = "--staged" ]; then
  files=$(git diff --cached --name-only --diff-filter=ACMR)
else
  files=$(git ls-files; git ls-files --others --exclude-standard)
fi

fail=0
report() { echo "SANITIZE: $1"; fail=1; }

for f in $files; do
  [ -f "$f" ] || continue
  case "$f" in
    tools/sanitize-check.sh) continue ;;   # holds the generic patterns
    *.png|*.jpg|*.jpeg|*.gif|*.ico|*.pdf) report "binary file not allowed: $f"; continue ;;
  esac

  while IFS= read -r ip; do
    addr="${ip%%/*}"
    [[ "$addr" =~ $allow_ipv4 ]] || report "$f: IPv4 address"
  done < <(grep -oE '\b([0-9]{1,3}\.){3}[0-9]{1,3}(/[0-9]{1,2})?\b' "$f")

  grep -qiE '\b([0-9a-f]{2}[:-]){5}[0-9a-f]{2}\b|\b[0-9a-f]{12}\b' "$f" \
    && report "$f: MAC address shape"
  grep -qiE '[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}' "$f" \
    && report "$f: email address"
  grep -qE '\b[0-9]{10}\b' "$f" && report "$f: 10-digit serial shape"
  grep -qE '\b[0-9A-F]{20}\b' "$f" && report "$f: 20-hex device identifier shape"
  grep -qiE '\b[0-9a-f]{64}\b' "$f" && report "$f: image checksum"

  if [ -f "$denylist" ]; then
    grep -qiE -f <(grep -vE '^(#|$)' "$denylist") -- "$f" \
      && report "$f: denylisted term (term not shown)"
  fi
done

if [ ! -f "$denylist" ]; then
  echo "SANITIZE: WARNING — no private denylist at $denylist; generic checks only"
fi

[ "$fail" -eq 0 ] && echo "SANITIZE: clean"
exit "$fail"
