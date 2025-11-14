---
description: Create new TanStack Router routes with loaders, type-safe params, and proper file structure for Tanstack Start projects
---

# Tanstack Route Generator Command

<command_purpose> Generate TanStack Router routes with server-side loaders, type-safe parameters, error boundaries, and proper file structure for Tanstack Start projects on Cloudflare Workers. </command_purpose>

## Introduction

<role>Senior Routing Engineer with expertise in TanStack Router, server-side data loading, and Cloudflare Workers integration</role>

## Prerequisites

<requirements>
- Tanstack Start project with TanStack Router
- Cloudflare Workers setup (wrangler.jsonc)
- TypeScript configured
- src/routes/ directory structure
</requirements>

## Command Usage

```bash
/es-tanstack-route <route-path> [options]
```

### Arguments:

- `<route-path>`: Route path (e.g., `/users/$id`, `/blog`, `/api/users`)
- `[options]`: Optional flags:
  - `--loader`: Include server-side loader (default: true for non-API routes)
  - `--api`: Create API route (server function)
  - `--layout`: Create layout route
  - `--params <params>`: Dynamic params (e.g., `id,slug`)
  - `--search-params <params>`: Search params (e.g., `page:number,filter:string`)

### Examples:

```bash
# Create static route
/es-tanstack-route /about

# Create dynamic route with loader
/es-tanstack-route /users/$id --loader

# Create API route
/es-tanstack-route /api/users --api

# Create route with search params
/es-tanstack-route /users --search-params page:number,sort:string
```

## Main Tasks

### 1. Parse Route Path

Convert route path to file path:

| Route Path | File Path |
|------------|-----------|
| `/` | `src/routes/index.tsx` |
| `/about` | `src/routes/about.tsx` |
| `/users/$id` | `src/routes/users.$id.tsx` |
| `/blog/$slug` | `src/routes/blog.$slug.tsx` |
| `/api/users` | `src/routes/api/users.ts` |

### 2. Generate Route File

**Standard Route with Loader**:

```tsx
// src/routes/users.$id.tsx
import { createFileRoute } from '@tanstack/react-router'
import { z } from 'zod'

export const Route = createFileRoute('/users/$id')({
  loader: async ({ params, context }) => {
    const { env } = context.cloudflare

    const user = await env.DB.prepare(
      'SELECT * FROM users WHERE id = ?'
    ).bind(params.id).first()

    if (!user) {
      throw new Error('User not found')
    }

    return { user }
  },
  errorComponent: ({ error }) => (
    <div className="p-4">
      <h1 className="text-2xl font-bold text-red-600">Error</h1>
      <p>{error.message}</p>
    </div>
  ),
  pendingComponent: () => (
    <div className="p-4">
      <Loader2 className="animate-spin" />
      <span>Loading...</span>
    </div>
  ),
  component: UserPage,
})

function UserPage() {
  const { user } = Route.useLoaderData()

  return (
    <div className="max-w-4xl mx-auto p-6">
      <h1 className="text-3xl font-bold">{user.name}</h1>
      <p className="text-gray-600">{user.email}</p>
    </div>
  )
}
```

**API Route**:

```typescript
// src/routes/api/users.ts
import { createAPIFileRoute } from '@tanstack/start/api'

export const Route = createAPIFileRoute('/api/users')({
  GET: async ({ request, context }) => {
    const { env } = context.cloudflare

    const users = await env.DB.prepare('SELECT * FROM users').all()

    return Response.json(users)
  },
  POST: async ({ request, context }) => {
    const { env } = context.cloudflare
    const data = await request.json()

    await env.DB.prepare(
      'INSERT INTO users (name, email) VALUES (?, ?)'
    ).bind(data.name, data.email).run()

    return Response.json({ success: true })
  },
})
```

**Route with Search Params**:

```tsx
// src/routes/users.tsx
import { createFileRoute } from '@tanstack/react-router'
import { z } from 'zod'

const searchSchema = z.object({
  page: z.number().int().positive().default(1),
  sort: z.enum(['name', 'date']).default('name'),
  filter: z.string().optional(),
})

export const Route = createFileRoute('/users')({
  validateSearch: searchSchema,
  loaderDeps: ({ search }) => search,
  loader: async ({ deps: search, context }) => {
    const { env } = context.cloudflare

    const offset = (search.page - 1) * 20
    const users = await env.DB.prepare(
      `SELECT * FROM users ORDER BY ${search.sort} LIMIT 20 OFFSET ?`
    ).bind(offset).all()

    return { users, search }
  },
  component: UsersPage,
})

function UsersPage() {
  const { users, search } = Route.useLoaderData()
  const navigate = Route.useNavigate()

  return (
    <div>
      <h1>Users (Page {search.page})</h1>
      {/* ... */}
    </div>
  )
}
```

### 3. Generate TypeScript Types

```typescript
// src/types/routes.ts
export interface UserParams {
  id: string
}

export interface UsersSearch {
  page: number
  sort: 'name' | 'date'
  filter?: string
}
```

### 4. Update Router Configuration

Ensure route is registered in router.

### 5. Validation

**Task tanstack-routing-specialist(generated route)**:
- Verify route path syntax
- Validate loader implementation
- Check error handling
- Verify TypeScript types
- Ensure Cloudflare bindings accessible

## Success Criteria

✅ Route file generated in correct location
✅ Loader implemented with Cloudflare bindings
✅ Error boundary included
✅ Pending state handled
✅ TypeScript types defined
✅ Search params validated (if applicable)
