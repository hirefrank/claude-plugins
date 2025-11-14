---
description: Generate type-safe server functions for Tanstack Start with Cloudflare Workers bindings integration
---

# Tanstack Server Function Generator

<command_purpose> Generate type-safe server functions for Tanstack Start projects that leverage Cloudflare Workers bindings (KV, D1, R2, DO) with proper error handling and validation. </command_purpose>

## Introduction

<role>Senior Backend Engineer with expertise in server functions, type-safe RPC, and Cloudflare Workers bindings</role>

## Prerequisites

<requirements>
- Tanstack Start project
- Cloudflare Workers bindings configured
- TypeScript with strict mode
- Zod for validation (recommended)
</requirements>

## Command Usage

```bash
/es-tanstack-server-fn <name> <method> [options]
```

### Arguments:

- `<name>`: Function name (e.g., `getUser`, `updateProfile`, `deletePost`)
- `<method>`: HTTP method (`GET`, `POST`, `PUT`, `DELETE`)
- `[options]`: Optional flags:
  - `--binding <type>`: Cloudflare binding to use (kv, d1, r2, do)
  - `--validate`: Include Zod validation
  - `--cache`: Add caching strategy (for GET requests)

### Examples:

```bash
# Create GET function with D1 binding
/es-tanstack-server-fn getUser GET --binding d1

# Create POST function with validation
/es-tanstack-server-fn createUser POST --binding d1 --validate

# Create GET function with KV caching
/es-tanstack-server-fn getSettings GET --binding kv --cache
```

## Main Tasks

### 1. Generate Server Function

**Query (GET)**:

```typescript
// src/lib/server-functions/getUser.ts
import { createServerFn } from '@tanstack/start'
import { z } from 'zod'

const inputSchema = z.string()

export const getUser = createServerFn(
  'GET',
  async (id: string, context) => {
    // Validate input
    const validId = inputSchema.parse(id)

    const { env } = context.cloudflare

    const user = await env.DB.prepare(
      'SELECT * FROM users WHERE id = ?'
    ).bind(validId).first()

    if (!user) {
      throw new Error('User not found')
    }

    return user
  }
)
```

**Mutation (POST)**:

```typescript
// src/lib/server-functions/createUser.ts
import { createServerFn } from '@tanstack/start'
import { z } from 'zod'

const inputSchema = z.object({
  name: z.string().min(2).max(100),
  email: z.string().email(),
})

export const createUser = createServerFn(
  'POST',
  async (data: z.infer<typeof inputSchema>, context) => {
    // Validate input
    const validData = inputSchema.parse(data)

    const { env } = context.cloudflare

    const result = await env.DB.prepare(
      'INSERT INTO users (name, email) VALUES (?, ?)'
    ).bind(validData.name, validData.email).run()

    return {
      id: result.meta.last_row_id,
      ...validData
    }
  }
)
```

**With KV Caching**:

```typescript
// src/lib/server-functions/getSettings.ts
import { createServerFn } from '@tanstack/start'

export const getSettings = createServerFn(
  'GET',
  async (userId: string, context) => {
    const { env } = context.cloudflare

    // Check cache first
    const cached = await env.CACHE.get(`settings:${userId}`)
    if (cached) {
      return JSON.parse(cached)
    }

    // Fetch from D1
    const settings = await env.DB.prepare(
      'SELECT * FROM settings WHERE user_id = ?'
    ).bind(userId).first()

    // Cache for 1 hour
    await env.CACHE.put(
      `settings:${userId}`,
      JSON.stringify(settings),
      { expirationTtl: 3600 }
    )

    return settings
  }
)
```

### 2. Generate Usage Example

```tsx
// src/components/UserProfile.tsx
import { getUser } from '@/lib/server-functions/getUser'

export async function UserProfile({ id }: { id: string }) {
  const user = await getUser(id)

  return (
    <div>
      <h1>{user.name}</h1>
      <p>{user.email}</p>
    </div>
  )
}
```

### 3. Generate Tests

```typescript
// src/lib/server-functions/__tests__/getUser.test.ts
import { describe, it, expect, vi } from 'vitest'
import { getUser } from '../getUser'

describe('getUser', () => {
  it('should fetch user from database', async () => {
    const mockContext = {
      cloudflare: {
        env: {
          DB: {
            prepare: vi.fn().mockReturnValue({
              bind: vi.fn().mockReturnValue({
                first: vi.fn().mockResolvedValue({
                  id: '1',
                  name: 'John Doe',
                  email: 'john@example.com',
                }),
              }),
            }),
          },
        },
      },
    }

    const user = await getUser('1', mockContext)

    expect(user).toEqual({
      id: '1',
      name: 'John Doe',
      email: 'john@example.com',
    })
  })
})
```

## Success Criteria

✅ Server function generated with correct method
✅ Cloudflare bindings accessible
✅ Input validation with Zod
✅ Error handling implemented
✅ TypeScript types defined
✅ Usage example provided
✅ Tests generated (optional)
