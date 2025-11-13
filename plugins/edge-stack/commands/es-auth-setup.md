---
description: Interactive authentication setup wizard. Configures nuxt-auth-utils, better-auth, OAuth providers, and generates handlers for Cloudflare Workers.
---

# Authentication Setup Command

<command_purpose> Guide developers through authentication stack configuration with automated code generation, database migrations, and MCP-driven provider setup. </command_purpose>

## Introduction

<role>Senior Security Engineer with expertise in authentication, nuxt-auth-utils, better-auth, and Cloudflare Workers security</role>

**This command will**:
- Detect framework (Nuxt vs standalone Worker)
- Configure nuxt-auth-utils (Nuxt primary) or better-auth (advanced/Worker)
- Query better-auth MCP for OAuth provider requirements
- Generate login/register/logout handlers
- Create D1 database schema for users/sessions
- Configure session security (HTTPS cookies, CSRF)
- Generate environment variables template

## Prerequisites

<requirements>
- Cloudflare Workers project (Nuxt or Hono)
- D1 database configured (or will create)
- For OAuth: Provider credentials (Google, GitHub, etc.)
</requirements>

## Main Tasks

### 1. Detect Framework & Auth Requirements

**Ask User**:
```markdown
🔐 Authentication Setup Wizard

1. What framework are you using?
   a) Nuxt 4
   b) Standalone Worker (Hono/plain TS)

2. What authentication methods do you need?
   a) Email/Password only
   b) OAuth providers (Google, GitHub, etc.)
   c) Passkeys
   d) Magic Links
   e) Multiple (OAuth + Email/Password)
```

**Decision Logic**:
```
If Nuxt + Email/Password only:
  → nuxt-auth-utils

If Nuxt + OAuth/Passkeys/Magic Links:
  → better-auth (auth) + nuxt-auth-utils (sessions)

If Standalone Worker:
  → better-auth
```

### 2. Install Dependencies

**For Nuxt + Simple Auth**:
```bash
npm install nuxt-auth-utils @node-rs/argon2
```

**For Nuxt + OAuth**:
```bash
npm install nuxt-auth-utils better-auth @node-rs/argon2
```

**For Standalone Worker**:
```bash
npm install better-auth hono
```

### 3. Generate Configuration Files

#### Nuxt + nuxt-auth-utils Only

**Generate**: `nuxt.config.ts` (update)
```typescript
export default defineNuxtConfig({
  modules: ['nuxt-auth-utils'],

  runtimeConfig: {
    session: {
      name: 'nuxt-session',
      password: process.env.NUXT_SESSION_PASSWORD, // 32+ char secret
      cookie: {
        sameSite: 'lax',
        secure: true, // HTTPS only
        httpOnly: true, // Prevent XSS
      },
      maxAge: 60 * 60 * 24 * 7, // 7 days
    }
  }
});
```

**Generate**: `server/api/auth/login.post.ts`
```typescript
import { hash, verify } from '@node-rs/argon2';

export default defineEventHandler(async (event) => {
  const { email, password } = await readBody(event);

  const user = await event.context.cloudflare.env.DB.prepare(
    'SELECT id, email, password_hash FROM users WHERE email = ?'
  ).bind(email).first();

  if (!user || !await verify(user.password_hash, password)) {
    throw createError({ statusCode: 401, message: 'Invalid credentials' });
  }

  await setUserSession(event, {
    user: { id: user.id, email: user.email },
    loggedInAt: new Date().toISOString(),
  });

  return { success: true };
});
```

#### Nuxt + better-auth + nuxt-auth-utils

**Query MCP for OAuth Setup**:
```typescript
const googleSetup = await mcp.betterAuth.getProviderSetup('google');
const githubSetup = await mcp.betterAuth.getProviderSetup('github');
```

**Generate**: `server/utils/auth.ts`
```typescript
import { betterAuth } from 'better-auth';

export const auth = betterAuth({
  database: {
    type: 'd1',
    database: process.env.DB,
  },

  socialProviders: {
    google: {
      clientId: process.env.GOOGLE_CLIENT_ID!,
      clientSecret: process.env.GOOGLE_CLIENT_SECRET!,
    },
    github: {
      clientId: process.env.GITHUB_CLIENT_ID!,
      clientSecret: process.env.GITHUB_CLIENT_SECRET!,
    },
  },
});
```

**Generate**: `server/api/auth/[...].ts` (OAuth handler)
```typescript
export default defineEventHandler(async (event) => {
  const response = await auth.handler(event.node.req, event.node.res);

  // Migrate better-auth session to nuxt-auth-utils
  if (event.node.req.url?.includes('/callback')) {
    const session = await auth.api.getSession({ headers: event.node.req.headers });
    if (session) {
      await setUserSession(event, {
        user: {
          id: session.user.id,
          email: session.user.email,
          name: session.user.name,
          provider: session.user.provider,
        },
      });
    }
  }

  return response;
});
```

### 4. Generate Database Migration

**Generate**: `migrations/0001_auth.sql`
```sql
-- Users table
CREATE TABLE users (
  id TEXT PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  email_verified INTEGER DEFAULT 0,
  password_hash TEXT, -- NULL for OAuth-only
  name TEXT,
  image TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
);

-- OAuth accounts (if using better-auth)
CREATE TABLE accounts (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  provider TEXT NOT NULL,
  provider_account_id TEXT NOT NULL,
  access_token TEXT,
  refresh_token TEXT,
  expires_at INTEGER,
  created_at TEXT NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  UNIQUE(provider, provider_account_id)
);

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_accounts_user ON accounts(user_id);
```

### 5. Configure Environment Variables

**Generate**: `.dev.vars`
```bash
# Session password (32+ characters)
NUXT_SESSION_PASSWORD=your-32-char-secret-here

# OAuth credentials (if using better-auth)
GOOGLE_CLIENT_ID=your-google-client-id
GOOGLE_CLIENT_SECRET=your-google-client-secret
GITHUB_CLIENT_ID=your-github-client-id
GITHUB_CLIENT_SECRET=your-github-client-secret
```

**Production Setup**:
```bash
wrangler secret put NUXT_SESSION_PASSWORD
wrangler secret put GOOGLE_CLIENT_SECRET
wrangler secret put GITHUB_CLIENT_SECRET
```

### 6. Generate Protected Route Example

**Generate**: `server/api/protected.get.ts`
```typescript
export default defineEventHandler(async (event) => {
  const session = await requireUserSession(event);

  return {
    message: 'Protected data',
    user: session.user,
  };
});
```

### 7. Validate Setup

**Security Checklist**:
- ✅ HTTPS-only cookies configured
- ✅ httpOnly flag set
- ✅ SameSite configured (lax or strict)
- ✅ Password hashing uses Argon2id
- ✅ Session password is 32+ characters
- ✅ OAuth redirect URIs configured (if applicable)
- ✅ CSRF protection enabled (automatic)

## Success Criteria

✅ Auth setup complete when:
- Framework detected and appropriate stack chosen
- Dependencies installed
- Configuration files generated
- Database migration created
- Environment variables template created
- Security settings validated
- Example handlers provided

## Output Summary

**Files Created**:
- Configuration (nuxt.config.ts or auth.ts)
- Auth handlers (login, register, logout, OAuth callback)
- Database migration (users, accounts)
- Protected route example
- Environment variables template

**Next Actions**:
1. Run database migration
2. Generate session password (32+ chars)
3. Configure OAuth providers (if applicable)
4. Test authentication flow
5. Add rate limiting to auth endpoints
6. Deploy with `/es-deploy`

## Notes

- Always use nuxt-auth-utils for Nuxt (Workers-optimized)
- Add better-auth only when OAuth/passkeys needed
- Query better-auth MCP for latest provider requirements
- Use Argon2id for password hashing (never bcrypt)
- Store secrets in Cloudflare Workers secrets (not wrangler.toml)
- See `agents/better-auth-specialist` for detailed guidance
