# User Preferences - Edge Stack Development Standards

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

If user provides feedback using forbidden tools, ask: "Are you working on a legacy project? These preferences are for new projects only."

## Version

This preferences document was created: 2025-01-05
Updated: 2025-01-13 (Added Design, Billing, and Authentication Preferences)

As Cloudflare best practices evolve, this document will be updated. Agents should always follow the latest version.
