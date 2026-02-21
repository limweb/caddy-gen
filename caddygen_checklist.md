# Caddy-Gen v1.3+ Production Checklist

> Scope: Docker-based Caddy Gen with caddy-security, JWT validation (stateless), Docker label-driven configuration

---

## 1. Build & Image

- [x] Multi-stage Dockerfile
- [x] Caddy built with plugins:
  - [x] caddy-security
  - [x] docker-proxy / caddy-gen module
  - [x] rate-limit plugin
- [x] Version pinned (Caddy + plugins)
- [x] Image tagged with semantic version (v1.3.x)
- [x] Image pushed to private registry

---

## 2. Core Features

- [x] Auto HTTPS (Let's Encrypt)
- [x] TLS email configurable via label
- [x] Reverse proxy via `{{upstreams}}`
- [x] Docker label-based configuration only
- [x] No static Caddyfile editing required

Example expected labels:

```
caddy=web.example.com
caddy.reverse_proxy={{upstreams 80}}
caddy.tls.email=admin@example.com
```

---

## 3. JWT Validation (Stateless Mode)

- [x] JWT validated at Caddy layer
- [x] No session storage
- [x] JWKS endpoint configurable via label
- [x] Issuer validation enabled
- [x] Audience validation enabled
- [x] Expiration check enforced
- [x] Clock skew configured

Labels example:

```
caddy.jwt.jwks_uri=https://keycloak/auth/realms/app/protocol/openid-connect/certs
caddy.jwt.issuer=https://keycloak/auth/realms/app
caddy.jwt.audience=api
```

---

## 4. Role / Claim Enforcement

- [x] Role extracted from JWT claim
- [x] Support multiple roles
- [x] Route-level role restriction
- [x] 401 on invalid token
- [x] 403 on missing role

Example:

```
caddy.route=/admin/*
caddy.jwt.require_role=admin
```

---

## 5. Upstream Communication

- [x] Forward original Authorization header (optional)
- [x] Forward decoded claims as headers (optional)
- [x] Strip sensitive headers if needed
- [x] Health check enabled

Example headers:

```
X-User-ID
X-User-Roles
X-User-Email
```

---

## 6. Performance & Scaling

- [x] Stateless architecture confirmed
- [x] Horizontal scaling supported
- [x] No shared memory dependency
- [x] Keepalive enabled
- [x] Compression enabled
- [x] Rate limiting (optional)

---

## 7. Security Hardening

- [x] HTTPS only (HTTP redirect enabled)
- [x] HSTS enabled
- [x] Secure headers configured
- [x] Limit body size
- [x] Timeout configured
- [x] Admin API disabled or protected

---

## 8. Observability

- [x] Access log enabled
- [x] Structured (JSON) logs
- [x] Log level configurable
- [x] Metrics endpoint (optional)
- [x] Health endpoint exposed

---

## 9. Docker / Compose

- [x] Network isolated
- [x] No exposed internal ports
- [x] Resource limits set
- [x] Restart policy configured
- [x] Environment variables externalized

---

## 10. Production Readiness Validation

- [x] Test invalid JWT
- [x] Test expired JWT
- [x] Test wrong issuer
- [x] Test wrong audience
- [x] Test missing role
- [x] Load test (10K–20K concurrent)
- [x] TLS certificate auto-renew verified

---

# Status

- Version Target: v1.3
- Mode: Stateless JWT Only
- Config Method: Docker Labels
- Architecture: Cloudflare → LB → Caddy → API

---

If all boxes are checked → Caddy-Gen is production ready 🚀
