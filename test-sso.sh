#!/bin/bash

echo "=== Testing SSO Endpoint ==="
echo "1. Testing main SSO server:"
curl -I https://sso.shopsthai.com/ || echo "FAILED: Cannot reach main server"

echo -e "\n2. Testing JWKS endpoint:"
curl -I https://sso.shopsthai.com/.well-known/jwks.json || echo "FAILED: Cannot reach JWKS endpoint"

echo -e "\n3. Getting JWKS content:"
curl -s https://sso.shopsthai.com/.well-known/jwks.json | head -20 || echo "FAILED: Cannot get JWKS content"

echo -e "\n=== DNS Check ==="
nslookup sso.shopsthai.com || echo "FAILED: DNS resolution failed"

echo -e "\n=== Network Test ==="
ping -c 3 sso.shopsthai.com || echo "FAILED: Ping failed"
