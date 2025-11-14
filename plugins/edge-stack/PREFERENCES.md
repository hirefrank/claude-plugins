# User Preferences - Edge Stack Development Standards

This document codifies strong preferences for all agents in this plugin. These are **NOT suggestions** - they are **requirements** that agents MUST follow.

## Framework Preferences (STRICT)

### When to Use What

**Decision Tree**:
```
Does the project need a UI?
├─ YES → Use Tanstack Start (React + TanStack Router)
│   - Modern React 19 patterns
│   - Type-safe server functions
│   - Full-stack with Cloudflare Workers
│   - Official Cloudflare partnership
│
└─ NO (Backend-only) → Use Hono
    - Lightweight, edge-native
    - Perfect for API-only projects
```

**IMPORTANT**: All projects grow over time. Even "simple" projects should use a framework from the start.

**Note**: For existing Nuxt projects, use the separate `nuxt-stack` local plugin.

### ✅ Approved Frameworks ONLY

1. **Tanstack Start** - For UI projects
   - React 19 + TanStack Router + Vite
   - Full-stack with type-safe server functions
   - Official Cloudflare Workers support
   - Official docs: https://tanstack.com/start/latest
   - MCP server: shadcn/ui (official) - `npx -y mcp-remote https://www.shadcn.io/api/mcp`

2. **Hono** - For backend-only Workers
   - Lightweight, fast, built for edge
   - Perfect for API-only projects
   - Official docs: https://hono.dev
   - Documentation: https://hono.dev/docs

3. **Plain TypeScript/JavaScript** - For minimal Workers
   - Direct Workers fetch handler
   - No framework overhead
   - Documentation: https://developers.cloudflare.com/workers/runtime-apis/handlers/fetch/

### ❌ FORBIDDEN Frameworks & Libraries

**NEVER suggest these**:

**Full-Stack Frameworks** (use Tanstack Start instead):
- ❌ Next.js - Use Tanstack Start instead (both React, but Tanstack is our standard)
- ❌ Remix - Use Tanstack Start instead (better Cloudflare integration)
- ❌ SvelteKit - Migrate to Tanstack Start
- ❌ Astro - Use Tanstack Start instead
- ❌ Nuxt - Use nuxt-stack local plugin for existing Nuxt projects

**Backend Frameworks** (use Hono instead):
- ❌ Express - Node.js only, NOT Workers-compatible
- ❌ Fastify - Node.js only, NOT Workers-compatible
- ❌ Koa - Node.js only, NOT Workers-compatible
- ❌ NestJS - Node.js only, NOT Workers-compatible

**Standalone UI Libraries** (must use within approved frameworks):
- ❌ Standalone React - Use via Tanstack Start ONLY
- ❌ Standalone Vue - Not supported (use nuxt-stack plugin if needed)
- ❌ Preact - Not supported
- ❌ Svelte - Not supported
- ❌ Solid.js - Not supported

**Reasoning**:
- Tanstack Start is the ONLY full-stack framework for UI projects
- React is allowed ONLY via Tanstack Start (maintains consistency)
- Express/Fastify/Koa are Node.js frameworks - they DON'T work in Workers runtime
- Tanstack Start works excellently with Cloudflare Workers (official partnership)
- Do not suggest alternatives, ever

## UI/CSS Preferences (STRICT)

### ✅ Approved UI Stack ONLY

1. **shadcn/ui** - Component library (REQUIRED)
   - Built on Radix UI primitives + Tailwind CSS
   - Copy-paste components (full control)
   - Official docs: https://ui.shadcn.com
   - MCP server: `npx -y mcp-remote https://www.shadcn.io/api/mcp`

2. **Radix UI** - Low-level primitives (when shadcn/ui isn't enough)
   - Unstyled, accessible components
   - Official docs: https://www.radix-ui.com
   - Documentation: https://www.radix-ui.com/primitives/docs/overview/introduction

3. **Tailwind 4 CSS** - Utility-first CSS (REQUIRED for styling)
   - Latest version with CSS variables
   - Official docs: https://tailwindcss.com/docs/v4-beta
   - Documentation: https://tailwindcss.com/docs

### ❌ FORBIDDEN CSS Approaches

**NEVER suggest**:
- ❌ Custom CSS files (use Tailwind utilities)
- ❌ CSS modules
- ❌ Styled-components or CSS-in-JS
- ❌ SASS/SCSS
- ❌ Other UI libraries (Material UI, Ant Design, Chakra, Park UI, etc.)

**Reasoning**: Frank does NOT want to write custom CSS. Tailwind utilities + shadcn/ui components only.

### Correct UI Pattern

```tsx
// ✅ CORRECT: shadcn/ui + Tailwind utilities
import { Button } from "@/components/ui/button"
import { Card, CardContent } from "@/components/ui/card"

export function MyComponent() {
  return (
    <Card className="max-w-md mx-auto">
      <CardContent>
        <Button size="lg" variant="default">
          Click me
        </Button>
      </CardContent>
    </Card>
  )
}

// ❌ WRONG: Custom CSS
const styles = {
  customButton: {
    background: 'blue',
    padding: '1rem'
  }
}
```

## State Management Preferences (STRICT)

### ✅ Approved State Management Libraries

**Server State** (data fetching, caching, synchronization):
1. **TanStack Query** - REQUIRED for server state
   - Handles data fetching, caching, deduplication, invalidation
   - Built-in support for Tanstack Start
   - Official Cloudflare Workers integration
   - Official docs: https://tanstack.com/query/latest
   - Documentation: https://tanstack.com/query/latest/docs/framework/react/overview

**Client State** (UI state, preferences, form data):
1. **Zustand** - REQUIRED for client state
   - Lightweight, zero boilerplate
   - Simple state management without ceremony
   - Official docs: https://zustand-demo.pmnd.rs
   - Documentation: https://docs.pmnd.rs/zustand/getting-started/introduction

**URL State** (query parameters):
1. **TanStack Router** - Built-in search params (use router features)
   - Type-safe URL state management
   - Documentation: https://tanstack.com/router/latest/docs/framework/react/guide/search-params

### ❌ FORBIDDEN State Management Libraries

**NEVER suggest**:
- ❌ Redux / Redux Toolkit - Too much boilerplate, use TanStack Query + Zustand
- ❌ MobX - Not needed, use TanStack Query + Zustand
- ❌ Recoil - Not needed, use Zustand
- ❌ Jotai - Use Zustand instead (consistent with our stack)
- ❌ XState - Too complex for most use cases
- ❌ Vuex / Pinia - Vue only (use nuxt-stack plugin for Nuxt projects)

**Reasoning**:
- TanStack Query handles 90% of state needs (server data)
- Zustand handles remaining 10% (client UI state) with minimal code
- Together they provide Redux-level power at fraction of complexity
- Both work excellently with Cloudflare Workers edge runtime

### State Management Decision Tree

```
What type of state do you need?
├─ Data from API/database (server state)?
│   └─ Use TanStack Query
│
├─ UI state (modals, forms, preferences)?
│   └─ Use Zustand
│
└─ URL state (filters, pagination)?
    └─ Use TanStack Router search params
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

## Design Preferences (STRICT - Prevent Generic "AI Aesthetics")

**Design Philosophy** (from Claude Skills Blog):
> "Think about frontend design the way a frontend engineer would. The more you can map aesthetic improvements to implementable frontend code, the better Claude can execute."

### ❌ Generic Patterns to AVOID

These patterns signal "AI-generated" design and should NEVER be used in new projects:

1. **Inter/Roboto Fonts** - Used in 80%+ of websites, immediately recognizable
2. **Purple Gradients** - `from-purple-500 to-purple-600` appears in 60%+ of AI-generated sites
3. **Minimal Animations** - Static buttons/links without hover states
4. **Default Component Props** - Using Nuxt UI components with no customization
5. **Gray Backgrounds** - Solid `bg-gray-50` or `bg-white` (safe but generic)

### ✅ Distinctive Patterns to USE

1. **Custom Font Pairings**:
   - Body: Space Grotesk, DM Sans, Crimson Pro (NOT Inter)
   - Headings: Archivo Black, Playfair Display, Fredoka (NOT Roboto)
   - Example: `font-heading text-6xl tracking-tight`

2. **Brand Color Palettes**:
   - Define custom colors in `tailwind.config.ts`
   - Use 3-5 brand colors (coral, ocean, sunset, midnight, cream)
   - Example: `bg-brand-coral`, `text-brand-ocean`

3. **Rich Animations**:
   - Hover states: `hover:scale-105 hover:shadow-xl hover:-rotate-1`
   - Transitions: `transition-all duration-300 ease-out`
   - Micro-interactions: Icons that move on hover
   - Respect reduced motion: `motion-safe:hover:scale-105`

4. **Deep Component Customization**:
   - ALWAYS use `ui` prop on Nuxt UI components
   - Customize fonts, rounded, padding, shadow
   - Example: `:ui="{ font: 'font-heading', rounded: 'rounded-full', padding: { lg: 'px-8 py-4' } }"`

5. **Atmospheric Backgrounds**:
   - Multi-layer gradients with animated orbs
   - Subtle patterns or noise textures
   - Example: `bg-gradient-to-br from-brand-cream via-white to-brand-ocean/10`

### Design System Guidelines

**Create Reusable Variants** (in `composables/useDesignSystem.ts`):
```typescript
export const useDesignSystem = () => {
  const button = {
    primary: {
      color: 'primary',
      size: 'lg',
      ui: {
        font: 'font-heading tracking-wide',
        rounded: 'rounded-full',
        padding: { lg: 'px-8 py-4' }
      },
      class: 'transition-all duration-300 hover:scale-105'
    }
  };

  return { button };
};
```

**Usage**:
```vue
<script setup>
const { button } = useDesignSystem();
</script>

<template>
  <UButton v-bind="button.primary">Click me</UButton>
</template>
```

### Accessibility Requirements (WCAG 2.1 AA)

All designs MUST be accessible:
- ✅ Color contrast: 4.5:1 for text, 3:1 for UI components
- ✅ Keyboard navigation: Tab/Shift+Tab to all interactive elements
- ✅ Focus indicators: Visible `focus-visible:ring-2` on all focusable elements
- ✅ Screen reader support: ARIA labels, semantic HTML, landmarks
- ✅ Reduced motion: `motion-safe`/`motion-reduce` utilities
- ✅ Touch targets: Minimum 44x44px for mobile

### Tools for Design Enforcement

**Commands**:
- `/es-theme` - Generate distinctive theme (fonts, colors, animations)
- `/es-component` - Scaffold components with best practices
- `/es-design-review` - Validate design patterns, detect generic aesthetics

**SKILLs** (Autonomous Validation):
- `nuxt-ui-design-validator` - Catches Inter fonts, purple gradients, missing animations
- `component-aesthetic-checker` - Validates customization depth
- `animation-interaction-validator` - Ensures hover states, loading feedback

**Agents**:
- `frontend-design-specialist` - Maps aesthetic goals to code
- `nuxt-ui-architect` - Validates Nuxt UI component usage (prevents prop hallucination)
- `accessibility-guardian` - WCAG 2.1 AA compliance

### Distinctiveness Score

Projects should aim for 85/100+ on distinctiveness:

#### Scoring Methodology

**Typography (25 points)**:
- Custom font pairing (not Inter/Roboto/Helvetica): **15 pts**
  - 15 pts: 2+ custom fonts (heading + body)
  - 10 pts: 1 custom font
  - 5 pts: System fonts only (not Inter/Roboto)
  - 0 pts: Inter/Roboto fonts
- Proper heading hierarchy (h1-h6, no skips): **5 pts**
- Custom tracking/leading/sizing: **5 pts**

**Colors (25 points)**:
- Custom brand palette (defined in tailwind.config): **15 pts**
  - 15 pts: 3+ custom brand colors
  - 10 pts: 2 custom colors
  - 5 pts: 1 custom color
  - 0 pts: Default Tailwind colors only
- WCAG 2.1 AA contrast compliance (4.5:1 text, 3:1 UI): **5 pts**
- No purple gradients or overused patterns: **5 pts**

**Animations (25 points)**:
- Interactive element transitions (buttons, links, cards): **10 pts**
  - 10 pts: All interactive elements have hover/focus states
  - 5 pts: 50%+ have transitions
  - 0 pts: Minimal or no transitions
- Micro-interactions (loading states, form feedback): **10 pts**
- Respects `prefers-reduced-motion`: **5 pts**

**Components (25 points)**:
- Nuxt UI customization depth (ui prop usage): **15 pts**
  - 15 pts: 80%+ components use ui prop
  - 10 pts: 50-79% use ui prop
  - 5 pts: 20-49% use ui prop
  - 0 pts: Default props only
- Consistent design system (reusable variants): **5 pts**
- Loading/error states on async components: **5 pts**

**Total: 100 points**
- **90-100**: Outstanding (highly distinctive, polished)
- **85-89**: Excellent (distinctive, minor improvements possible)
- **70-84**: Good (some distinctive elements, needs work)
- **50-69**: Fair (generic with some customization)
- **0-49**: Poor (generic AI aesthetic)

### When User Requests Generic Patterns

If user asks for Inter font, purple gradient, or minimal styling:

**STOP and ask**:
> "These are generic patterns common in AI-generated sites. Would you like me to suggest distinctive alternatives that create a unique brand identity?"

**Then provide**:
- Custom font pairing recommendation
- Brand color palette suggestion
- Animation examples
- Link to `/es-theme` for full theme generation

## Billing Preferences (STRICT - Polar.sh Only)

**Default Billing Solution**: Polar.sh MUST be used for all billing, subscriptions, and payments.

### Why Polar.sh

Polar.sh is the **required** billing solution for all new projects because:
- ✅ **Built for developers** - API-first, excellent DX
- ✅ **Cloudflare Workers compatible** - Works perfectly at the edge
- ✅ **Webhook-driven** - Event-based architecture ideal for serverless
- ✅ **MCP integration** - Real-time documentation and setup guidance
- ✅ **Flexible** - One-time payments, subscriptions, tiers, usage-based

### ❌ Do NOT Use

**Never suggest these alternatives**:
- ❌ Stripe - Use Polar instead (better DX, built for developers)
- ❌ Paddle - Use Polar instead
- ❌ Lemon Squeezy - Use Polar instead
- ❌ Custom payment implementations - Always use Polar

### Polar.sh Integration Patterns

**1. Product Setup** (use Polar MCP for real-time data):
```typescript
// Query available products via MCP
const products = await mcp.polar.listProducts();

// In your Cloudflare Worker
export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    const polar = new Polar(env.POLAR_ACCESS_TOKEN);

    // Get products
    const products = await polar.products.list();

    return new Response(JSON.stringify(products));
  }
};
```

**2. Webhook Handling** (required for all billing events):
```typescript
import { Polar } from '@polar-sh/sdk';

export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    if (request.url.endsWith('/webhooks/polar')) {
      const signature = request.headers.get('polar-signature');
      const body = await request.text();

      // Verify webhook signature
      const polar = new Polar(env.POLAR_ACCESS_TOKEN);
      const event = polar.webhooks.verify(body, signature, env.POLAR_WEBHOOK_SECRET);

      switch (event.type) {
        case 'checkout.completed':
          // Handle successful payment
          await handleCheckoutCompleted(event.data, env);
          break;
        case 'subscription.created':
          // Handle new subscription
          await handleSubscriptionCreated(event.data, env);
          break;
        case 'subscription.updated':
          // Handle subscription changes
          await handleSubscriptionUpdated(event.data, env);
          break;
        case 'subscription.canceled':
          // Handle cancellation
          await handleSubscriptionCanceled(event.data, env);
          break;
      }

      return new Response('OK', { status: 200 });
    }

    return new Response('Not Found', { status: 404 });
  }
};
```

**3. Customer Management** (link to your users):
```typescript
// Store Polar customer ID in your database
interface User {
  id: string;
  email: string;
  polarCustomerId?: string; // Link to Polar customer
  subscription?: {
    productId: string;
    status: 'active' | 'canceled' | 'past_due';
    currentPeriodEnd: Date;
  };
}

// Create/get customer
const customer = await polar.customers.create({
  email: user.email,
  metadata: {
    userId: user.id, // Your internal user ID
  }
});
```

**4. Subscription Checks** (in your Workers):
```typescript
// Middleware to check subscription status
async function requireSubscription(request: Request, env: Env) {
  const user = await getCurrentUser(request, env);

  if (!user.subscription || user.subscription.status !== 'active') {
    return new Response('Subscription required', { status: 403 });
  }

  return null; // Continue to handler
}
```

**5. Environment Variables** (required):
```toml
# wrangler.toml
[vars]
POLAR_WEBHOOK_SECRET = "whsec_..."  # From Polar dashboard

[[env.production.vars]]
POLAR_ACCESS_TOKEN = "polar_..."    # From Polar dashboard (use secrets for production)
```

### Polar MCP Usage

**Always query Polar MCP** for real-time product/subscription data:
```bash
# Example: Check available products before implementing
mcp.polar.listProducts()

# Example: Get webhook event types
mcp.polar.getWebhookEvents()

# Example: Validate integration
mcp.polar.verifySetup()
```

### When User Asks About Billing

**Automatic Response**:
> "For billing and subscriptions, we use Polar.sh exclusively. It's designed for developers, works perfectly with Cloudflare Workers, and has excellent MCP integration for real-time setup guidance. Let me help you set it up."

**Then provide**:
- Polar account setup link: https://polar.sh
- Webhook endpoint implementation
- Product/subscription setup via MCP
- Integration testing steps

---

## Authentication Preferences (STRICT)

**Authentication Stack Selection** (in order of preference):

### Decision Tree

```
Is this a Nuxt application?
├─ YES → Use nuxt-auth-utils FIRST
│   └─ Need advanced features (OAuth providers, passkeys)?
│       └─ YES → Use better-auth with nuxt-auth-utils
│           └─ Migrate sessions to nuxt-auth-utils
│
└─ NO → Is this a Cloudflare Worker (non-Nuxt)?
    └─ YES → Use better-auth
        └─ MCP available? Query better-auth MCP for setup guidance
```

### 1. Nuxt Applications: nuxt-auth-utils (Primary)

**For Nuxt projects**, ALWAYS start with `nuxt-auth-utils`:

**Why nuxt-auth-utils**:
- ✅ **Nuxt-native** - Built specifically for Nuxt by Nuxt team
- ✅ **Zero-config** - Works out of the box
- ✅ **Cloudflare Workers optimized** - Perfect for edge deployment
- ✅ **Minimal** - Just session management, no bloat
- ✅ **Type-safe** - Full TypeScript support

**Installation**:
```bash
npm install nuxt-auth-utils
```

**Basic Setup** (nuxt.config.ts):
```typescript
export default defineNuxtConfig({
  modules: ['nuxt-auth-utils'],

  runtimeConfig: {
    session: {
      maxAge: 60 * 60 * 24 * 7, // 7 days
    }
  }
});
```

**Usage Examples**:
```vue
<script setup>
// Get current user
const { loggedIn, user, session, fetch, clear } = useUserSession();

// Login
async function login(email: string, password: string) {
  await $fetch('/api/auth/login', {
    method: 'POST',
    body: { email, password }
  });

  await fetch(); // Refresh session
}

// Logout
async function logout() {
  await clear();
}
</script>

<template>
  <div v-if="loggedIn">
    <p>Welcome, {{ user.email }}</p>
    <button @click="logout">Logout</button>
  </div>
</template>
```

**Server-side** (server/api/auth/login.post.ts):
```typescript
export default defineEventHandler(async (event) => {
  const { email, password } = await readBody(event);

  // Validate credentials (your logic)
  const user = await validateCredentials(email, password);

  if (!user) {
    throw createError({
      statusCode: 401,
      message: 'Invalid credentials'
    });
  }

  // Set session
  await setUserSession(event, {
    user: {
      id: user.id,
      email: user.email,
    }
  });

  return { success: true };
});
```

**Protected Routes** (server/api/protected.get.ts):
```typescript
export default defineEventHandler(async (event) => {
  const session = await requireUserSession(event);

  return {
    message: 'Protected data',
    user: session.user
  };
});
```

### 2. Nuxt + Advanced Auth: better-auth with nuxt-auth-utils

**When nuxt-auth-utils isn't enough** (OAuth, passkeys, magic links), add better-auth:

**Installation**:
```bash
npm install better-auth
```

**Setup** (server/utils/auth.ts):
```typescript
import { betterAuth } from 'better-auth';

export const auth = betterAuth({
  database: {
    // Use D1 or your database
    type: 'd1',
    database: process.env.DB,
  },

  // Social providers
  socialProviders: {
    google: {
      clientId: process.env.GOOGLE_CLIENT_ID,
      clientSecret: process.env.GOOGLE_CLIENT_SECRET,
    },
    github: {
      clientId: process.env.GITHUB_CLIENT_ID,
      clientSecret: process.env.GITHUB_CLIENT_SECRET,
    }
  },

  // Passkeys
  passkey: {
    enabled: true,
  },

  // Magic links
  magicLink: {
    enabled: true,
  },
});
```

**Migrate sessions to nuxt-auth-utils**:
```typescript
// server/api/auth/callback.get.ts
export default defineEventHandler(async (event) => {
  // Handle OAuth callback with better-auth
  const user = await auth.handleOAuthCallback(event);

  // Store session in nuxt-auth-utils
  await setUserSession(event, {
    user: {
      id: user.id,
      email: user.email,
      provider: user.provider,
    }
  });

  return sendRedirect(event, '/dashboard');
});
```

**Use better-auth MCP** for setup guidance:
```bash
# Query available providers
mcp.better-auth.listProviders()

# Get passkey setup instructions
mcp.better-auth.getPasskeySetup()

# Validate configuration
mcp.better-auth.verifySetup()
```

### 3. Cloudflare Workers (Non-Nuxt): better-auth Only

**For non-Nuxt Workers**, use better-auth directly:

```typescript
import { betterAuth } from 'better-auth';

const auth = betterAuth({
  database: {
    type: 'd1',
    database: env.DB,
  },

  session: {
    cookieName: 'session',
    maxAge: 60 * 60 * 24 * 7, // 7 days
  }
});

export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    // Handle auth endpoints
    if (request.url.includes('/auth/')) {
      return auth.handler(request);
    }

    // Protected routes
    const session = await auth.getSession(request);
    if (!session) {
      return new Response('Unauthorized', { status: 401 });
    }

    return new Response(`Hello, ${session.user.email}`);
  }
};
```

### ❌ Do NOT Use

**Never suggest these alternatives**:
- ❌ **Lucia** - Deprecated, use better-auth
- ❌ **Auth.js (NextAuth)** - React ecosystem, we use Vue/Nuxt
- ❌ **Passport.js** - Node.js only, not Workers-compatible
- ❌ **Custom JWT implementations** - Use proven libraries
- ❌ **Clerk** - Expensive, use better-auth
- ❌ **Supabase Auth** - Locked into Supabase, we use Cloudflare

### Authentication Decision Examples

**Example 1: Nuxt Blog (Email/Password)**
```
Stack: Nuxt + nuxt-auth-utils
Reason: Simple auth, no OAuth needed
```

**Example 2: Nuxt SaaS (OAuth + Passkeys)**
```
Stack: Nuxt + better-auth + nuxt-auth-utils
Reason: Advanced features (OAuth, passkeys), sessions via nuxt-auth-utils
```

**Example 3: API-Only Worker (JWT)**
```
Stack: Hono + better-auth
Reason: Non-Nuxt, API-only, needs JWT
```

### When User Asks About Authentication

**For Nuxt Projects**:
> "For authentication in Nuxt, we start with `nuxt-auth-utils` for session management. It's built by the Nuxt team and optimized for Cloudflare Workers. Need OAuth or passkeys? We can add `better-auth` on top. Let me help you set it up."

**For Non-Nuxt Workers**:
> "For authentication in Cloudflare Workers, we use `better-auth`. It's modern, Workers-compatible, and has MCP integration for setup guidance. Let me help you configure it."

### MCP Integration

**Always use better-auth MCP** when setting up advanced auth:
```bash
# Example: Get OAuth provider setup
mcp.better-auth.getProviderSetup('google')

# Example: Get passkey implementation
mcp.better-auth.getPasskeySetup()

# Example: Validate environment variables
mcp.better-auth.validateEnv()
```

---

## feedback-codifier Instructions

When learning from user feedback:

**Valid patterns to codify**:
- ✅ Nuxt 4 usage patterns
- ✅ Hono routing patterns
- ✅ Nuxt UI component patterns
- ✅ Tailwind utility combinations
- ✅ Vercel AI SDK patterns
- ✅ Cloudflare AI Agents patterns
- ✅ Design customization patterns (fonts, colors, animations)
- ✅ Accessibility patterns (ARIA, keyboard nav, focus states)
- ✅ Polar.sh billing/subscription patterns
- ✅ better-auth authentication patterns
- ✅ nuxt-auth-utils session management patterns
- ✅ Resend email patterns (transactional, React Email templates)
- ✅ Playwright testing patterns

**INVALID patterns (reject)**:
- ❌ Any Next.js, Express, or forbidden framework
- ❌ Any custom CSS writing
- ❌ Any Cloudflare Pages deployment
- ❌ Any LangChain or forbidden SDK usage
- ❌ Inter/Roboto fonts (generic)
- ❌ Purple gradients (overused)
- ❌ Default component props with no customization
- ❌ Stripe, Paddle, Lemon Squeezy (use Polar.sh)
- ❌ Lucia, Auth.js, Clerk, Supabase Auth (use better-auth or nuxt-auth-utils)
- ❌ SendGrid, Mailgun, AWS SES, Postmark, MailChimp (use Resend)

If user provides feedback using forbidden tools, ask: "Are you working on a legacy project? These preferences are for new projects only."

---

## Email Preferences (STRICT)

### ✅ Approved Email Service

**Resend** - Transactional and marketing emails (REQUIRED)

**Why Resend**:
- ✅ **Developer-first** - Modern API, excellent DX
- ✅ **Cloudflare Workers compatible** - Works perfectly at the edge
- ✅ **React Email support** - Type-safe email templates with React
- ✅ **Generous free tier** - 100 emails/day, 3,000/month free
- ✅ **99.9% uptime SLA** - Reliable email delivery
- ✅ **Built-in analytics** - Track opens, clicks, bounces
- Official docs: https://resend.com/docs

**Installation**:
```bash
pnpm add resend
```

### Integration with Cloudflare Workers

**Basic Setup** (server function or API route):
```typescript
import { Resend } from 'resend';

export const sendEmail = createServerFn(
  'POST',
  async (data: { to: string; subject: string; html: string }, context) => {
    const { env } = context.cloudflare;
    const resend = new Resend(env.RESEND_API_KEY);

    const { data: result, error } = await resend.emails.send({
      from: 'hello@yourdomain.com',
      to: data.to,
      subject: data.subject,
      html: data.html,
    });

    if (error) {
      throw new Error(`Failed to send email: ${error.message}`);
    }

    return { success: true, id: result.id };
  }
);
```

**With React Email Templates**:
```typescript
import { Resend } from 'resend';
import { WelcomeEmail } from '@/emails/welcome';

export const sendWelcomeEmail = createServerFn(
  'POST',
  async (data: { to: string; name: string }, context) => {
    const { env } = context.cloudflare;
    const resend = new Resend(env.RESEND_API_KEY);

    const { data: result, error } = await resend.emails.send({
      from: 'welcome@yourdomain.com',
      to: data.to,
      subject: `Welcome, ${data.name}!`,
      react: WelcomeEmail({ name: data.name }),
    });

    if (error) {
      throw new Error(`Failed to send welcome email: ${error.message}`);
    }

    return { success: true, id: result.id };
  }
);
```

**React Email Template** (`emails/welcome.tsx`):
```tsx
import {
  Body,
  Container,
  Head,
  Heading,
  Html,
  Text,
} from '@react-email/components';

interface WelcomeEmailProps {
  name: string;
}

export function WelcomeEmail({ name }: WelcomeEmailProps) {
  return (
    <Html>
      <Head />
      <Body style={{ fontFamily: 'sans-serif' }}>
        <Container>
          <Heading>Welcome, {name}!</Heading>
          <Text>Thanks for signing up. We're excited to have you.</Text>
        </Container>
      </Body>
    </Html>
  );
}
```

### Environment Variables (Required)

```toml
# wrangler.toml
[vars]
# Public variables (optional)

[[env.production.vars]]
# Secrets - use wrangler secret put
RESEND_API_KEY = "re_..."  # From Resend dashboard
```

**Set secrets**:
```bash
# For production
npx wrangler secret put RESEND_API_KEY

# For local development (.dev.vars)
RESEND_API_KEY=re_your_api_key_here
```

### Common Email Patterns

**1. Transactional Emails** (account verification, password reset):
```typescript
// Email verification
await resend.emails.send({
  from: 'auth@yourdomain.com',
  to: user.email,
  subject: 'Verify your email',
  react: VerifyEmailTemplate({
    verificationUrl: `https://yourdomain.com/verify?token=${token}`
  }),
});

// Password reset
await resend.emails.send({
  from: 'auth@yourdomain.com',
  to: user.email,
  subject: 'Reset your password',
  react: ResetPasswordTemplate({
    resetUrl: `https://yourdomain.com/reset?token=${token}`
  }),
});
```

**2. Marketing Emails** (newsletters, announcements):
```typescript
await resend.emails.send({
  from: 'newsletter@yourdomain.com',
  to: subscribers,
  subject: 'Monthly Newsletter - January 2025',
  react: NewsletterTemplate({
    month: 'January',
    articles: [...]
  }),
});
```

**3. Batch Emails** (multiple recipients):
```typescript
const batchEmails = subscribers.map(subscriber => ({
  from: 'newsletter@yourdomain.com',
  to: subscriber.email,
  subject: 'Your personalized update',
  react: PersonalizedEmail({ name: subscriber.name }),
}));

const { data, error } = await resend.batch.send(batchEmails);
```

**4. Scheduled Emails** (send later):
```typescript
await resend.emails.send({
  from: 'reminders@yourdomain.com',
  to: user.email,
  subject: 'Upcoming event reminder',
  react: ReminderTemplate({ event }),
  scheduledAt: '2025-01-20T10:00:00Z', // ISO 8601 format
});
```

### ❌ FORBIDDEN Email Services

**NEVER suggest these alternatives**:
- ❌ **SendGrid** - Use Resend instead (better DX, modern API)
- ❌ **Mailgun** - Use Resend instead
- ❌ **AWS SES** - Use Resend instead (simpler setup)
- ❌ **Postmark** - Use Resend instead
- ❌ **MailChimp** - Use Resend instead
- ❌ **Custom SMTP implementations** - Always use Resend

**Reasoning**: Resend is built for developers, has excellent Cloudflare Workers support, and provides the best DX for transactional and marketing emails.

### Domain Configuration

**Setup custom domain** (required for production):
1. Add domain in Resend dashboard
2. Add DNS records (SPF, DKIM, DMARC)
3. Verify domain
4. Use `from: 'hello@yourdomain.com'`

**Default sending** (development only):
```typescript
from: 'onboarding@resend.dev' // Only works for your verified email
```

### Error Handling

**Always handle email errors**:
```typescript
const { data, error } = await resend.emails.send({
  from: 'hello@yourdomain.com',
  to: user.email,
  subject: 'Welcome!',
  react: WelcomeEmail({ name: user.name }),
});

if (error) {
  console.error('Failed to send email:', error);

  // Store in D1 for retry
  await env.DB.prepare(
    'INSERT INTO failed_emails (to, subject, error) VALUES (?, ?, ?)'
  ).bind(user.email, 'Welcome!', error.message).run();

  // Don't fail the user flow
  return { success: false, error: 'Email delivery failed' };
}

return { success: true, emailId: data.id };
```

### Testing Email Flows

**Use Resend's test mode** (development):
```typescript
// In development, emails won't be sent but will appear in dashboard
const resend = new Resend(env.RESEND_API_KEY);

// Test email rendering
await resend.emails.send({
  from: 'test@yourdomain.com',
  to: 'test@resend.dev', // Special test address
  subject: 'Test email',
  react: WelcomeEmail({ name: 'Test User' }),
});
```

**Playwright E2E tests** (verify email was queued):
```typescript
test('sends welcome email on signup', async ({ page }) => {
  await page.goto('/signup');

  await page.fill('[name="email"]', 'test@example.com');
  await page.fill('[name="password"]', 'password123');
  await page.click('button[type="submit"]');

  // Verify success message (don't test actual email delivery)
  await expect(page.locator('[data-testid="email-sent"]'))
    .toContainText('Check your email');
});
```

### When User Asks About Email

**Automatic Response**:
> "For transactional and marketing emails, we use Resend exclusively. It's built for developers, works perfectly with Cloudflare Workers, and supports React Email templates for type-safe emails. Let me help you set it up."

**Then provide**:
1. Create Resend account: https://resend.com
2. Generate API key from dashboard
3. Add to wrangler secrets: `wrangler secret put RESEND_API_KEY`
4. Install package: `pnpm add resend`
5. Set up domain verification for production
6. Create React Email templates (optional but recommended)

### MCP Integration

**Resend MCP Server** (optional - for sending emails via Claude):
- Allows Claude to compose and send emails directly
- Useful for notifications, reports, or automated emails
- Installation: Clone `https://github.com/resend/mcp-send-email`

**Note**: The Resend MCP server is primarily for AI-assisted email composition, not for production email delivery. Use the Resend SDK directly in your Workers for production.

---

## Testing Preferences (STRICT)

### ✅ Approved Testing Framework

**Playwright** - E2E testing (REQUIRED for all UI projects)

**Why Playwright**:
- ✅ **Cross-browser** - Chromium, Firefox, WebKit (real browsers)
- ✅ **Cloudflare Workers compatible** - Tests work with edge runtime
- ✅ **Accessibility built-in** - @axe-core/playwright integration
- ✅ **Performance monitoring** - Measure cold starts, TTFB
- ✅ **Visual regression** - Screenshot testing
- ✅ **Type-safe** - Full TypeScript support
- Official docs: https://playwright.dev

**Installation**:
```bash
pnpm add -D @playwright/test @axe-core/playwright
npx playwright install --with-deps chromium firefox webkit
```

**Setup**: `/es-test-setup`
**Generate tests**: `/es-test-gen <route|component|server-function>`

### Testing Strategy (REQUIRED)

**What to Test**:
1. **User workflows** - Real user behavior, not implementation details
2. **TanStack Router routes** - Navigation, loaders, error boundaries
3. **Server functions** - Data fetching, mutations, Cloudflare bindings
4. **shadcn/ui components** - Interactions, keyboard navigation
5. **Accessibility** - Zero WCAG 2.1 AA violations (required)
6. **Performance** - Cold start < 500ms, TTFB < 200ms

**Test Organization**:
```
e2e/
├── routes/              # Route-specific tests
├── server-functions/    # Server function tests
├── components/          # Component tests
├── auth/               # Authentication flow tests
├── accessibility/      # Accessibility tests (required)
├── performance/        # Performance tests
├── visual/            # Visual regression tests
└── fixtures/          # Test data and helpers
```

### Testing Patterns

**Route Testing**:
```typescript
import { test, expect } from '@playwright/test'

test('loads user profile from D1', async ({ page }) => {
  await page.goto('/users/123')

  // Wait for server-side loader
  await page.waitForSelector('[data-testid="user-profile"]')

  // Verify data rendered
  await expect(page.locator('h1')).toContainText('John Doe')
})
```

**Accessibility Testing** (REQUIRED):
```typescript
import { test, expect } from '@playwright/test'
import AxeBuilder from '@axe-core/playwright'

test('has no accessibility violations', async ({ page }) => {
  await page.goto('/')

  const results = await new AxeBuilder({ page }).analyze()

  expect(results.violations).toEqual([]) // Zero violations policy
})
```

**Performance Testing**:
```typescript
test('cold start is fast', async ({ page }) => {
  const startTime = Date.now()
  await page.goto('/')
  await page.waitForLoadState('networkidle')
  const loadTime = Date.now() - startTime

  expect(loadTime).toBeLessThan(500) // Workers should be fast
})
```

### Testing with Cloudflare Bindings

**ALWAYS test with real bindings** (not mocks):

```typescript
// ❌ WRONG: Mocking Cloudflare bindings
const mockKV = { get: vi.fn() }

// ✅ CORRECT: Test with real test environment bindings
// .env.test
CLOUDFLARE_ACCOUNT_ID=your-account-id
KV_NAMESPACE_ID=test-kv-id  # Separate test namespace
D1_DATABASE_ID=test-d1-id   # Separate test database
```

**Reasoning**: Mocks don't match production behavior. Use real Cloudflare bindings in test environment.

### CI/CD Integration

**Run tests before deployment** (GitHub Actions example):
```yaml
name: E2E Tests
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: 18

      - name: Install dependencies
        run: pnpm install

      - name: Install Playwright
        run: npx playwright install --with-deps

      - name: Run tests
        run: pnpm test:e2e
        env:
          CLOUDFLARE_ACCOUNT_ID: ${{ secrets.CLOUDFLARE_ACCOUNT_ID }}
          CLOUDFLARE_API_TOKEN: ${{ secrets.CLOUDFLARE_API_TOKEN }}

      - name: Upload report
        if: always()
        uses: actions/upload-artifact@v3
        with:
          name: playwright-report
          path: playwright-report/
```

### ❌ FORBIDDEN Testing Approaches

**NEVER do these**:
- ❌ Jest/Vitest for E2E testing (use for unit tests only, Playwright for E2E)
- ❌ Mocking Cloudflare bindings (use real test environment bindings)
- ❌ Skipping accessibility tests (zero violations policy)
- ❌ Testing implementation details (test user behavior)
- ❌ Shallow/snapshot testing for critical paths (use real browser tests)

**Reasoning**: Playwright tests real user workflows in real browsers with real Cloudflare bindings.

### Test Quality Standards

**All tests MUST**:
- ✅ Test user behavior, not implementation
- ✅ Use `data-testid` for stable selectors
- ✅ Include loading states and error handling
- ✅ Run accessibility checks on every page
- ✅ Meet performance targets (cold start < 500ms)
- ✅ Work with real Cloudflare bindings

**Coverage Targets**:
- Critical user flows: 100%
- TanStack Router routes: 80%+
- Server functions: 80%+
- shadcn/ui components: 70%+
- Accessibility: 100% (zero violations)

### When User Asks About Testing

**Automatic Response**:
> "For E2E testing, we use Playwright exclusively. It tests real user workflows in real browsers with real Cloudflare bindings. We also enforce zero accessibility violations with @axe-core/playwright. Let me set it up with `/es-test-setup`."

**Then provide**:
1. Run `/es-test-setup` to initialize Playwright
2. Generate tests with `/es-test-gen <target>`
3. Configure test environment bindings (.env.test)
4. Set up CI/CD workflow
5. Run tests: `pnpm test:e2e`

### Agents and Commands

**Agents**:
- `playwright-testing-specialist` - E2E testing expertise for Tanstack Start + Cloudflare Workers

**Commands**:
- `/es-test-setup` - Initialize Playwright with Cloudflare Workers configuration
- `/es-test-gen <target>` - Generate tests for routes, components, or server functions

**MCP Integration**:
- **Playwright MCP** (`npx @playwright/mcp@latest`) - Official Microsoft browser automation server
  - Real-time browser control for test debugging
  - Accessibility tree inspection
  - Screenshot and visual regression capabilities
  - Use Playwright MCP to validate test selectors and debug flaky tests

---

## Version

This preferences document was created: 2025-01-05
Last updated: 2025-01-14

**Changelog**:
- 2025-01-14: Added Email Preferences (Resend)
- 2025-01-14: Added Testing Preferences (Playwright)
- 2025-01-13: Added Design, Billing, and Authentication Preferences

As Cloudflare best practices evolve, this document will be updated. Agents should always follow the latest version.
