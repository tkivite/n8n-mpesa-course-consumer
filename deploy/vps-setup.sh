#!/usr/bin/env bash
# =============================================================
# n8n M-Pesa Course — VPS Setup Script
# Tested on Ubuntu 22.04 / 24.04 LTS (Hetzner, DigitalOcean, Vultr)
# Usage:  curl -fsSL https://raw.githubusercontent.com/<you>/n8n-mpesa-course/main/deploy/vps-setup.sh | sudo bash -s -- yourdomain.co.ke you@email.com
# =============================================================
set -euo pipefail

DOMAIN="${1:-}"
EMAIL="${2:-}"

if [[ -z "$DOMAIN" || -z "$EMAIL" ]]; then
  echo "Usage: $0 <domain> <email-for-letsencrypt>"
  exit 1
fi

if [[ $EUID -ne 0 ]]; then
  echo "Run as root (sudo)."
  exit 1
fi

echo "==> Updating system"
apt-get update -y && apt-get upgrade -y

echo "==> Installing dependencies"
apt-get install -y ca-certificates curl gnupg ufw git nginx certbot python3-certbot-nginx

echo "==> Installing Docker"
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
  > /etc/apt/sources.list.d/docker.list
apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "==> Firewall"
ufw allow OpenSSH
ufw allow 80/tcp
ufw allow 443/tcp
ufw --force enable

echo "==> Nginx config"
install -m 644 "$(dirname "$0")/nginx.conf" /etc/nginx/sites-available/n8n.conf
sed -i "s/__DOMAIN__/${DOMAIN}/g" /etc/nginx/sites-available/n8n.conf
ln -sf /etc/nginx/sites-available/n8n.conf /etc/nginx/sites-enabled/n8n.conf
rm -f /etc/nginx/sites-enabled/default
nginx -t && systemctl reload nginx

echo "==> Issuing TLS cert"
certbot --nginx -d "$DOMAIN" --non-interactive --agree-tos -m "$EMAIL" --redirect

echo "==> Clone course repo"
mkdir -p /opt/n8n-mpesa
cd /opt/n8n-mpesa
if [[ ! -d .git ]]; then
  git clone https://github.com/<YOUR-GH-USER>/n8n-mpesa-course.git .
fi

echo "==> Create .env (edit it before starting!)"
cp -n docker/.env.example docker/.env
sed -i "s|WEBHOOK_URL=.*|WEBHOOK_URL=https://${DOMAIN}/|" docker/.env
sed -i "s|N8N_HOST=.*|N8N_HOST=${DOMAIN}|" docker/.env
sed -i "s|N8N_PROTOCOL=.*|N8N_PROTOCOL=https|" docker/.env
sed -i "s|MPESA_CALLBACK_BASE_URL=.*|MPESA_CALLBACK_BASE_URL=https://${DOMAIN}|" docker/.env

echo ""
echo "============================================================"
echo "  Setup complete."
echo "  1. Edit /opt/n8n-mpesa/docker/.env (Daraja keys, N8N auth)"
echo "  2. cd /opt/n8n-mpesa/docker && docker compose up -d"
echo "  3. Open https://${DOMAIN}"
echo "============================================================"

