#!/bin/sh

echo "=== Caddy JWT Configuration Debug ==="

echo "1. Current Caddyfile:"
cat /etc/caddy/Caddyfile

echo -e "\n2. Testing JWT configuration:"
echo "Checking if jwtauth directive is present..."

if grep -q "jwtauth" /etc/caddy/Caddyfile; then
    echo "✓ jwtauth directive found"
    echo "JWT configuration block:"
    grep -A 10 "jwtauth" /etc/caddy/Caddyfile
else
    echo "✗ jwtauth directive NOT found"
fi

echo -e "\n3. Caddy version and plugins:"
/usr/bin/caddy version

echo -e "\n4. Testing Caddy config syntax:"
/usr/bin/caddy validate --config /etc/caddy/Caddyfile || echo "Config validation failed"

echo -e "\n5. Checking network connectivity from Caddy:"
echo "Testing JWKS endpoint reachability..."
wget -q --spider https://sso.shopsthai.com/.well-known/jwks.json && echo "✓ Reachable" || echo "✗ Not reachable"
