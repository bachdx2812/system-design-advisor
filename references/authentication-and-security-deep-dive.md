# Authentication & Security Deep Dive

## Session vs JWT Comparison
| Dimension | Session-Based | JWT (Stateless) |
|-----------|--------------|-----------------|
| State | Server-side (Redis/DB) | Client-side (token) |
| Scalability | Needs shared store or sticky sessions | Stateless, any server |
| Revocation | Delete session instantly | Hard — need blocklist or short TTL |
| Storage | httpOnly cookie (CSRF protection) | httpOnly cookie (recommended) or Authorization header |
| Size | Small session ID (~32 bytes) | Large token (~1KB with claims) |

## JWT Best Practices
- **Header.Payload.Signature** — Base64url encoded, signed with HS256/RS256
- **Access token**: short-lived (15 min), in memory or httpOnly cookie
- **Refresh token**: long-lived (7-30 days), httpOnly cookie, rotate on each use
- **Token rotation**: issue new refresh token on each refresh; invalidate old one (detect reuse → revoke family)
- **Never store in localStorage** — XSS vulnerable; use httpOnly + Secure + SameSite=Strict

## OAuth 2.0 Flows
| Flow | Use Case | Security |
|------|----------|----------|
| Authorization Code + PKCE | SPAs, mobile apps | Best — code verifier prevents interception |
| Authorization Code | Server-side web apps | Good — secret stored server-side |
| Client Credentials | Service-to-service (M2M) | Good — no user involved |
| Implicit (deprecated) | Legacy SPAs | Poor — token in URL fragment |

## SSO: SAML vs OIDC
| | SAML 2.0 | OpenID Connect |
|-|----------|----------------|
| Format | XML assertions | JWT (id_token) |
| Transport | Browser POST/Redirect | REST API + redirects |
| Best for | Enterprise SSO | Modern web/mobile apps |
| Complexity | High (XML parsing) | Lower (JSON/JWT) |

## API Key Management
- **Hash keys** (SHA-256) — never store plaintext; show once at creation
- **Scoping**: per-endpoint or per-resource permissions
- **Rotation**: support multiple active keys; grace period for old key
- **Rate limit per key**: Redis INCR + TTL (sliding window counter)

## Rate Limiting Algorithms
| Algorithm | Mechanism | Trade-off |
|-----------|-----------|-----------|
| Token Bucket | Refill tokens at fixed rate; consume per request | Allows bursts |
| Sliding Window Log | Timestamp per request; count in window | Precise, memory-heavy |
| Sliding Window Counter | Weighted sum of current + previous window | Balanced |
| Fixed Window | Counter per time window (Redis INCR + TTL) | Simple, edge burst |

**Distributed**: central Redis counter (INCR + EXPIRE) per user/IP; or local counters + periodic sync

## Service-to-Service Security
- **mTLS**: both client and server present certificates; mutual verification
- **Service mesh** (Istio/Linkerd): automatic mTLS between sidecars
- **Zero-trust**: never trust network location; always verify identity + encrypt

## Authorization Models
| Model | Description | Best For |
|-------|-------------|----------|
| RBAC | Roles → permissions; users assigned roles | Simple orgs, admin panels |
| ABAC | Policies on attributes (user, resource, env) | Complex rules, context-dependent |
| ReBAC | Relationships between entities (Google Zanzibar) | Social graphs, document sharing |

## Secret Management
- **Vault / AWS Secrets Manager**: centralized, encrypted, audited
- **Rotation**: automated with grace period; zero-downtime key rollover
- **Never commit secrets**: `.env` + `.gitignore`; CI/CD injects from vault

## Decision Guide
| Scenario | Choose |
|----------|--------|
| Simple web app | Session-based + httpOnly cookie |
| SPA + API | JWT (short-lived) + refresh token rotation |
| Mobile app | OAuth 2.0 Authorization Code + PKCE |
| Microservices | mTLS + service mesh + JWT for user context |
| Enterprise SSO | OIDC (modern) or SAML (legacy) |
| API for third-party | API keys + OAuth 2.0 scopes |
