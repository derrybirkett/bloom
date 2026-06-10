#!/usr/bin/env bash
#
# e2e.sh — end-to-end test of bloom-init.
#
# Usage:
#   BLOOM_SOURCE=file:///path/to/bloom-workspace test/e2e.sh
#
# BLOOM_SOURCE must point at a directory containing the five bloom repos
# (soul, idea, stack, shulkerbox, council) as git repos. CI assembles this
# layout from fresh clones; locally, point it at your bloom workspace.
#
# Verifies the full bootstrap contract:
#   1. bootstrap succeeds: submodules, docs scaffold, both no-main hooks
#   2. a commit on main is blocked (pre-commit hook)
#   3. a commit on a feature branch is allowed
#   4. initial publish of main is allowed; subsequent direct push blocked
#   5. a failed bootstrap removes its partial product dir
#   6. the refusal guard rejects products inside a bloom-system parent

set -uo pipefail

here="$(cd "$(dirname "$0")/.." && pwd)"
BLOOM_INIT="$here/bloom-init"
: "${BLOOM_SOURCE:?set BLOOM_SOURCE to a file:// URL of the bloom workspace}"

workdir="$(mktemp -d)"
trap 'rm -rf "$workdir"' EXIT

fails=0
pass() { echo "  PASS: $*"; }
fail() { echo "  FAIL: $*"; fails=$((fails + 1)); }

echo "[1/6] bootstrap a product"
if "$BLOOM_INIT" e2e-product --parent "$workdir" >/dev/null 2>&1; then
  pass "bloom-init exits 0"
else
  fail "bloom-init failed"
fi
product="$workdir/e2e-product"
[ -f "$product/docs/intent.md" ] && pass "docs/ scaffolded" || fail "docs/intent.md missing"
[ -d "$product/.bloom/soul" ] && pass "submodules mounted" || fail ".bloom/soul missing"
[ -x "$product/.git/hooks/pre-commit" ] && pass "pre-commit hook installed" || fail "pre-commit hook missing"
[ -x "$product/.git/hooks/pre-push" ] && pass "pre-push hook installed" || fail "pre-push hook missing"

echo "[2/6] commit on main is blocked"
if (cd "$product" && echo x >x.txt && git add x.txt && git commit -m "test: blocked" >/dev/null 2>&1); then
  fail "commit on main succeeded"
else
  pass "commit on main blocked"
fi
(cd "$product" && git reset -q x.txt && rm -f x.txt)

echo "[3/6] commit on a feature branch is allowed"
if (cd "$product" && git checkout -q -b feat/e2e && echo y >y.txt && git add y.txt && git commit -qm "feat: e2e" >/dev/null 2>&1); then
  pass "branch commit allowed"
else
  fail "branch commit blocked"
fi

echo "[4/6] pre-push: initial publish allowed, later direct push blocked"
git init -q --bare "$workdir/remote.git"
(cd "$product" && git remote add origin "$workdir/remote.git" && git checkout -q main)
if (cd "$product" && git push -q origin main >/dev/null 2>&1); then
  pass "initial publish of main allowed"
else
  fail "initial publish of main blocked"
fi
(cd "$product" && git merge -q feat/e2e >/dev/null 2>&1)
if (cd "$product" && git push -q origin main >/dev/null 2>&1); then
  fail "second direct push to main succeeded"
else
  pass "second direct push to main blocked"
fi

echo "[5/6] failed bootstrap cleans up after itself"
BLOOM_SOURCE="file:///nonexistent" "$BLOOM_INIT" fail-product --parent "$workdir" >/dev/null 2>&1
if [ -d "$workdir/fail-product" ]; then
  fail "partial product dir left behind"
else
  pass "partial product dir removed"
fi

echo "[6/6] refusal guard rejects products inside a bloom-system parent"
fake="$workdir/fake-system"
mkdir -p "$fake/bloom" "$fake/soul" "$fake/idea" "$fake/stack"
cp "$BLOOM_INIT" "$fake/bloom/bloom-init"
if "$BLOOM_INIT" guarded --parent "$fake" >/dev/null 2>&1; then
  fail "product created inside system parent"
else
  pass "refused"
fi

echo ""
if [ "$fails" -eq 0 ]; then
  echo "e2e: all checks passed"
else
  echo "e2e: $fails check(s) FAILED"
fi
exit "$((fails > 0))"
