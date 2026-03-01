#!/bin/bash

echo "=== Caddy Debug Script ==="

echo "1. Current Caddyfile:"
echo "----------------------------------------"
cat /etc/caddy/Caddyfile
echo "----------------------------------------"

echo -e "\n2. Validating Caddyfile syntax:"
/usr/bin/caddy validate --config /etc/caddy/Caddyfile

echo -e "\n3. Caddy version and plugins:"
/usr/bin/caddy version

echo -e "\n4. Checking required directories:"
ls -la /etc/caddy/

echo -e "\n5. Testing JWKS endpoint from container:"
wget -q --spider "https://sso.shopsthai.com/realms/shopsthai.app/protocol/openid-connect/certs" && echo "✓ JWKS reachable" || echo "✗ JWKS NOT reachable"

echo -e "\n6. Network connectivity test:"
ping -c 2 sso.shopsthai.com || echo "Ping failed"
