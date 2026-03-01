#!/bin/sh

echo "=== JWT Debug Script ==="
echo "Testing JWKS endpoint: https://sso.shopsthai.com/.well-known/jwks.json"

echo -e "\n1. Basic connectivity test:"
wget --timeout=10 --tries=1 -q --spider https://sso.shopsthai.com/.well-known/jwks.json
if [ $? -eq 0 ]; then
    echo "✓ Endpoint is reachable"
else
    echo "✗ Endpoint is NOT reachable"
    exit 1
fi

echo -e "\n2. Getting JWKS content:"
wget --timeout=10 --tries=1 -q -O - https://sso.shopsthai.com/.well-known/jwks.json > /tmp/jwks.json
if [ $? -eq 0 ]; then
    echo "✓ JWKS content retrieved"
    echo "Content preview:"
    head -10 /tmp/jwks.json
    
    echo -e "\n3. Checking for key ID 'Zc6FYmYz8Cwt0aZlMM5QHOxQsfOkXA-iwRuOR-XkPLU':"
    if grep -q "Zc6FYmYz8Cwt0aZlMM5QHOxQsfOkXA-iwRuOR-XkPLU" /tmp/jwks.json; then
        echo "✓ Key ID found in JWKS"
    else
        echo "✗ Key ID NOT found in JWKS"
        echo "Available key IDs:"
        grep -o '"kid":"[^"]*"' /tmp/jwks.json | head -5
    fi
else
    echo "✗ Failed to get JWKS content"
fi

echo -e "\n4. Testing with curl (alternative):"
curl -s --connect-timeout 5 https://sso.shopsthai.com/.well-known/jwks.json | head -5 || echo "Curl failed"

echo -e "\n5. DNS resolution:"
nslookup sso.shopsthai.com
