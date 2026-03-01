#!/bin/sh

echo "=== Keycloak Endpoint Test ==="

echo "1. Testing standard JWKS endpoint:"
wget -q --spider https://sso.shopsthai.com/.well-known/jwks.json && echo "✓ Standard JWKS works" || echo "✗ Standard JWKS failed"

echo -e "\n2. Testing Keycloak paths:"

# Test various Keycloak JWKS paths
paths=(
    "/auth/realms/master/protocol/openid-connect/certs"
    "/realms/master/protocol/openid-connect/certs"
    "/auth/realms/shopthai/protocol/openid-connect/certs"
    "/realms/shopthai/protocol/openid-connect/certs"
    "/auth/realms/shopthai.app/protocol/openid-connect/certs"
    "/realms/shopthai.app/protocol/openid-connect/certs"
)

for path in "${paths[@]}"; do
    echo "Testing: https://sso.shopsthai.com$path"
    wget -q --spider "https://sso.shopsthai.com$path" && echo "✓ SUCCESS" || echo "✗ FAILED"
done

echo -e "\n3. Testing main Keycloak server:"
wget -q --spider https://sso.shopsthai.com/ && echo "✓ Server reachable" || echo "✗ Server down"

echo -e "\n4. Testing Keycloak admin console:"
wget -q --spider https://sso.shopsthai.com/auth/ && echo "✓ Auth path works" || echo "✗ Auth path failed"
