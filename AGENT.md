# AGENT.md

## Project: Caddy Gen Proxy + Keycloak + Stateless JWT Architecture

---

# 1. Overview

This project provides a production-ready reverse proxy and authentication gateway using:

- Caddy (with docker-proxy)
- Caddy Security (OIDC)
- Keycloak (External IdP broker)
- Bun + Elysia API (Stateless JWT verification)
- Vue + keycloak.js frontend
- Docker Compose (label-driven configuration)
- Multi-VM architecture

Design goal:

- Fully Stateless (JWT only)
- Horizontally scalable
- Zero-trust API
- Label-based configuration
- Production-grade security

---

# 2. Architecture

## Edge Layer (VM-1)

- Caddy (docker-proxy + security)
- Vue frontend (static)
- Optional Redis (only if needed for Caddy auth session)

Public entry point:
Cloudflare → DO LoadBalancer → Caddy

## API Layer (VM-2)

- Bun + Elysia services
- Stateless JWT verification
- Private network only
- No session storage

## Identity Layer

- Keycloak
- External IdP broker (Google, Azure AD, etc.)
- PostgreSQL (managed cloud DB)

---

# 3. Authentication Model

Authentication Flow:

1. Vue frontend uses keycloak.js
2. Authorization Code Flow + PKCE
3. Keycloak returns access token (JWT)
4. Frontend sends token to API:
   Authorization: Bearer <token>
5. API verifies JWT using JWKS
6. No session storage on API

Stateless only.

---

# 4. Caddy Features

## Plugins

- lucaslorentz/caddy-docker-proxy
- greenpau/caddy-security
- optional: mholt/caddy-ratelimit

## Responsibilities

Caddy handles:

- TLS (Auto HTTPS)
- Reverse proxy
- Optional OIDC protection
- Optional header injection
- Rate limiting
- HTTP/3 support

Caddy does NOT:

- Store user sessions for API
- Replace API-side JWT verification

---

# 5. Label-Based Configuration

All routing must be defined via docker-compose labels.

## Basic Public Service

Important:
API must not trust headers unless network is fully private.

---

# 6. Stateless JWT Requirements

API must:

- Validate signature (RS256)
- Validate issuer
- Validate audience
- Validate exp claim
- Cache JWKS

Never:

- Call Keycloak per request
- Use token introspection per request
- Store sessions

---

# 7. API Security Model

Zero Trust Model:

- API verifies JWT independently
- API does not trust network blindly
- API does not trust injected headers alone

Hybrid Mode (optional):

- Caddy blocks unauthenticated traffic
- API re-validates JWT

Recommended: Hybrid mode.

---

# 8. RBAC Model

Role stored in JWT:

Authorization must be enforced inside API.

Caddy-based role filtering is optional but not authoritative.

---

# 9. Scaling Strategy

## Horizontal Scaling

- Multiple Caddy instances behind LoadBalancer
- Multiple API instances
- No sticky session required
- No shared memory required

## Capacity

4 vCPU Edge node:
~15K concurrent users

Bun API 4 vCPU:
~10K-20K RPS

---

# 10. Security Hardening Checklist

## Infrastructure

- API private network only
- DB allowlist IP only
- Redis private only
- Keycloak admin console restricted
- Cloudflare WAF enabled

## Keycloak

- Brute force detection ON
- Rotate signing keys
- Access token lifespan 5–15 minutes
- Refresh token rotation ON

## API

- Validate aud claim
- Validate iss claim
- Reject expired token
- Do not trust injected headers blindly

---

# 11. Rate Limiting (Optional)

If enabled:

---

# 12. Prohibited Patterns

❌ Server-side session in API
❌ Sticky load balancer dependency
❌ JWT introspection per request
❌ Public API exposure bypassing Caddy
❌ Trusting X-User-\* headers without JWT verification

---

# 13. Production Modes

## Minimal Mode

- 1x Edge VM
- 1x API VM
- Managed DB

## HA Mode

- 2x Edge
- 2x API
- Keycloak separated
- Redis (optional)

---

# 14. Design Principles

- Stateless first
- Zero trust
- Label-driven config
- Horizontal scale
- Clear responsibility separation

---

# 15. Future Extensions

- Keycloak cluster
- Prometheus + Grafana
- Loki logging
- Canary deploy
- Multi-realm support
- HTTP/3 optimization

# 16. Caddy Template Features

## Security Headers

- Automatic fingerprint removal (Server, X-Powered-By)
- HSTS for HTTPS with max-age 31536000
- Conditional headers based on TLS mode

## Proxy Headers

- X-Real-IP forwarding
- X-Tlen-IP forwarding
- X-Forwarded-For forwarding
- Real IP preservation through reverse proxy

## Authentication

- Basic auth support with path restriction
- Label-driven user/password configuration

## Load Balancing

- Round-robin default policy
- Configurable LB policy via labels
- Multiple backend support

## Monitoring

- Metrics endpoint on :2015
- stdout logging configuration
- Zstd + gzip compression

## TLS Management

- Automatic TLS with email/config
- HTTP/HTTPS redirect support
- Alias domain redirection

---

End of AGENT.md
