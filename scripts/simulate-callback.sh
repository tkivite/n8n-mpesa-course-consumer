#!/usr/bin/env bash
# Fire a fake Safaricom callback at your local n8n webhook.
# Usage: ./scripts/simulate-callback.sh <checkout_request_id> [success|cancelled|failed]
set -euo pipefail

CRID="${1:?checkout_request_id required}"
STATUS="${2:-success}"
URL="${N8N_CALLBACK_URL:-http://localhost:5678/webhook/mpesa/stk-callback}"

case "$STATUS" in
  success)
    PAYLOAD=$(cat <<EOF
{"Body":{"stkCallback":{"MerchantRequestID":"TEST-MRQ","CheckoutRequestID":"$CRID","ResultCode":0,"ResultDesc":"OK","CallbackMetadata":{"Item":[
  {"Name":"Amount","Value":1},
  {"Name":"MpesaReceiptNumber","Value":"SIM$(date +%s)"},
  {"Name":"TransactionDate","Value":$(date +%Y%m%d%H%M%S)},
  {"Name":"PhoneNumber","Value":254708374149}]}}}}
EOF
)
    ;;
  cancelled)
    PAYLOAD='{"Body":{"stkCallback":{"MerchantRequestID":"TEST-MRQ","CheckoutRequestID":"'$CRID'","ResultCode":1032,"ResultDesc":"Request cancelled by user"}}}'
    ;;
  failed)
    PAYLOAD='{"Body":{"stkCallback":{"MerchantRequestID":"TEST-MRQ","CheckoutRequestID":"'$CRID'","ResultCode":1,"ResultDesc":"Insufficient funds"}}}'
    ;;
  *) echo "Unknown status: $STATUS"; exit 1 ;;
esac

echo "==> POST $URL ($STATUS)"
curl -sS -X POST "$URL" -H 'Content-Type: application/json' -d "$PAYLOAD" | tee /dev/stderr; echo

