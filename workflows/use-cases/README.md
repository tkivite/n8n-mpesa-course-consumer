# Use-Case Templates

Each JSON here is a ready-to-import n8n workflow building on the core 4 workflows. They assume `01-mpesa-auth`, `02-stk-push`, and `03-stk-callback` are already imported and active.

| File | Scenario | Trigger | Extra integrations |
|---|---|---|---|
| `ecommerce.json` | WooCommerce order checkout | Woo webhook `order.created` | WooCommerce REST, Email |
| `saas-billing.json` | Monthly subscription charge | Schedule (1st of month) | Postgres (subs table), Email |
| `school-fees.json` | Parent pays via Google Form | Google Forms webhook | Google Sheets, PDF.co, Gmail |
| `donations.json` | Donation form on Bubble.io | Webhook from Bubble | WhatsApp Cloud API |
| `whatsapp-bot.json` | WhatsApp message "Pay 500" | WhatsApp Cloud API webhook | WhatsApp Cloud API |

> **Note:** These are starter templates. Each lesson in Module 8 walks through customising one of them end-to-end. The JSON files below are intentionally minimal — rebuilt during the lesson rather than copy-pasted — so students actually learn.

## Importing

In n8n: **Workflows → Import from File → pick the JSON → Save**.

Then configure the credentials each workflow uses (shown as red triangles in the editor).

