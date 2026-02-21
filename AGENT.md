---
# 12. Prohibited Patterns

❌ Server-side session in API
❌ Sticky load balancer dependency
❌ JWT introspection per request
❌ Public API exposure bypassing Caddy
❌ Trusting X-User-* headers without JWT verification
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
