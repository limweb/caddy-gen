# ✅ Production Deployment Checklist

## Caddy + Keycloak + Stateless JWT (Bun + Elysia + Vue)

---

# 1️⃣ Infrastructure

## Network Segmentation

- [ ] Caddy เป็น public entry point เพียงตัวเดียว
- [ ] API อยู่ private network เท่านั้น
- [ ] Redis (ถ้ามี) bind private IP
- [ ] Database allowlist เฉพาะ VM IP
- [ ] Keycloak admin console restricted (IP allowlist / VPN)

## Load Balancer

- [ ] Health check เปิดใช้งาน
- [ ] HTTPS only
- [ ] HTTP → HTTPS redirect
- [ ] Sticky session ❌ (ไม่ต้องใช้ใน Stateless mode)

## Cloudflare (ถ้าใช้)

- [ ] WAF เปิดใช้งาน
- [ ] Bot protection เปิดใช้งาน
- [ ] Rate limit rule พื้นฐาน

---

# 2️⃣ Caddy Configuration

## Build

- [x] ใช้ caddy-docker-proxy
- [x] ติดตั้ง caddy-security
- [x] ติดตั้ง rate-limit plugin (optional)
- [x] เปิด HTTP/3 (recommended)

## TLS

- [x] Auto HTTPS เปิดใช้งาน
- [x] TLS email ตั้งค่าแล้ว
- [x] HSTS เปิดใช้งาน (production)

## Label-Based Routing

- [x] ทุก service config ผ่าน docker-compose labels เท่านั้น
- [x] ไม่มี manual route hardcoded
- [x] reverse_proxy ใช้ private IP หรือ docker network

## Auth (ถ้าใช้ที่ Caddy)

- [ ] OIDC issuer ถูกต้อง
- [ ] Client ID / Secret ถูกต้อง
- [ ] ไม่ expose secret ใน repo

---

# 3️⃣ Keycloak Configuration

## Realm

- [ ] Realm แยก production ชัดเจน
- [ ] Signing algorithm = RS256

## Client (Frontend)

- [ ] Access Type = Public
- [ ] Standard Flow = ON
- [ ] PKCE Required = ON
- [ ] Implicit Flow = OFF
- [ ] Direct Access Grant = OFF (ถ้าไม่จำเป็น)

## Client (API Gateway / Caddy ถ้าใช้)

- [ ] Access Type = Confidential
- [ ] Redirect URI ถูกต้อง
- [ ] Web Origins ถูกต้อง

## Security

- [ ] Brute force detection ON
- [ ] Access token lifespan 5–15 นาที
- [ ] Refresh token rotation ON
- [ ] Rotate signing key policy วางแผนแล้ว

---

# 4️⃣ Frontend (Vue + keycloak.js)

- [ ] ใช้ Authorization Code Flow + PKCE
- [ ] checkLoginIframe = false
- [ ] updateToken() ก่อนยิง API ทุกครั้ง
- [ ] ไม่เก็บ token ใน localStorage ถ้าเลี่ยงได้
- [ ] ใช้ HTTPS เท่านั้น

---

# 5️⃣ API (Bun + Elysia)

## JWT Verification

- [ ] ใช้ JWKS endpoint
- [ ] Cache public key
- [ ] Validate issuer
- [ ] Validate audience
- [ ] Validate exp claim
- [ ] Reject malformed token

## Authorization

- [ ] Role check ทำใน API
- [ ] ไม่ rely เฉพาะ header injection
- [ ] RBAC logic แยกชัดเจน

## Stateless

- [ ] ไม่มี server-side session
- [ ] ไม่มี Redis dependency
- [ ] ไม่เรียก Keycloak per request
- [ ] ไม่ใช้ token introspection per request

---

# 6️⃣ Security Model

## Zero Trust

- [ ] API verify JWT เองทุก request
- [ ] ไม่ trust X-User-\* headers อย่างเดียว
- [ ] Block direct API public access

## Secrets

- [x] Client secrets เก็บใน environment variable
- [x] ไม่ commit secrets ลง git
- [x] ใช้ .env production-safe

---

# 7️⃣ Scaling Readiness

## Horizontal Scale

- [x] API scale ได้หลาย instance
- [x] Caddy scale ได้หลาย instance
- [x] ไม่ต้อง sticky session
- [x] No shared memory dependency

## Performance

- [x] Benchmark API RPS แล้ว (~10K-20K RPS สำหรับ 4 vCPU)
- [x] Monitor CPU usage
- [x] Monitor memory usage
- [x] Enable compression (gzip / brotli)

---

# 8️⃣ Observability

- [x] Access logs เปิดใช้งาน
- [x] Error logs centralize
- [x] Health endpoint (/health)
- [x] Metrics endpoint (optional)
- [x] Alert policy ตั้งค่าแล้ว

---

## Rate Limiting (Optional but Recommended)

- [x] Caddy rate limit เปิดใช้งาน
- [ ] API-level throttling ถ้าจำเป็น
- [ ] Protect login endpoints

---

# 🔟 Disaster Recovery

- [ ] Database backup policy
- [ ] Keycloak realm export backup
- [ ] Infrastructure as Code (optional)
- [ ] Restore test เคยทดสอบแล้ว

---

# 🚫 Anti-Pattern Checklist (ต้องไม่มี)

- [ ] ❌ Server-side session ใน API
- [ ] ❌ Sticky load balancer dependency
- [ ] ❌ JWT introspection per request
- [ ] ❌ Public API bypassing Caddy
- [ ] ❌ Hardcoded secret in repo
- [ ] ❌ Implicit flow for SPA

---

# 🏁 Production Ready Criteria

ระบบถือว่า Production Ready เมื่อ:

- [ ] Stateless verified
- [ ] Zero-trust enforced
- [ ] API verify JWT independently
- [ ] Network properly segmented
- [ ] Scaling tested
- [ ] Backup tested
- [ ] Security review completed
