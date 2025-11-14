---
description: Migrate Cloudflare Workers applications from any frontend framework to Tanstack Start while preserving infrastructure
---

# Cloudflare Workers Framework Migration to Tanstack Start

<command_purpose> Migrate existing Cloudflare Workers applications from any frontend framework (React, Next.js, Vue, Nuxt, Svelte, vanilla JS) to Tanstack Start. Preserves all Cloudflare infrastructure (Workers, bindings, wrangler.toml) while modernizing the application layer. </command_purpose>

## Introduction

<role>Framework Migration Specialist focusing on Tanstack Start migrations for Cloudflare Workers applications</role>

This command analyzes your existing Cloudflare Workers application, identifies the current framework, and creates a comprehensive migration plan to Tanstack Start while preserving all Cloudflare infrastructure.

## Prerequisites

<requirements>
- Existing Cloudflare Workers application (already deployed)
- Cloudflare account with existing bindings (KV/D1/R2/DO)
- wrangler CLI installed (`npm install -g wrangler`)
- Git repository for tracking migration
- Node.js 18+ (for Tanstack Start)
</requirements>

## Migration Source

<migration_source> #$ARGUMENTS </migration_source>

**Source frameworks supported**:
- React / Next.js (straightforward React → React migration)
- Vue 2/3 / Nuxt 2/3/4 (will convert to React)
- Svelte / SvelteKit (will convert to React)
- Vanilla JavaScript (will add React structure)
- jQuery-based apps
- Custom frameworks

**Target**: Tanstack Start (React 19 + TanStack Router + Vite) with Cloudflare Workers

**IMPORTANT**: This is a **FRAMEWORK migration** (UI layer), NOT a platform migration. All Cloudflare infrastructure (Workers, bindings, wrangler.toml) will be **PRESERVED**.

## Main Tasks

### 1. Framework Detection & Analysis

<thinking>
First, identify the current framework to understand what we're migrating from.
This informs all subsequent migration decisions.
</thinking>

#### Step 1: Detect Current Framework

**Automatic detection**:

```bash
# Check package.json for framework dependencies
if grep -q "\"react\"" package.json; then
  echo "Detected: React"
  FRAMEWORK="react"
  if grep -q "\"next\"" package.json; then
    echo "Detected: Next.js"
    FRAMEWORK="nextjs"
  fi
elif grep -q "\"vue\"" package.json; then
  VERSION=$(jq -r '.dependencies.vue // .devDependencies.vue' package.json | sed 's/[\^~]//g' | cut -d. -f1)
  echo "Detected: Vue $VERSION"
  FRAMEWORK="vue$VERSION"
  if grep -q "\"nuxt\"" package.json; then
    NUXT_VERSION=$(jq -r '.dependencies.nuxt // .devDependencies.nuxt' package.json | sed 's/[\^~]//g' | cut -d. -f1)
    echo "Detected: Nuxt $NUXT_VERSION"
    FRAMEWORK="nuxt$NUXT_VERSION"
  fi
elif grep -q "\"svelte\"" package.json; then
  echo "Detected: Svelte"
  FRAMEWORK="svelte"
  if grep -q "\"@sveltejs/kit\"" package.json; then
    echo "Detected: SvelteKit"
    FRAMEWORK="sveltekit"
  fi
elif grep -q "\"jquery\"" package.json; then
  echo "Detected: jQuery"
  FRAMEWORK="jquery"
else
  echo "Detected: Vanilla JavaScript"
  FRAMEWORK="vanilla"
fi
```

#### Step 2: Analyze Application Structure

**Discovery tasks** (run in parallel):

1. **Inventory pages/routes**
   ```bash
   # React/Next.js
   find pages -name "*.jsx" -o -name "*.tsx" 2>/dev/null | wc -l
   find app -name "page.tsx" 2>/dev/null | wc -l

   # React/Nuxt
   find pages -name "*.vue" 2>/dev/null | wc -l

   # Vanilla
   find src -name "*.html" 2>/dev/null | wc -l
   ```

2. **Inventory components**
   ```bash
   find components -name "*.jsx" -o -name "*.tsx" -o -name "*.vue" -o -name "*.svelte" 2>/dev/null | wc -l
   ```

3. **Identify state management**
   ```bash
   # Redux/Zustand
   grep -r "createStore\|configureStore\|create.*zustand" src/ 2>/dev/null

   # React Query/TanStack Query
   grep -r "useQuery\|QueryClient" src/ 2>/dev/null

   # Zustand/Pinia
   grep -r "createStore\|defineStore" src/ store/ 2>/dev/null

   # Context API
   grep -r "createContext\|useContext" src/ 2>/dev/null
   ```

4. **Identify UI dependencies**
   ```bash
   # Check for UI frameworks
   jq '.dependencies + .devDependencies | keys[]' package.json | grep -E "bootstrap|material-ui|antd|chakra|@nuxt/ui|shadcn"
   ```

5. **Verify Cloudflare bindings** (MUST preserve)
   ```bash
   # Parse wrangler.toml
   grep -E "^\[\[kv_namespaces\]\]|^\[\[d1_databases\]\]|^\[\[r2_buckets\]\]|^\[\[durable_objects" wrangler.toml

   # List binding names
   grep "binding =" wrangler.toml | awk '{print $3}' | tr -d '"'
   ```

#### Step 3: Generate Framework Analysis Report

<deliverable>
Comprehensive report on current framework and migration complexity
</deliverable>

```markdown
## Framework Migration Analysis Report

**Project**: [app-name]
**Current Framework**: [React / Next.js / Vue / Nuxt / etc.]
**Target Framework**: Tanstack Start (React 19 + TanStack Router)
**Cloudflare Deployment**: ✅ Already on Workers

### Current Application Inventory

**Pages/Routes**: [X] routes detected
- [List key routes]

**Components**: [Y] components detected
- Shared: [count]
- Page-specific: [count]

**State Management**: [Redux / Zustand / TanStack Query / Context / None]
**UI Dependencies**: [Material UI / Chakra / shadcn/ui / Custom CSS / None]

**API Endpoints**: [Z] server routes/endpoints
- Backend framework: [Express / Hono / Next.js API / Nuxt server]

### Cloudflare Infrastructure (PRESERVE)

**Bindings** (from wrangler.toml):
- KV namespaces: [count] ([list names])
- D1 databases: [count] ([list names])
- R2 buckets: [count] ([list names])
- Durable Objects: [count] ([list classes])

**wrangler.toml Configuration**:
```toml
[Current wrangler.toml snippet]
```

**CRITICAL**: All bindings and Workers configuration will be PRESERVED. Only the application framework will change.

### Migration Complexity

**Overall Complexity**: [Low / Medium / High]

**Complexity Factors**:
- Framework paradigm shift: [None / Small / Large]
  - React → Tanstack Start: Low (same paradigm, better tooling)
  - Next.js → Tanstack Start: Medium (different routing)
  - React/Nuxt → Tanstack Start: High (Vue to React conversion)
  - Vanilla → Tanstack Start: Medium (adding framework)
- Component count: [X components] - [Low / Medium / High]
- State management migration: [Simple / Complex]
- UI dependencies: [Easy replacement / Medium / Custom CSS (requires work)]
- API complexity: [Simple / Keep separate]

### Migration Strategy Recommendation

[Detailed strategy based on analysis]

**Approach**: [Full migration / Incremental / UI-only with separate backend]

**Timeline**: [X weeks / days]
**Estimated Effort**: [Low / Medium / High]
```

### 2. Multi-Agent Migration Planning

<thinking>
Use the tanstack-migration-specialist agent and supporting agents to create
a comprehensive migration plan.
</thinking>

#### Phase 1: Framework-Specific Analysis

1. **Task tanstack-migration-specialist(current framework and structure)**
   - Analyze source framework patterns
   - Map components to React + shadcn/ui equivalents
   - Plan routing migration (TanStack Router file-based routing)
   - Recommend state management approach (TanStack Query + Zustand)
   - Design API strategy (server functions vs separate backend)
   - Generate component mapping table
   - Generate route mapping table
   - Create implementation plan with todos

#### Phase 2: Cloudflare Infrastructure Validation (Parallel)

2. **Task binding-context-analyzer(existing wrangler.toml)**
   - Parse current wrangler.toml
   - Verify all bindings are valid
   - Document binding usage patterns
   - Ensure compatibility_date is 2025-09-15+
   - Verify `remote = true` on all bindings
   - Generate Env TypeScript interface

3. **Task cloudflare-architecture-strategist(current architecture)**
   - Analyze if backend should stay separate or integrate
   - Recommend Workers architecture (single vs multiple)
   - Service binding strategy (if multi-worker)
   - Assess if Tanstack Start server functions can replace existing API

#### Phase 3: Code Quality & Patterns (Parallel)

4. **Task cloudflare-pattern-specialist(current codebase)**
   - Identify Workers-specific patterns to preserve
   - Detect any Workers anti-patterns
   - Ensure bindings usage follows best practices

5. **Task workers-runtime-guardian(current codebase)**
   - Verify no Node.js APIs exist (would break in Workers)
   - Check compatibility with Workers runtime
   - Validate all code is Workers-compatible

### 3. Migration Plan Synthesis

<deliverable>
Detailed Tanstack Start migration plan with step-by-step instructions
</deliverable>

<critical_requirement> Present complete migration plan for user approval before starting any code changes. </critical_requirement>

The tanstack-migration-specialist agent will generate a comprehensive plan including:

**Component Migration Plan**:
| Old Component | New Component (shadcn/ui or custom) | Effort | Notes |
|--------------|-------------------------------------|--------|-------|
| `<Button>` | `<Button>` (shadcn/ui) | Low | Direct mapping |
| `<UserCard>` | `<Card>` + custom | Medium | Restructure children |
| `<Modal>` (Vue) | `<Dialog>` (shadcn/ui) | Medium | Vue → React conversion |

**Route Migration Plan**:
| Old Route | New File | Dynamic | Loaders | Notes |
|----------|---------|---------|---------|-------|
| `/` | `src/routes/index.tsx` | No | No | Home |
| `/users/:id` | `src/routes/users.$id.tsx` | Yes | Yes | Detail with data loading |
| `/api/users` | `src/routes/api/users.ts` | No | N/A | API route (server function) |

**State Management Strategy**:
- Current: [Redux / Context / Zustand / etc.]
- Target: TanStack Query (server state) + Zustand (client state)
- Migration approach: [Details]

**Data Fetching Strategy**:
- Current: [useEffect + fetch / Next.js getServerSideProps / Nuxt useAsyncData]
- Target: TanStack Router loaders + TanStack Query
- Benefits: Type-safe, automatic caching, optimistic updates

**API Strategy**:
- Current: [Express / Hono / Next.js API / Nuxt server routes]
- Recommendation: [Tanstack Start server functions / Keep separate]
- Rationale: [Why]

**Styling Strategy**:
- Current: [Material UI / Chakra / shadcn/ui / Custom CSS]
- Target: shadcn/ui + Tailwind 4
- Migration: [Component-by-component replacement]

**Implementation Phases**:
1. Setup Tanstack Start project with Cloudflare Workers preset
2. Configure wrangler.jsonc for deployment
3. Setup shadcn/ui components
4. Migrate layouts (if any)
5. Migrate routes with loaders (priority order)
6. Convert components to React (if needed)
7. Setup TanStack Query + Zustand
8. Migrate/create server functions
9. Replace UI with shadcn/ui + Tailwind 4
10. Update Cloudflare bindings in app context
11. Test & deploy

### 4. User Approval & Confirmation

<critical_requirement> MUST get explicit user approval before proceeding with any code changes. </critical_requirement>

**Present the migration plan and ask**:

```
📋 Tanstack Start Migration Plan Complete

Summary:
- Source framework: [React / Next.js / Vue / Nuxt / etc.]
- Target: Tanstack Start (React 19 + TanStack Router)
- Complexity: [Low / Medium / High]
- Timeline: [X] weeks/days

Key changes:
1. [Major change 1]
2. [Major change 2]
3. [Major change 3]

Cloudflare infrastructure:
✅ All bindings preserved (no changes)
✅ wrangler.toml configuration maintained
✅ Workers deployment unchanged

Do you want to proceed with this migration plan?

Options:
1. yes - Start Phase 1 (Setup Tanstack Start)
2. show-details - View detailed component/route mappings
3. modify - Adjust plan before starting
4. export - Save plan to .claude/todos/ for later
5. no - Cancel migration
```

### 5. Automated Migration Execution

<thinking>
Only execute if user approves. Work through phases systematically.
</thinking>

**If user says "yes"**:

1. **Create migration branch**
   ```bash
   git checkout -b migrate-to-tanstack-start
   git commit -m "chore: Create migration branch for Tanstack Start"
   ```

2. **Phase 1: Initialize Tanstack Start Project**

   ```bash
   # Create new Tanstack Start app with Cloudflare preset
   pnpm create @tanstack/start@latest temp-tanstack --template start-basic-cloudflare

   # Copy configuration files
   cp temp-tanstack/vite.config.ts ./
   cp temp-tanstack/app.config.ts ./
   cp temp-tanstack/tsconfig.json ./tsconfig.tanstack.json

   # Install dependencies
   pnpm add @tanstack/start @tanstack/react-router @tanstack/react-query zustand
   pnpm add -D vinxi vite

   # Setup shadcn/ui
   pnpx shadcn@latest init
   # Select: Tailwind 4, TypeScript, src/ directory
   ```

3. **Phase 2: Configure Cloudflare Workers**

   Create `wrangler.jsonc`:
   ```jsonc
   {
     "name": "your-app-name",
     "compatibility_date": "2025-09-15",
     "main": ".output/server/index.mjs",

     // PRESERVE existing bindings from old wrangler.toml
     "kv_namespaces": [
       // Copy from analysis report
     ],
     "d1_databases": [
       // Copy from analysis report
     ],
     "r2_buckets": [
       // Copy from analysis report
     ]
   }
   ```

   Update `vite.config.ts`:
   ```typescript
   import { defineConfig } from 'vite'
   import { TanStackStartVite } from '@tanstack/start/vite'

   export default defineConfig({
     plugins: [TanStackStartVite()],
   })
   ```

4. **Phase 3: Migrate Routes**

   For each route in the migration plan:

   **Next.js `pages/users/[id].tsx` → Tanstack Start `src/routes/users.$id.tsx`**:

   ```tsx
   // OLD (Next.js)
   export async function getServerSideProps({ params }) {
     const user = await fetchUser(params.id)
     return { props: { user } }
   }

   export default function UserPage({ user }) {
     return <div>{user.name}</div>
   }

   // NEW (Tanstack Start)
   import { createFileRoute } from '@tanstack/react-router'

   export const Route = createFileRoute('/users/$id')({
     loader: async ({ params, context }) => {
       const user = await fetchUser(params.id, context.cloudflare.env)
       return { user }
     },
     component: UserPage,
   })

   function UserPage() {
     const { user } = Route.useLoaderData()
     return <div>{user.name}</div>
   }
   ```

   **Vue component → React component**:

   ```tsx
   // OLD (Vue)
     <div class="card">
       <h2>{ title}</h2>
       <p>{ description}</p>
     </div>

   const props = defineProps<{
     title: string
     description: string
   }>()

   // NEW (React + shadcn/ui)
   import { Card, CardHeader, CardTitle, CardContent } from '@/components/ui/card'

   interface CardComponentProps {
     title: string
     description: string
   }

   export function CardComponent({ title, description }: CardComponentProps) {
     return (
       <Card>
         <CardHeader>
           <CardTitle>{title}</CardTitle>
         </CardHeader>
         <CardContent>
           <p>{description}</p>
         </CardContent>
       </Card>
     )
   }
   ```

5. **Phase 4: Setup State Management**

   **TanStack Query setup** (`src/lib/query-client.ts`):
   ```typescript
   import { QueryClient } from '@tanstack/react-query'

   export const queryClient = new QueryClient({
     defaultOptions: {
       queries: {
         staleTime: 60 * 1000, // 1 minute
       },
     },
   })
   ```

   **Zustand store** (`src/stores/ui-store.ts`):
   ```typescript
   import { create } from 'zustand'

   interface UIStore {
     sidebarOpen: boolean
     toggleSidebar: () => void
   }

   export const useUIStore = create<UIStore>((set) => ({
     sidebarOpen: false,
     toggleSidebar: () => set((state) => ({ sidebarOpen: !state.sidebarOpen })),
   }))
   ```

6. **Phase 5: Setup Cloudflare Bindings Context**

   Create `src/lib/cloudflare.ts`:
   ```typescript
   export interface Env {
     // PRESERVE from analysis report
     MY_KV: KVNamespace
     DB: D1Database
     MY_BUCKET: R2Bucket
   }
   ```

   Update `app.config.ts`:
   ```typescript
   import { defineConfig } from '@tanstack/start/config'

   export default defineConfig({
     server: {
       preset: 'cloudflare-module',
     },
   })
   ```

7. **Phase 6: Migrate Server Functions**

   ```typescript
   // src/routes/api/users.ts
   import { createAPIFileRoute } from '@tanstack/start/api'

   export const Route = createAPIFileRoute('/api/users')({
     GET: async ({ request, context }) => {
       const { env } = context.cloudflare

       // Access Cloudflare bindings
       const users = await env.DB.prepare('SELECT * FROM users').all()

       return Response.json(users)
     },
   })
   ```

8. **Phase 7: Install shadcn/ui Components**

   ```bash
   # Add commonly used components
   pnpx shadcn@latest add button card dialog form input label
   ```

9. **Phase 8: Update Package Scripts**

   Update `package.json`:
   ```json
   {
     "scripts": {
       "dev": "vinxi dev",
       "build": "vinxi build",
       "start": "vinxi start",
       "deploy": "wrangler deploy"
     }
   }
   ```

10. **Phase 9: Testing & Validation**

    ```bash
    # Run development server
    pnpm dev

    # Build for production
    pnpm build

    # Deploy to Cloudflare Workers
    wrangler deploy
    ```

### 6. Post-Migration Validation

<thinking>
Run comprehensive validation after migration is complete.
</thinking>

**Automated validation** (run in parallel):

1. **Task workers-runtime-guardian(migrated codebase)**
   - Verify no Node.js APIs introduced
   - Validate Workers runtime compatibility
   - Check bundle size (< 1MB recommended)

2. **Task binding-context-analyzer(new wrangler.jsonc)**
   - Verify all bindings preserved
   - Check binding types match Env interface
   - Validate `remote = true` on all bindings

3. **Task cloudflare-pattern-specialist(migrated codebase)**
   - Verify bindings accessed correctly via context
   - Check error handling patterns
   - Validate security patterns

4. **Run /es-validate**
   - Full validation suite
   - Check for anti-patterns
   - Verify design system compliance

### 7. Migration Report

<deliverable>
Final migration report with validation results and next steps
</deliverable>

```markdown
## Tanstack Start Migration Complete ✅

**Project**: [app-name]
**Migration**: [source] → Tanstack Start
**Date**: [timestamp]

### Migration Summary

**Routes migrated**: [X] / [X]
**Components converted**: [Y] / [Y]
**Server functions created**: [Z]
**Tests passing**: [All / Some / None]

### Validation Results

✅ Workers runtime compatibility verified
✅ All Cloudflare bindings preserved and functional
✅ Bundle size: [X]KB (target: < 1MB)
✅ No Node.js APIs detected
✅ Security patterns validated

### Performance Improvements

- Cold start time: [before] → [after]
- Bundle size: [before] → [after]
- Type safety: [improved with TanStack Router]

### Next Steps

1. [ ] Run full test suite: `pnpm test`
2. [ ] Deploy to preview: `wrangler deploy --env preview`
3. [ ] Verify all features work in preview
4. [ ] Deploy to production: `wrangler deploy --env production`
5. [ ] Monitor Workers metrics
6. [ ] Update documentation

### Files Changed

**Added**:
- [list new files]

**Modified**:
- [list modified files]

**Removed**:
- [list removed files]

### Rollback Plan

If issues arise:
```bash
git checkout main
git branch -D migrate-to-tanstack-start
wrangler rollback
```
```

## Framework-Specific Migration Patterns

### React/Next.js → Tanstack Start

**Complexity**: Low (same React ecosystem)

**Key mappings**:
- `pages/` → `src/routes/`
- `getServerSideProps` → Route `loader`
- `getStaticProps` → Route `loader` (cached)
- `api/` → `src/routes/api/` (server functions)
- `useEffect` + fetch → TanStack Query `useQuery`
- Context API → Zustand (for client state)

### React/Nuxt → Tanstack Start

**Complexity**: High (Vue to React conversion)

**Key mappings**:
- `{}` interpolation → `{}`
- `v-if` → `{condition && <Component />}`
- `v-for` → `.map()`
- `v-model` → `value` + `onChange`
- `defineProps` → TypeScript interface + props
- `ref()` / `reactive()` → `useState()` / `useReducer()`
- `computed()` → `useMemo()`
- `watch()` → `useEffect()`
- `useAsyncData` → TanStack Router `loader` + TanStack Query

### Vanilla JS → Tanstack Start

**Complexity**: Medium (adding full framework)

**Approach**:
1. Identify pages and routes
2. Convert HTML templates to React components
3. Convert event handlers to React patterns
4. Add type safety with TypeScript
5. Implement routing with TanStack Router
6. Add state management where needed

## Troubleshooting

### Common Issues

**Issue**: "Module not found: @tanstack/start"
**Solution**: Ensure you're using the correct package manager (pnpm recommended)

**Issue**: "wrangler.jsonc not recognized"
**Solution**: Update wrangler to latest version: `npm install -g wrangler@latest`

**Issue**: "Bindings not available in context"
**Solution**: Verify `app.config.ts` has correct preset: `preset: 'cloudflare-module'`

**Issue**: "Build fails with Workers runtime errors"
**Solution**: Check for Node.js APIs (fs, path, etc.) - use Workers alternatives

## Resources

- **Tanstack Start Docs**: https://tanstack.com/start/latest
- **TanStack Router Docs**: https://tanstack.com/router/latest
- **TanStack Query Docs**: https://tanstack.com/query/latest
- **shadcn/ui Docs**: https://ui.shadcn.com
- **Cloudflare Workers Docs**: https://developers.cloudflare.com/workers
- **Zustand Docs**: https://docs.pmnd.rs/zustand

## Success Metrics

Track these metrics before and after migration:

- ⚡ Cold start time (ms)
- 📦 Bundle size (KB)
- 🎯 Type safety coverage (%)
- 🚀 Lighthouse score
- 🔒 Security audit results
- 📊 Workers Analytics (requests/errors/latency)

---

**Remember**: This is a FRAMEWORK migration only. All Cloudflare infrastructure, bindings, and Workers configuration are preserved throughout the process.
