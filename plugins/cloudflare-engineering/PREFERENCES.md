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
compatibility_date = "2024-01-01"

# For Nuxt 4 projects
[site]
bucket = ".output/public"

# For static files
assets = { directory = "public" }
```

**If user says "deploy to Pages"**: Correct them and explain Workers is the modern approach.

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
