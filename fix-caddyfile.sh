#!/bin/bash

echo "=== Force Regenerate Caddyfile ==="

echo "1. Removing old Caddyfile:"
docker exec caddy-gen_caddy_1 rm -f /etc/caddy/Caddyfile

echo "2. Removing backup template:"
docker exec caddy-gen_caddy_1 rm -f /code/docker-gen/templates/Caddyfile.bkp

echo "3. Recreating template:"
docker exec caddy-gen_caddy_1 cp /code/docker-gen/templates/Caddyfile.tmpl /code/docker-gen/templates/Caddyfile.bkp

echo "4. Force regenerate:"
docker exec caddy-gen_caddy_1 docker-gen /code/docker-gen/templates/Caddyfile.tmpl /etc/caddy/Caddyfile

echo "5. New Caddyfile content:"
echo "----------------------------------------"
docker exec caddy-gen_caddy_1 cat /etc/caddy/Caddyfile
echo "----------------------------------------"

echo "6. Validating new Caddyfile:"
docker exec caddy-gen_caddy_1 /usr/bin/caddy validate --config /etc/caddy/Caddyfile
