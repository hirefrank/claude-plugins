# Cloudflare Workers Framework Migration to Nuxt 4

<command_purpose> Migrate existing Cloudflare Workers applications from any frontend framework (Vue 2/3, Nuxt 2/3, React, Svelte, vanilla JS) to Nuxt 4. Preserves all Cloudflare infrastructure (Workers, bindings, wrangler.toml) while modernizing the application layer. </command_purpose>

## Introduction

<role>Framework Migration Specialist focusing on Nuxt 4 migrations for Cloudflare Workers applications</role>

This command analyzes your existing Cloudflare Workers application, identifies the current framework, and creates a comprehensive migration plan to Nuxt 4 while preserving all Cloudflare infrastructure.

## Prerequisites

<requirements>
- Existing Cloudflare Workers application (already deployed)
- Cloudflare account with existing bindings (KV/D1/R2/DO)
- wrangler CLI installed (`npm install -g wrangler`)
- Git repository for tracking migration
- Node.js 18+ (for Nuxt 4)
</requirements>

## Migration Source

<migration_source> #$ARGUMENTS </migration_source>

**Source frameworks supported**:
- Vue 2 / Vue 3 (Options API or Composition API)
- Nuxt 2 / Nuxt 3 (migration to Nuxt 4)
- React / Next.js (will convert to Vue 3)
- Svelte / SvelteKit (will convert to Vue 3)
- Vanilla JavaScript (will add Vue 3 structure)
- jQuery-based apps
- Custom frameworks

**Target**: Nuxt 4 (Vue 3 Composition API) with Cloudflare Workers

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

   # Vue/Nuxt
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
   # Redux
   grep -r "createStore\|configureStore" src/ 2>/dev/null

   # Vuex
   grep -r "createStore\|new Vuex.Store" src/ store/ 2>/dev/null

   # Context API
   grep -r "createContext\|useContext" src/ 2>/dev/null

   # Pinia
   grep -r "defineStore" src/ stores/ 2>/dev/null
   ```

4. **Identify UI dependencies**
   ```bash
   # Check for UI frameworks
   jq '.dependencies + .devDependencies | keys[]' package.json | grep -E "bootstrap|material-ui|antd|chakra"
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
**Current Framework**: [React / Vue 2 / Nuxt 2 / etc.]
**Target Framework**: Nuxt 4 (Vue 3 Composition API)
**Cloudflare Deployment**: ✅ Already on Workers

### Current Application Inventory

**Pages/Routes**: [X] routes detected
- [List key routes]

**Components**: [Y] components detected
- Shared: [count]
- Page-specific: [count]

**State Management**: [Redux / Vuex / Context / Pinia / None]
**UI Dependencies**: [Bootstrap / Material UI / Custom CSS / None]

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
  - Vue → Vue 3: Low (same paradigm)
  - React → Vue 3: High (different paradigm)
  - Vanilla → Vue 3: Medium (adding framework)
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
Use the nuxt-migration-specialist agent and supporting agents to create
a comprehensive migration plan.
</thinking>

#### Phase 1: Framework-Specific Analysis

1. **Task nuxt-migration-specialist(current framework and structure)**
   - Analyze source framework patterns
   - Map components to Nuxt 4 + Nuxt UI equivalents
   - Plan routing migration (pages/ structure)
   - Recommend state management approach (Pinia vs composables)
   - Design API strategy (Nuxt server routes vs separate backend)
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
   - Assess if Nuxt server routes can replace existing API

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
Detailed Nuxt 4 migration plan with step-by-step instructions
</deliverable>

<critical_requirement> Present complete migration plan for user approval before starting any code changes. </critical_requirement>

The nuxt-migration-specialist agent will generate a comprehensive plan including:

**Component Migration Plan**:
| Old Component | New Component (Nuxt UI) | Effort | Notes |
|--------------|------------------------|--------|-------|
| `<Button>` | `<UButton>` | Low | Direct mapping |
| `<UserCard>` | `<UCard>` + custom | Medium | Restructure children |

**Route Migration Plan**:
| Old Route | New File | Dynamic | Notes |
|----------|---------|---------|-------|
| `/` | `pages/index.vue` | No | Home |
| `/users/:id` | `pages/users/[id].vue` | Yes | Detail |

**State Management Strategy**:
- Current: [Redux / Vuex / etc.]
- Target: [Pinia / composables]
- Migration approach: [Details]

**API Strategy**:
- Current: [Express / Hono / Next.js API]
- Recommendation: [Nuxt server routes / Keep separate]
- Rationale: [Why]

**Styling Strategy**:
- Current: [Bootstrap / Material UI / Custom CSS]
- Target: Nuxt UI + Tailwind 4
- Migration: [Component-by-component replacement]

**Implementation Phases**:
1. Setup Nuxt 4 project
2. Configure Workers adapter
3. Migrate layouts
4. Migrate pages (priority order)
5. Migrate components
6. Setup state management
7. Migrate API routes (if applicable)
8. Replace UI with Nuxt UI + Tailwind 4
9. Update wrangler.toml for Nuxt output
10. Test & deploy

### 4. User Approval & Confirmation

<critical_requirement> MUST get explicit user approval before proceeding with any code changes. </critical_requirement>

**Present the migration plan and ask**:

```
📋 Nuxt 4 Migration Plan Complete

Summary:
- Source framework: [React / Vue 2 / etc.]
- Target: Nuxt 4 (Vue 3 Composition API)
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
1. yes - Start Phase 1 (Setup Nuxt 4)
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
   git checkout -b nuxt4-migration
   ```

2. **Phase 1: Setup Nuxt 4**

   ```bash
   # Initialize Nuxt 4 (in temporary directory to avoid conflicts)
   mkdir -p temp-nuxt
   cd temp-nuxt
   npx nuxi@latest init .

   # Copy generated files to project root
   cd ..
   cp temp-nuxt/nuxt.config.ts .
   cp temp-nuxt/app.vue .
   mkdir -p pages components layouts middleware

   # Install Nuxt UI
   npm install @nuxt/ui

   # Install Tailwind 4 (if not included)
   npm install tailwindcss@next @tailwindcss/postcss@next

   # Clean up temp directory
   rm -rf temp-nuxt
   ```

3. **Phase 2: Configure Workers Adapter**

   Update `nuxt.config.ts`:
   ```typescript
   export default defineNuxtConfig({
     compatibilityDate: '2025-09-15',

     modules: [
       '@nuxt/ui',
     ],

     nitro: {
       preset: 'cloudflare-pages',  // Use Pages preset for Workers
       rollupConfig: {
         external: ['node:async_hooks']
       }
     },

     vite: {
       define: {
         'process.env.NODE_ENV': JSON.stringify(process.env.NODE_ENV)
       }
     }
   });
   ```

   Update `wrangler.toml` (preserve existing bindings):
   ```toml
   name = "my-app"
   main = ".output/server/index.mjs"  # Nuxt build output
   compatibility_date = "2025-09-15"

   # Nuxt static assets
   [site]
   bucket = ".output/public"

   # EXISTING BINDINGS (PRESERVED - DO NOT DELETE)
   [[kv_namespaces]]
   binding = "MY_KV"
   id = "existing-id"
   remote = true

   [[d1_databases]]
   binding = "DB"
   database_name = "existing-db"
   database_id = "existing-id"
   remote = true

   # ... (keep all existing bindings)
   ```

4. **Phase 3: Migrate Components**

   For each component, convert to Vue 3:

   **Example: React → Vue 3**
   ```jsx
   // ❌ OLD: React Component (components/Button.jsx)
   function Button({ onClick, children }) {
     return (
       <button className="btn-primary" onClick={onClick}>
         {children}
       </button>
     );
   }
   ```

   ```vue
   <!-- ✅ NEW: Vue 3 Component (components/Button.vue) -->
   <script setup>
   defineProps({
     onClick: Function
   });
   </script>

   <template>
     <UButton color="primary" @click="onClick">
       <slot />
     </UButton>
   </template>
   ```

5. **Phase 4: Migrate Pages**

   Convert routing structure:

   ```
   # React/Next.js        →  Nuxt 4
   pages/index.jsx       →  pages/index.vue
   pages/about.jsx       →  pages/about.vue
   pages/users/[id].jsx  →  pages/users/[id].vue
   ```

6. **Phase 5: Migrate State Management**

   If Redux → Pinia:
   ```javascript
   // ❌ OLD: Redux (store/index.js)
   const store = createStore(reducer);
   ```

   ```typescript
   // ✅ NEW: Pinia (stores/main.ts)
   export const useMainStore = defineStore('main', {
     state: () => ({ count: 0 }),
     actions: {
       increment() { this.count++; }
     }
   });
   ```

7. **Phase 6: Migrate API Routes** (if simple)

   If existing backend is simple (< 5 routes):
   ```typescript
   // ❌ OLD: Express/Hono route
   app.get('/api/users', async (c) => {
     const users = await c.env.DB.prepare('SELECT * FROM users').all();
     return c.json(users.results);
   });
   ```

   ```typescript
   // ✅ NEW: Nuxt server route (server/api/users.get.ts)
   export default defineEventHandler(async (event) => {
     const env = event.context.cloudflare.env;
     const users = await env.DB.prepare('SELECT * FROM users').all();
     return users.results;
   });
   ```

   If existing backend is complex (many routes):
   - ✅ KEEP Hono/Express backend as separate Worker
   - ✅ Use service bindings (Nuxt → Backend Worker)

8. **Phase 7: Replace UI with Nuxt UI**

   Convert all UI components to Nuxt UI:
   ```vue
   <!-- ❌ OLD: Bootstrap -->
   <div class="card">
     <div class="card-body">
       <button class="btn btn-primary">Click</button>
     </div>
   </div>

   <!-- ✅ NEW: Nuxt UI -->
   <UCard>
     <UButton color="primary">Click</UButton>
   </UCard>
   ```

9. **Phase 8: Update package.json Scripts**

   ```json
   {
     "scripts": {
       "dev": "nuxt dev",
       "build": "nuxt build",
       "preview": "nuxt preview",
       "deploy": "npm run build && wrangler deploy",
       "deploy:staging": "npm run build && wrangler deploy --env staging",
       "typecheck": "nuxt typecheck",
       "lint": "eslint ."
     }
   }
   ```

### 6. Testing & Validation

**Local testing**:
```bash
# Build Nuxt for production
npm run build

# Test with wrangler dev (remote bindings)
npm run dev
# Or: wrangler dev --remote (legacy, but works)

# Test all routes
curl http://localhost:3000/
curl http://localhost:3000/api/users
```

**Agent validation**:

Run agents on migrated code:

- Task workers-runtime-guardian(migrated code)
  - MUST be CRITICAL-free (no Node.js APIs)

- Task binding-context-analyzer(migrated code)
  - All bindings properly used in server routes
  - TypeScript Env interface accurate

- Task cloudflare-pattern-specialist(migrated code)
  - Workers patterns followed
  - Binding usage follows best practices

- Task nuxt-migration-specialist(migrated code)
  - Verify all components migrated
  - Verify all routes functional
  - Verify state management working
  - Verify Nuxt UI + Tailwind 4 used (no custom CSS)

### 7. Deployment

**Deploy to staging**:
```bash
npm run deploy:staging
```

**Validate staging**:
- [ ] All routes return 200 OK
- [ ] All Cloudflare bindings work (KV/D1/R2/DO)
- [ ] State management functional
- [ ] UI renders correctly (Nuxt UI components)
- [ ] No console errors

**Deploy to production**:
```bash
npm run deploy:production
```

### 8. Migration Completion Report

<deliverable>
Final report with migration results and next steps
</deliverable>

```markdown
# ✅ Nuxt 4 Migration Complete

**Project**: [app-name]
**Migration Date**: [timestamp]
**Source Framework**: [React / Vue 2 / etc.]
**Target Framework**: Nuxt 4 (Vue 3 Composition API)

## Migration Summary

**Components Migrated**: [X] components
- All converted to Vue 3 Composition API
- All UI replaced with Nuxt UI components
- Zero custom CSS (Tailwind 4 only)

**Routes Migrated**: [Y] routes
- File-based routing structure
- Dynamic routes working ([id].vue patterns)
- All routes tested and functional

**State Management**:
- Migrated from: [Redux / Vuex / etc.]
- Now using: [Pinia / composables]
- Status: ✅ Functional

**API Strategy**:
- [Migrated to Nuxt server routes / Kept separate backend]
- [If separate: Service bindings configured]

**Cloudflare Bindings** (PRESERVED ✅):
- KV: [count] namespaces - All functional
- D1: [count] databases - All functional
- R2: [count] buckets - All functional
- DO: [count] classes - All functional

## Performance Comparison

| Metric | Before | After | Change |
|--------|--------|-------|--------|
| Bundle Size | [X]KB | [Y]KB | [+/-Z]% |
| First Load | [X]ms | [Y]ms | [+/-Z]% |
| Routes | [X] | [Y] | Same |

## Deployment URLs

**Staging**: https://my-app-staging.workers.dev
**Production**: https://my-app.workers.dev

## Post-Migration Tasks

**Immediate**:
- [ ] Monitor error rates (first 24 hours)
- [ ] Validate all user flows
- [ ] Check Cloudflare Analytics
- [ ] Verify binding usage (KV/D1/R2/DO ops)

**Short-term** (next week):
- [ ] Optimize bundle size (if > 500KB)
- [ ] Add more Nuxt UI components
- [ ] Implement SSR optimizations
- [ ] Add meta tags (SEO)

**Long-term** (next month):
- [ ] Migrate additional features to Nuxt patterns
- [ ] Optimize for Workers-specific features
- [ ] Implement edge caching strategies
- [ ] Add progressive enhancement

## Code Quality

**TypeScript**: ✅ Fully typed
**Linting**: ✅ Passes
**Tests**: [X] tests passing
**Bundle**: [Y]KB (target < 500KB)

## Success Criteria

- [✅/❌] All routes functional in Nuxt 4
- [✅/❌] All Cloudflare bindings working
- [✅/❌] No custom CSS (Nuxt UI + Tailwind only)
- [✅/❌] State management functional
- [✅/❌] Performance equal or better
- [✅/❌] Zero runtime errors

**Migration Status**: [✅ COMPLETE / ⚠️ NEEDS ATTENTION]

## Next Steps

1. [Recommended action 1]
2. [Recommended action 2]
3. [Recommended action 3]
```

## Framework-Specific Migration Guides

### React/Next.js → Nuxt 4

**Key Differences**:
- JSX → Vue Templates
- `useState` → `ref()`
- `useEffect` → `watch()` or `watchEffect()`
- `useContext` → Pinia or `provide()/inject()`
- React Router → File-based routing
- CSS Modules → Nuxt UI + Tailwind 4

**Common Pitfalls**:
- ❌ Trying to use React hooks in Vue
- ❌ JSX syntax in Vue templates
- ❌ Forgetting `.value` on refs

### Vue 2 → Nuxt 4

**Key Changes**:
- Options API → Composition API
- Vuex → Pinia or `useState()`
- `this.$axios` → `$fetch` or `useFetch()`
- Vue Router → Nuxt file-based routing
- `asyncData/fetch` → `useFetch()` or `useAsyncData()`

### Nuxt 2 → Nuxt 4

**Key Changes**:
- Bridge to Nuxt 3 patterns first
- `nuxt.config.js` → `nuxt.config.ts`
- Directory structure mostly same
- Auto-imports for composables
- `@nuxtjs/axios` → Native `$fetch`

### Vanilla JS → Nuxt 4

**Adding Framework**:
- Manual DOM → Vue reactivity
- No routing → Nuxt file-based routing
- Spaghetti code → Structured components
- No state management → Pinia or composables

## Best Practices

### Do's ✅

- **Preserve Cloudflare infrastructure**: Never change wrangler.toml bindings
- **Use Nuxt UI**: Replace all UI components with Nuxt UI equivalents
- **No custom CSS**: Use Tailwind 4 utilities only
- **Test incrementally**: Test each page/component after migration
- **Keep backend separate** (if complex): Don't force complex APIs into Nuxt server routes
- **Use npm scripts**: Document all commands in package.json
- **Remote bindings**: Set `remote = true` on all bindings for dev

### Don'ts ❌

- **Don't change bindings**: This is framework migration, not platform migration
- **Don't write custom CSS**: Use Nuxt UI + Tailwind only
- **Don't over-migrate**: Keep complex backends as separate Workers
- **Don't skip TypeScript**: Use full type safety
- **Don't forget compatibility_date**: Always use 2025-09-15+

## Troubleshooting

**Issue**: "Module not found" errors during build
**Solution**: Check Nuxt 4 auto-imports, may need explicit imports

**Issue**: Cloudflare bindings not accessible in pages
**Solution**: Use server routes (`server/api/`) to access bindings

**Issue**: Styles not working
**Solution**: Ensure Nuxt UI module installed, Tailwind 4 configured

**Issue**: Routes not found (404)
**Solution**: Check `pages/` structure, ensure file-based routing correct

**Issue**: State not persisting
**Solution**: Use Pinia with proper persistence or `useState()` with keys

## Success Metrics

Track these to measure migration success:

**Code Quality**:
- ✅ Zero custom CSS files
- ✅ All components use Nuxt UI
- ✅ TypeScript with no `any` types
- ✅ Bundle size < 500KB

**Functionality**:
- ✅ All routes working
- ✅ All bindings functional
- ✅ State management working
- ✅ No runtime errors

**Performance**:
- ✅ First load < 2 seconds
- ✅ Route transitions < 200ms
- ✅ API responses < 100ms P95

---

**Remember**: This is a framework migration. Your Cloudflare Workers infrastructure (bindings, configuration, deployment) stays exactly the same. We're only modernizing the application framework to Nuxt 4.
