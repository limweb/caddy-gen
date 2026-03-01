#!/bin/bash

echo "=== ตรวจสอบ Caddyfile Generation ==="

echo "1. ตรวจสอบว่า Caddyfile มีอะไรบ้าง:"
echo "----------------------------------------"
docker exec caddy-gen_caddy_1 cat /etc/caddy/Caddyfile | grep -A 15 "jwtauth"
echo "----------------------------------------"

echo -e "\n2. ตรวจสอบ issuer_whitelist:"
docker exec caddy-gen_caddy_1 cat /etc/caddy/Caddyfile | grep "issuer_whitelist"

echo -e "\n3. ตรวจสอบ jwk_url:"
docker exec caddy-gen_caddy_1 cat /etc/caddy/Caddyfile | grep "jwk_url"

echo -e "\n4. ตรวจสอบ audience_whitelist:"
docker exec caddy-gen_caddy_1 cat /etc/caddy/Caddyfile | grep "audience_whitelist"

echo -e "\n5. ตรวจสอบว่ามี cache_duration หรือไม่ (ไม่ควรมี):"
if docker exec caddy-gen_caddy_1 cat /etc/caddy/Caddyfile | grep -q "cache_duration"; then
    echo "❌ ยังมี cache_duration อยู่ (ต้องลบ)"
else
    echo "✅ ไม่มี cache_duration (ถูกต้อง)"
fi

echo -e "\n6. Validate Caddyfile syntax:"
docker exec caddy-gen_caddy_1 /usr/bin/caddy validate --config /etc/caddy/Caddyfile && echo "✅ Syntax ถูกต้อง" || echo "❌ Syntax ผิด"
