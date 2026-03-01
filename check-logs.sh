#!/bin/bash

echo "=== Caddy Logs Debug ==="

echo "1. Recent Caddy logs:"
docker logs caddy-gen_caddy_1 --tail 50

echo -e "\n2. Docker-gen logs:"
docker logs caddy-gen_dockergen_1 --tail 20

echo -e "\n3. Container status:"
docker ps -a | grep caddy-gen

echo -e "\n4. Testing Caddyfile generation:"
echo "Checking if Caddyfile exists and readable:"
docker exec caddy-gen_caddy_1 test -f /etc/caddy/Caddyfile && echo "✓ Caddyfile exists" || echo "✗ Caddyfile missing"

echo -e "\n5. Manual Caddy validation:"
docker exec caddy-gen_caddy_1 /usr/bin/caddy validate --config /etc/caddy/Caddyfile
