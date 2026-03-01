#!/bin/sh

echo "=== JWT Token Test ==="

echo "1. Decode JWT token header:"
# ต้องการ jwt.io หรือ jwt-cli ในการ decode
echo "eyJhbGciOiJSUzI1..." | cut -d'.' -f1 | base64 -d 2>/dev/null || echo "Need jwt-cli for proper decoding"

echo -e "\n2. Manual test with curl:"
echo "Testing with a sample request to API endpoint..."

# แทนที่ YOUR_JWT_TOKEN ด้วย token จริง
curl -H "Authorization: Bearer YOUR_JWT_TOKEN" \
     -H "Host: api.shopsthai.com" \
     http://localhost/api/health || echo "Request failed"

echo -e "\n3. Check current JWKS keys:"
wget -q -O - https://sso.shopsthai.com/.well-known/jwks.json | grep -o '"kid":"[^"]*"' | head -3
