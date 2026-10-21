#!/usr/bin/env bash
# =============================================================================
# bootstrap.sh — XaaS Ecosystem public entry point (v0, fail-closed)
#
# The conduit pattern (charter decision XD-001):
#   public repo (this file)  ->  authorization gate  ->  private core payload
#
# v0 behaviour:
#   * Verifies XAAS_ACCESS_TOKEN is present and authorized by the owner.
#   * WITHOUT a valid token: prints guidance and exits 1. Touches nothing.
#   * WITH a valid token: clones the private core and executes its deploy
#     entrypoint (payload lands in a later, owner-approved phase — until then
#     this is an explicit, honest no-op with a clear message).
#
# Security invariants (do not weaken without owner approval):
#   * Never embed secrets in this file. Token comes from the environment.
#   * Never echo the token. Never write it to disk or logs.
#   * Fail closed on every branch. set -euo pipefail. No sudo.
#   * Private core is fetched over authenticated HTTPS only.
# =============================================================================
set -euo pipefail

CORE_REPO="${XAAS_CORE_REPO:-ajdhoward/ajdhoward-xaas-ecosystem-core}"
WORKDIR="${XAAS_WORKDIR:-$HOME/.xaas}"

say()  { printf '%s\n' "$*"; }
done_banner() { printf '\a\n✅ DONE — bootstrap finished.\n'; command -v notify-send >/dev/null 2>&1 && notify-send "XaaS bootstrap" "finished" || true; }

say "🚀 XaaS Ecosystem bootstrap v0"

# --- Gate 1: authorization ---------------------------------------------------
if [ -z "${XAAS_ACCESS_TOKEN:-}" ]; then
  say ""
  say "⛔ No authorization credential found (XAAS_ACCESS_TOKEN is empty)."
  say "   This bootstrap fails closed by design — nothing was changed."
  say ""
  say "   How to get authorized:"
  say "     1. Read ACCESS.md in this repository."
  say "     2. Open an 'Access Request' issue (template provided) or contact @ajdhoward."
  say "     3. If approved, run:  XAAS_ACCESS_TOKEN=<issued-token> ./bootstrap.sh"
  say ""
  say "   Tokens are issued, scoped and revocable by the project owner only."
  exit 1
fi

# --- Gate 2: verify the token can actually reach the private core ------------
say "🔑 Credential present — verifying against the private core…"
if ! command -v git >/dev/null 2>&1; then
  say "⛔ git is required but not installed. Nothing was changed."; exit 1
fi

TMP_CHECK="$(mktemp -d)"
trap 'rm -rf "$TMP_CHECK"' EXIT
if ! GIT_TERMINAL_PROMPT=0 git -C "$TMP_CHECK" ls-remote \
     "https://xaas-deploy:${XAAS_ACCESS_TOKEN}@github.com/${CORE_REPO}.git" HEAD >/dev/null 2>&1; then
  say "⛔ Authorization check FAILED (token invalid, revoked, or no access to ${CORE_REPO})."
  say "   Nothing was changed. Re-request access per ACCESS.md."
  exit 1
fi
say "✅ Authorization verified."

# --- Stage 3: fetch the private core -----------------------------------------
mkdir -p "$WORKDIR"
if [ -d "$WORKDIR/core/.git" ]; then
  say "🔄 Updating existing core checkout in $WORKDIR/core …"
  GIT_TERMINAL_PROMPT=0 git -C "$WORKDIR/core" pull --ff-only \
    "https://xaas-deploy:${XAAS_ACCESS_TOKEN}@github.com/${CORE_REPO}.git" main
else
  say "📥 Cloning private core into $WORKDIR/core …"
  GIT_TERMINAL_PROMPT=0 git clone --depth 1 \
    "https://xaas-deploy:${XAAS_ACCESS_TOKEN}@github.com/${CORE_REPO}.git" "$WORKDIR/core"
fi

# --- Stage 4: execute the deployment payload (when it exists) ----------------
if [ -x "$WORKDIR/core/deploy/run-deploy.sh" ]; then
  say "🏗  Handing over to the private deployment payload…"
  ( cd "$WORKDIR/core" && ./deploy/run-deploy.sh )
else
  say ""
  say "ℹ️  Core fetched successfully, but the deployment payload"
  say "   (deploy/run-deploy.sh) has not been published yet — the project is"
  say "   in its initialization phase. Check PROGRESS.md in the core repo."
fi

done_banner
