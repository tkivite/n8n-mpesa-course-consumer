#!/usr/bin/env bash
# Quick sanity check: fetch a Daraja sandbox OAuth token with your .env creds.
# Usage: ./scripts/test-token.sh
set -euo pipefail

ENV_FILE="${1:-docker/.env}"
[[ -f "$ENV_FILE" ]] || { echo "Missing $ENV_FILE"; exit 1; }
set -a; source "$ENV_FILE"; set +a

: "${MPESA_CONSUMER_KEY:?not set}"
: "${MPESA_CONSUMER_SECRET:?not set}"
BASE="${MPESA_BASE_URL:-https://sandbox.safaricom.co.ke}"

echo "==> Requesting token from $BASE"
curl -sS -u "${MPESA_CONSUMER_KEY}:${MPESA_CONSUMER_SECRET}" \
  "${BASE}/oauth/v1/generate?grant_type=client_credentials" | tee /dev/stderr | grep -q access_token \
  && echo "" && echo "✅ Token OK" \
  || { echo "❌ No token in response"; exit 1; }

