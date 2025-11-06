# User Preferences - Frank's Cloudflare Development Standards

This document codifies strong preferences for all agents in this plugin. These are **NOT suggestions** - they are **requirements** that agents MUST follow.

## Framework Preferences (STRICT)

### When to Use What

**Decision Tree**:
```
Does the project need a UI (now or future)?
├─ YES → Use Nuxt 4
└─ NO → Is it backend-only?
    ├─ YES → Use Hono
    └─ NO → Is it simple/minimal?
        └─ YES → Plain JavaScript/TypeScript (no framework)
```

### ✅ Approved Frameworks ONLY

1. **Nuxt 4** - For any project with UI or potential UI
   - Full-stack framework built on Vue 3
   - Works with Cloudflare Workers (not Pages - see below)
   - Official docs: https://nuxt.com

2. **Hono** - For backend-only Workers
   - Lightweight, fast, built for edge
   - Perfect for API-only projects
   - Official docs: https://hono.dev

3. **Plain TypeScript/JavaScript** - For simple projects
   - No framework overhead
   - Direct Workers fetch handler
   - Minimal dependencies

### ❌ FORBIDDEN Frameworks & Libraries

**NEVER suggest these**:

**Full-Stack Frameworks** (use Nuxt 4 instead):
- ❌ Next.js - React-based, we use Vue/Nuxt
- ❌ SvelteKit - Svelte-based, we use Vue/Nuxt
- ❌ Remix - React-based, we use Vue/Nuxt
- ❌ Astro - Multi-framework, we standardize on Nuxt

**Backend Frameworks** (use Hono instead):
- ❌ Express - Node.js only, NOT Workers-compatible
- ❌ Fastify - Node.js only, NOT Workers-compatible
- ❌ Koa - Node.js only, NOT Workers-compatible
- ❌ NestJS - Node.js only, NOT Workers-compatible

**UI Libraries** (use Vue 3/Nuxt instead):
- ❌ React - We use Vue 3 (via Nuxt)
- ❌ Preact - We use Vue 3 (via Nuxt)
- ❌ Svelte - We use Vue 3 (via Nuxt)
- ❌ Solid.js - We use Vue 3 (via Nuxt)

**Reasoning**:
- Nuxt 4 (Vue) and Hono are the ONLY frameworks/libraries that fit Frank's workflow
- Express/Fastify/Koa are Node.js frameworks - they DON'T work in Workers runtime
- Next.js/React are different ecosystems - we standardize on Vue/Nuxt
- Do not suggest alternatives, ever

## UI/CSS Preferences (STRICT)

### ✅ Approved UI Stack ONLY

1. **Nuxt UI Library** - Component library (REQUIRED for UI projects)
   - Built on Headless UI and Tailwind CSS
   - Official docs: https://ui.nuxt.com

2. **Tailwind 4 CSS** - Utility-first CSS (REQUIRED for styling)
   - Latest version with CSS variables
   - Official docs: https://tailwindcss.com/docs/v4-beta

### ❌ FORBIDDEN CSS Approaches

**NEVER suggest**:
- ❌ Custom CSS files (use Tailwind utilities)
- ❌ CSS modules
- ❌ Styled-components or CSS-in-JS
- ❌ SASS/SCSS
- ❌ Other UI libraries (Material UI, Ant Design, Chakra, etc.)

**Reasoning**: Frank does NOT want to write custom CSS. Tailwind utilities + Nuxt UI components only.

### Correct UI Pattern

```vue
<!-- ✅ CORRECT: Nuxt UI + Tailwind utilities -->
<template>
  <UCard class="max-w-md mx-auto">
    <UButton color="primary" size="lg">
      Click me
    </UButton>
  </UCard>
</template>

<!-- ❌ WRONG: Custom CSS -->
<style>
.custom-button {
  background: blue;
  padding: 1rem;
}
</style>
```

## Development Workflow (CRITICAL)

### ✅ REQUIRED: Always Use Remote Bindings

**NEVER use local/simulated bindings** for development:

- ❌ NOT: `wrangler dev` with default local bindings
- ❌ NOT: `wrangler dev --local` (explicit local mode)
- ❌ NOT: `wrangler dev --remote` (legacy flag approach)
- ✅ YES: Configure `remote = true` per binding in wrangler.toml

**Rationale**:
- Local bindings don't match production behavior
- Remote bindings (GA since Sept 2025) connect to real Cloudflare resources
- Test against actual data and services during development
- Catch binding configuration issues early

**Correct Configuration** (wrangler.toml):
```toml
name = "my-app"
main = "src/index.ts"
compatibility_date = "2025-09-15"  # ALWAYS 2025-09-15 or later

# KV with remote binding (connects to real KV)
[[kv_namespaces]]
binding = "MY_KV"
id = "your-kv-namespace-id"
remote = true  # ← REQUIRED for development

# D1 with remote binding (connects to real D1)
[[d1_databases]]
binding = "DB"
database_name = "my-database"
database_id = "your-database-id"
remote = true  # ← REQUIRED for development

# R2 with remote binding (connects to real R2)
[[r2_buckets]]
binding = "MY_BUCKET"
bucket_name = "my-bucket"
remote = true  # ← REQUIRED for development

# Durable Objects (remote works automatically)
[[durable_objects.bindings]]
name = "MY_DO"
class_name = "MyDurableObject"
script_name = "my-worker"
```

**Then run**:
```bash
wrangler dev  # No flags needed - remote bindings configured in toml
```

**Benefits**:
- ✅ Worker runs locally (fast iteration)
- ✅ Bindings proxy to Cloudflare edge (real data)
- ✅ Mix local/remote per binding (granular control)
- ✅ Configuration in version control (explicit)

### 🔄 Compatibility Date (STRICT)

**ALWAYS use `compatibility_date = "2025-09-15"` or later**:

```toml
compatibility_date = "2025-09-15"  # Minimum for remote bindings GA
```

**Why**:
- Remote bindings GA requires 2025-09-15+
- Gets latest Workers runtime features
- Ensures modern API compatibility
- Forward-looking configuration

**If existing project has older date**: Update to 2025-09-15 or later (safe, opt-in to new features).

### 📦 Package Manager: pnpm ONLY (STRICT)

**ALWAYS use pnpm** (NOT npm or yarn):

```bash
# ❌ NEVER use npm
npm install
npm run dev

# ❌ NEVER use yarn
yarn install
yarn dev

# ✅ ALWAYS use pnpm
pnpm install
pnpm dev
```

**Rationale**:
- ✅ Faster installation (shared dependency cache)
- ✅ More efficient disk usage (content-addressable storage)
- ✅ Stricter dependency resolution (no phantom dependencies)
- ✅ Better monorepo support
- ✅ Consistent lockfile format

**In Documentation**:
```markdown
# ❌ DON'T
npm install

# ✅ DO
pnpm install
```

### 📦 Scripts Documentation (STRICT)

**ALWAYS document script shorthands in package.json**:

```json
{
  "scripts": {
    "dev": "wrangler dev",
    "build": "wrangler deploy --dry-run",
    "deploy": "wrangler deploy",
    "deploy:staging": "wrangler deploy --env staging",
    "deploy:production": "wrangler deploy --env production",
    "test": "vitest",
    "typecheck": "tsc --noEmit",
    "lint": "eslint .",
    "types:generate": "wrangler types",
    "db:migrate": "wrangler d1 migrations apply DB",
    "db:migrate:local": "wrangler d1 migrations apply DB --local"
  }
}
```

**Rationale**:
- ✅ Easier to remember and type (`pnpm dev` vs `wrangler dev`)
- ✅ Documentation lives in codebase (package.json is single source of truth)
- ✅ Consistent across projects (everyone uses same commands)
- ✅ Can add flags/options without memorizing them
- ✅ Works with `pnpm run` tab completion

**Common Scripts to Include**:
- `dev` - Start development server
- `build` - Build for production (dry-run)
- `deploy` - Deploy to production
- `deploy:staging` - Deploy to staging environment
- `test` - Run tests
- `typecheck` - TypeScript checking
- `lint` - Linting
- `types:generate` - Generate TypeScript types for bindings

**In Documentation**:
```markdown
# ❌ DON'T write raw commands
Run: wrangler dev

# ✅ DO use pnpm scripts
Run: pnpm dev
```

## Deployment Preferences (CRITICAL)

### ✅ Workers with Static Assets (ONLY)

**REQUIRED**: Use Cloudflare Workers for ALL deployments

- Workers can serve static assets (HTML, CSS, JS, images)
- Best practices per Cloudflare (2024+)
- Migration guide: https://developers.cloudflare.com/workers/static-assets/migration-guides/migrate-from-pages/

### ❌ FORBIDDEN: Cloudflare Pages

**NEVER suggest Cloudflare Pages** for new projects:

- Cloudflare no longer recommends Pages for new projects
- Workers with static assets is the new standard
- Pages is legacy (maintained but not recommended)

**wrangler.toml configuration** (Workers with static assets):
```toml
name = "my-app"
compatibility_date = "2025-09-15"  # ALWAYS 2025-09-15 or later

# For Nuxt 4 projects
[site]
bucket = ".output/public"

# For static files
assets = { directory = "public" }
```

**If user says "deploy to Pages"**: Correct them and explain Workers is the modern approach.

## Code Organization & Style (CRITICAL)

### 📄 File Size Limit (STRICT)

**ALWAYS keep files under 500 lines of code** for optimal AI code generation:

```
# ❌ BAD: Single large file
src/
  utils.ts  # 1200 LOC - too large!

# ✅ GOOD: Split into focused modules
src/utils/
  validation.ts  # 150 LOC
  formatting.ts  # 120 LOC
  api.ts  # 180 LOC
  dates.ts  # 90 LOC
```

**Rationale**:
- ✅ Better for AI code generation (context window limits)
- ✅ Easier to reason about and maintain
- ✅ Encourages modular, focused code
- ✅ Improves code review process
- ✅ Reduces merge conflicts

**When file exceeds 500 LOC**:
1. Identify logical groupings
2. Split into separate files by responsibility
3. Use clear, descriptive file names
4. Keep related files in same directory
5. Use index.ts for clean exports (if needed)

**Example Split**:
```typescript
// ❌ BAD: mega-utils.ts (800 LOC)
export function validateEmail() { ... }
export function validatePhone() { ... }
export function formatDate() { ... }
export function formatCurrency() { ... }
export function fetchUser() { ... }
export function fetchPost() { ... }

// ✅ GOOD: Split by responsibility
// utils/validation.ts (200 LOC)
export function validateEmail() { ... }
export function validatePhone() { ... }

// utils/formatting.ts (150 LOC)
export function formatDate() { ... }
export function formatCurrency() { ... }

// api/users.ts (180 LOC)
export function fetchUser() { ... }

// api/posts.ts (220 LOC)
export function fetchPost() { ... }
```

**Component Files**:
- Vue/Nuxt components: < 300 LOC preferred
- If larger, split into sub-components
- Use composition API composables for logic reuse

**Configuration Files**:
- wrangler.toml: Keep concise, well-commented
- nuxt.config.ts: < 200 LOC (extract plugins/modules if needed)

## SDK Preferences (STRICT)

### ✅ Approved SDKs ONLY

1. **Vercel AI SDK** - For all AI/LLM work (REQUIRED)
   - Universal AI SDK (works with any model)
   - Streaming, structured output, tool calling
   - Official docs: https://sdk.vercel.ai/docs/introduction
   - Example:
   ```typescript
   import { generateText } from 'ai';
   import { anthropic } from '@ai-sdk/anthropic';

   const { text } = await generateText({
     model: anthropic('claude-3-5-sonnet-20241022'),
     prompt: 'Explain Cloudflare Workers'
   });
   ```

2. **Cloudflare AI Agents** - For agentic workflows (REQUIRED for agents)
   - Built specifically for Workers
   - Official docs: https://developers.cloudflare.com/agents/
   - Example:
   ```typescript
   import { Agent } from '@cloudflare/ai-agents';

   const agent = new Agent({
     model: '@cf/meta/llama-3-8b-instruct',
     tools: [...]
   });
   ```

### ❌ FORBIDDEN SDKs

**NEVER suggest these** (use Vercel AI SDK instead):

- ❌ LangChain (use Vercel AI SDK instead)
- ❌ Direct OpenAI SDK (use Vercel AI SDK with OpenAI provider)
- ❌ Direct Anthropic SDK (use Vercel AI SDK with Anthropic provider)
- ❌ LlamaIndex (use Vercel AI SDK instead)

**Reasoning**: Vercel AI SDK is framework-agnostic and provides better DX. Cloudflare AI Agents for agentic work.

## Integration Rules

### When User Asks for...

**"I want to build a chat app"**:
- ✅ Framework: Nuxt 4 (has UI)
- ✅ UI: Nuxt UI components + Tailwind utilities
- ✅ AI: Vercel AI SDK with streaming
- ✅ Deploy: Workers with static assets

**"I want to build an API"**:
- ✅ Framework: Hono (backend-only)
- ✅ Deploy: Workers
- ✅ AI (if needed): Vercel AI SDK or Cloudflare AI Agents

**"I want to add AI to my app"**:
- ✅ SDK: Vercel AI SDK (for completions, embeddings, etc.)
- ✅ Agents: Cloudflare AI Agents (for agentic workflows)
- ❌ NOT: LangChain, direct model SDKs

**"I want to style this component"**:
- ✅ Nuxt UI component (check docs first)
- ✅ Tailwind utilities (for customization)
- ❌ NOT: Custom CSS, styled-components

**"Let's deploy to Pages"**:
- ❌ STOP and correct: "Cloudflare recommends Workers with static assets for new projects"
- ✅ Guide them to Workers deployment

## Enforcement

All agents MUST:
1. Check this PREFERENCES.md before suggesting frameworks
2. NEVER suggest forbidden frameworks/SDKs
3. ALWAYS suggest approved frameworks/SDKs
4. Correct user if they mention forbidden approaches
5. Explain WHY (Cloudflare best practices, Frank's workflow)

## Recommended MCP Servers

For best results, configure these official MCP servers in Claude Code settings:

### 1. Cloudflare MCP (ESSENTIAL)

**URL**: https://docs.mcp.cloudflare.com/mcp

**Provides**:
- Documentation search (query official Cloudflare docs)
- Bindings management (real account state, not just wrangler.toml)
- Observability (performance metrics, monitoring)
- DNS Analytics (configuration and performance)

**Why essential**:
- ✅ Agents can check YOUR actual Cloudflare bindings
- ✅ Prevents suggesting duplicate namespaces
- ✅ Always uses latest Cloudflare documentation
- ✅ Performance recommendations based on real data

**Setup**:
```json
{
  "mcpServers": {
    "cloudflare-docs": {
      "type": "remote",
      "url": "https://docs.mcp.cloudflare.com/mcp",
      "enabled": true
    }
  }
}
```

Requires Cloudflare OAuth authentication.

### 2. Nuxt UI MCP (HIGHLY RECOMMENDED)

**URL**: https://ui.nuxt.com/mcp

**Provides**:
- Component documentation (UButton, UCard, etc.)
- Composables documentation
- Code examples
- Component implementation generator

**Why essential** (given our preferences):
- ✅ Ensures accurate Nuxt UI component props (no hallucination)
- ✅ Generates correct component usage
- ✅ Aligns with "no custom CSS" preference (uses Nuxt UI components)
- ✅ Always up-to-date with latest Nuxt UI version

**Setup**:
```json
{
  "mcpServers": {
    "nuxt-ui": {
      "type": "remote",
      "url": "https://ui.nuxt.com/mcp",
      "enabled": true
    }
  }
}
```

No authentication required (public server).

**See MCP-INTEGRATION.md for complete integration strategy and agent workflows.**

## feedback-codifier Instructions

When learning from user feedback:

**Valid patterns to codify**:
- ✅ Nuxt 4 usage patterns
- ✅ Hono routing patterns
- ✅ Nuxt UI component patterns
- ✅ Tailwind utility combinations
- ✅ Vercel AI SDK patterns
- ✅ Cloudflare AI Agents patterns

**INVALID patterns (reject)**:
- ❌ Any Next.js, Express, or forbidden framework
- ❌ Any custom CSS writing
- ❌ Any Cloudflare Pages deployment
- ❌ Any LangChain or forbidden SDK usage

If user provides feedback using forbidden tools, ask: "Are you working on a legacy project? These preferences are for new projects only."

## Version

This preferences document was created: 2025-01-05

As Cloudflare best practices evolve, this document will be updated. Agents should always follow the latest version.
