#!/bin/sh

echo "=== Testing SSO from inside container ==="
echo "1. Testing main SSO server:"
wget -q --spider https://sso.shopsthai.com/ && echo "SUCCESS" || echo "FAILED"

echo "2. Testing JWKS endpoint:"
wget -q --spider https://sso.shopsthai.com/.well-known/jwks.json && echo "SUCCESS" || echo "FAILED"

echo "3. Getting JWKS content:"
wget -q -O - https://sso.shopsthai.com/.well-known/jwks.json | head -5 || echo "FAILED to get content"

echo "4. DNS resolution:"
nslookup sso.shopsthai.com || echo "DNS failed"

echo "5. Network connectivity:"
ping -c 2 sso.shopsthai.com || echo "Ping failed"
