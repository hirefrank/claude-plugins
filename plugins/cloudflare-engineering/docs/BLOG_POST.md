# Building a Smarter AI Coding Assistant for Cloudflare Workers

## The Big Picture

Imagine you're building apps on Cloudflare's platform, which is like having your code run on thousands of computers around the world at the same time - super fast, everywhere. But here's the challenge: Cloudflare works differently than traditional web hosting. It has its own rules, best practices, and gotchas.

What if you could have an AI assistant that **already knows** all those rules? An assistant that checks your work before you deploy, catches mistakes before they happen, and even learns from your preferences over time?

That's what we built: **The Cloudflare Engineering Plugin for Claude Code**.

---

## The 5 Ws and How

### 👤 WHO is this for?

**You, if you're:**
- Building web apps on Cloudflare Workers (Cloudflare's edge computing platform)
- Using AI assistants (like Claude) to help write code
- Tired of AI giving you generic advice that doesn't work with Cloudflare
- Want your AI assistant to understand Cloudflare's unique environment

**Specifically built for developers who:**
- Use Nuxt 4 (a modern web framework)
- Store data in Cloudflare's databases (KV, R2, D1, Durable Objects)
- Deploy globally in seconds
- Need AI that "gets it" without constant explanations

---

### 🎯 WHAT is it?

Think of it as **specialized training for your AI coding assistant**.

**The analogy:**
- **Regular Claude** = A smart general practitioner doctor
- **Claude with this plugin** = A specialist who only treats Cloudflare patients and knows every edge case

**What it includes:**

1. **17 Specialized "Experts"** (we call them agents)
   - Each expert knows one specific area really well
   - They work in parallel, like a team of consultants
   - Example: One checks your database code, another checks security, another checks performance

2. **10 Smart Commands**
   - Pre-built workflows for common tasks
   - Like having a recipe book for Cloudflare development
   - Example: `/review` checks your entire codebase in seconds

3. **Self-Improvement System**
   - The plugin learns from your feedback
   - If you correct something, it remembers for next time
   - Gets smarter with every project

4. **Quality Gates** (Stop Hooks)
   - Automatic checks before you finish working
   - Catches common mistakes (like using outdated settings)
   - Like a spell-checker, but for Cloudflare code

---

### 📍 WHERE does it work?

**Platform:** Works inside **Claude Code** (Anthropic's AI coding assistant)

**Project Types:**
- ✅ Cloudflare Workers (edge computing)
- ✅ Nuxt 4 applications (web apps)
- ✅ Hono backends (API servers)
- ✅ Apps using Cloudflare databases (KV, D1, R2, Durable Objects)

**NOT for:**
- ❌ Traditional servers (AWS EC2, Heroku, etc.)
- ❌ Other frameworks (Next.js, Express, etc.) - though we can migrate them to Nuxt 4!
- ❌ Other AI assistants (GitHub Copilot, Cursor, etc.) - this is Claude-specific

---

### ⏰ WHEN should you use it?

**Perfect for these situations:**

1. **Starting a new Cloudflare project**
   - Get best practices from day one
   - Avoid common beginner mistakes
   - Set up everything correctly the first time

2. **Reviewing code before deployment**
   - Catch bugs that would crash in production
   - Find security issues
   - Optimize for performance

3. **Migrating to Cloudflare**
   - Moving from Heroku, AWS, or other platforms
   - Converting React apps to Nuxt 4
   - Preserving your data and settings

4. **Building new features**
   - Get a plan before you start coding
   - Validate your architecture
   - Make sure everything works with Cloudflare's rules

5. **Daily development**
   - Quick checks as you code
   - Instant feedback on mistakes
   - Smart suggestions for improvements

**When NOT to use it:**
- You're not using Cloudflare (duh!)
- You want generic advice (regular Claude is fine)
- You're building for traditional servers

---

### 💡 WHY does it matter?

**The Problem:**

Regular AI assistants don't "understand" Cloudflare. They'll suggest things that:
- Don't work in Cloudflare's environment (like using Node.js file system APIs)
- Violate Cloudflare best practices (like using local dev instead of remote bindings)
- Cause performance issues (like large bundle sizes)
- Use outdated patterns (like the old `--remote` flag)

It's like asking a New York taxi driver for directions in Tokyo. They know how to drive, but they don't know the city.

**The Solution:**

This plugin teaches Claude to be a **Cloudflare native**. Every suggestion is:
- ✅ Workers-compatible (won't crash on Cloudflare)
- ✅ Following best practices (fast, secure, efficient)
- ✅ Using current APIs (not deprecated stuff)
- ✅ Optimized for your preferences (Nuxt 4, Tailwind, etc.)

**Real Impact:**

**Before plugin:**
```
You: "Help me connect to my database in Cloudflare"
Claude: "Use fs.readFile to read your database config..."
❌ This doesn't work! Cloudflare doesn't have a file system!
```

**After plugin:**
```
You: "Help me connect to my database in Cloudflare"
Claude: "I'll use your D1 binding from wrangler.toml. Here's how to access it in your server route..."
✅ Perfect! Claude knows to use D1 and checks your actual config!
```

---

### 🔧 HOW does it work?

**The Magic Behind the Scenes:**

#### 1. **Multi-Agent System** (Team of Experts)

Instead of one AI trying to know everything, we have 17 specialized experts:

**Example workflow when you run `/review`:**

```
You: /review my code

Claude activates 4 phases with 16 experts running in parallel:

Phase 1 - Context Gathering (3 experts):
├─ binding-context-analyzer → Checks your database config
├─ git-history-analyzer → Reviews recent changes
└─ repo-research-analyst → Understands your codebase

Phase 2 - Cloudflare Checks (5 experts):
├─ workers-runtime-guardian → "Is this code Workers-compatible?"
├─ durable-objects-architect → "Are Durable Objects used correctly?"
├─ cloudflare-security-sentinel → "Any security issues?"
├─ edge-performance-oracle → "Will this be fast globally?"
└─ cloudflare-pattern-specialist → "Following best practices?"

Phase 3 - Data & Architecture (5 experts):
├─ cloudflare-architecture-strategist → "Is the architecture solid?"
├─ cloudflare-data-guardian → "Data handling correct?"
├─ kv-optimization-specialist → "KV usage optimized?"
├─ r2-storage-architect → "R2 storage patterns good?"
└─ edge-caching-optimizer → "Caching strategy effective?"

Phase 4 - Final Polish (3 experts):
├─ workers-ai-specialist → "AI features implemented well?"
├─ code-simplicity-reviewer → "Code readable and maintainable?"
└─ feedback-codifier → "Any new patterns to remember?"

Result: Comprehensive report in seconds
```

#### 2. **MCP Integration** (Real-Time Knowledge)

MCP = "Model Context Protocol" - a way for Claude to access live data.

**Without MCP:**
Claude guesses based on training data (might be wrong or outdated)

**With MCP:**
Claude checks your actual Cloudflare account and official docs in real-time

**Example:**
```
You: "Create a KV namespace called USER_SESSIONS"

Without MCP:
Claude: "Here's how to create a KV namespace..."
(Might suggest a name that already exists!)

With MCP:
Claude: "I checked your account - you already have USER_SESSIONS.
         Would you like to reuse it or create USER_SESSIONS_V2?"
```

#### 3. **Self-Improvement Loop** (Gets Smarter)

**How it learns:**

```
Session 1:
You: "Use Nuxt 4 for this"
Claude: *builds with Nuxt 4*

Session 2:
You: "Use Nuxt 4 again"
Claude: *builds with Nuxt 4*

Session 3:
feedback-codifier agent: "User always wants Nuxt 4. Let me save this preference..."
*Updates PREFERENCES.md*

Session 4:
Claude: *automatically uses Nuxt 4 without being asked*
```

The plugin literally updates itself with your preferences!

#### 4. **Stop Hooks** (Quality Gates)

Before you finish working, automatic checks run:

```
You: *About to end session*

Stop Hook runs:
✅ Is wrangler.toml valid?
✅ Using compatibility_date 2025-09-15 or later?
✅ All bindings have remote = true?
✅ TypeScript passing?
✅ Bundle size under 500KB?
✅ All changes committed to git?

If anything fails:
❌ "Wait! You have TypeScript errors. Fix before finishing."
```

It's like having a checklist that runs automatically.

---

## The 10 Commands Explained (With Examples)

Let me walk you through each command like we're having coffee...

---

### 1. `/review` - Your AI Code Reviewer

**What it does:** Comprehensively checks your code for Cloudflare-specific issues

**When to use:**
- Before deploying to production
- After adding a new feature
- When you want a "second opinion"
- During code review time

**Real-world example:**

```
Scenario: You just finished building a user authentication system

You: /review

Claude runs 16 experts in parallel and finds:

❌ CRITICAL: Using process.env to read secrets
   Problem: This is a Node.js API that doesn't work in Workers
   Fix: Use env.SECRET_KEY from your handler

⚠️ WARNING: KV writes don't have TTL
   Problem: Data will stay forever, wasting storage
   Fix: Add expirationTtl: 86400 (24 hours)

✅ GOOD: Using bcrypt via Web Crypto API
✅ GOOD: Durable Objects handling WebSocket connections correctly

Overall: Fix 1 critical issue, consider 1 warning
```

**What you get:**
- Every issue categorized (Critical/Warning/Info)
- Specific code locations (file:line)
- Suggested fixes
- Explanations in plain English

---

### 2. `/work` - Execute Your Plan

**What it does:** Takes a work plan and executes it step-by-step with validation

**When to use:**
- You have a clear task list
- You want Claude to work autonomously
- You need validation after each step

**Real-world example:**

```
Scenario: You have a GitHub issue with 5 tasks

You: /work on issue #42

Claude reads issue:
"Add rate limiting to API endpoints"
- [ ] Create rate limiter Durable Object
- [ ] Add rate check middleware
- [ ] Update wrangler.toml with DO binding
- [ ] Add tests
- [ ] Update docs

Claude works through each task:

Task 1: Creating rate limiter Durable Object
├─ Writing src/rate-limiter.ts
├─ Validating with workers-runtime-guardian ✅
├─ Validating with durable-objects-architect ✅
└─ Task 1 complete

Task 2: Adding rate check middleware
├─ Writing src/middleware/rate-limit.ts
├─ Validating with cloudflare-pattern-specialist ✅
└─ Task 2 complete

... continues through all 5 tasks ...

Final validation:
✅ All tasks complete
✅ TypeScript passes
✅ Tests pass
✅ Ready to commit
```

**What you get:**
- Autonomous execution
- Validation after each step
- Clear progress updates
- Final summary

---

### 3. `/plan` - Generate GitHub Issues

**What it does:** Analyzes a feature request and creates detailed GitHub issues

**When to use:**
- Starting a new feature
- Breaking down large projects
- Need clear requirements before coding

**Real-world example:**

```
Scenario: Product manager says "We need a dashboard"

You: /plan "Build an analytics dashboard showing user stats"

Claude thinks through the architecture:

Phase 1: Checking Cloudflare Resources
binding-context-analyzer: "You have D1 database USER_DATA and KV namespace CACHE"

Phase 2: Architecture Planning
cloudflare-architecture-strategist: "Dashboard needs:
- Nuxt 4 frontend (you use Nuxt)
- Server routes to query D1
- KV caching for expensive queries
- Real-time updates via Durable Objects (optional)"

Claude generates 3 GitHub issues:

Issue 1: Backend API Endpoints [Priority: High]
═══════════════════════════════════════════
Create server routes for analytics data:

**Endpoints:**
- GET /api/stats/users (total users, new users)
- GET /api/stats/activity (daily active users)
- GET /api/stats/trending (most viewed content)

**Implementation:**
- Query D1 database USER_DATA
- Cache results in KV CACHE for 5 minutes
- Return JSON responses

**Acceptance Criteria:**
- [ ] All endpoints return < 100ms
- [ ] Results cached in KV
- [ ] TypeScript types defined

**wrangler.toml:**
Already configured:
[[d1_databases]]
binding = "USER_DATA"
database_id = "existing-id"
remote = true

Issue 2: Dashboard UI [Priority: High]
═══════════════════════════════════════════
Build dashboard page using Nuxt UI components:

**Components needed:**
- UCard for stat cards
- UTable for data tables
- UChart for graphs (or use Chart.js)

**Pages:**
- pages/dashboard.vue (main dashboard)
- components/StatCard.vue (reusable stat display)

**Styling:**
- Use Nuxt UI + Tailwind 4 (NO custom CSS)

**Acceptance Criteria:**
- [ ] Dashboard loads in < 2 seconds
- [ ] Mobile responsive
- [ ] Uses Nuxt UI components only

Issue 3: Caching Strategy [Priority: Medium]
═══════════════════════════════════════════
Implement KV caching for expensive queries...

You: (Reviews issues, adjusts priorities, assigns to team)
```

**What you get:**
- Detailed GitHub issues ready to use
- Architecture recommendations
- Clear acceptance criteria
- References to your actual Cloudflare resources

---

### 4. `/triage` - Organize Findings

**What it does:** Converts code review findings into actionable todos

**When to use:**
- After running `/review`
- You have a list of issues to fix
- Need to prioritize and track work

**Real-world example:**

```
Scenario: /review found 15 issues, now you need to organize them

You: /triage

Claude analyzes findings and creates structured todos:

Priority 1 (Critical - Fix Now) 🔴
═══════════════════════════════════════
Todo 1: Remove Node.js process.env usage
---
status: pending
priority: p1
issue_id: "001"
tags: [workers-runtime, critical, security]
file: src/config.ts:12
---
**Problem:** Using process.env.DATABASE_URL
**Fix:** Use env.DATABASE_URL from handler parameter
**Why critical:** Will crash in Workers runtime
**Estimated time:** 5 minutes

Todo 2: Add secrets to wrangler.toml
---
status: pending
priority: p1
issue_id: "002"
tags: [security, configuration]
file: src/auth.ts:45
---
**Problem:** API key hardcoded in source
**Fix:** Run wrangler secret put API_KEY
**Why critical:** Security vulnerability
**Estimated time:** 2 minutes

Priority 2 (Important - Fix Soon) ⚠️
═══════════════════════════════════════
Todo 3: Add TTL to KV writes
---
status: pending
priority: p2
issue_id: "003"
tags: [kv, optimization, performance]
file: src/cache.ts:23-45
---
**Problem:** 5 KV writes without expiration
**Fix:** Add expirationTtl: 86400
**Why important:** Storage costs, stale data
**Estimated time:** 10 minutes

... continues for all 15 issues ...

Summary:
🔴 3 critical issues (fix today)
⚠️ 7 important issues (fix this week)
ℹ️ 5 optional improvements (nice to have)
```

**What you get:**
- Prioritized todo list
- Each todo is a markdown file
- Clear fix instructions
- Time estimates
- Tracking tags

---

### 5. `/generate_command` - Create Custom Commands

**What it does:** Helps you create your own Claude Code commands

**When to use:**
- You have a repetitive workflow
- Want to automate a common task
- Need a project-specific command

**Real-world example:**

```
Scenario: You deploy to staging a lot

You: /generate_command "Create a command that deploys to staging and runs smoke tests"

Claude asks clarifying questions:
- What should it be called? → /deploy-staging
- What tests to run? → Check homepage, API health, database connection
- What to do if tests fail? → Rollback deployment

Claude generates:

File: .claude/commands/deploy-staging.md

# Deploy to Staging with Smoke Tests

<command_purpose>
Deploy to Cloudflare Workers staging environment and run smoke tests.
Automatically rollback if tests fail.
</command_purpose>

## Steps

1. Run pre-flight checks:
   - pnpm typecheck
   - pnpm lint
   - pnpm test

2. Build for production:
   - pnpm build

3. Deploy to staging:
   - wrangler deploy --env staging

4. Run smoke tests:
   - curl https://staging.example.com/ (expect 200)
   - curl https://staging.example.com/api/health (expect "OK")
   - Test database connection via /api/test-db

5. If any test fails:
   - wrangler rollback [previous-deployment-id]
   - Notify user of failure

6. If all pass:
   - Output deployment URL
   - Generate test report

You: Awesome! Now I can use /deploy-staging anytime
```

**What you get:**
- Custom command tailored to your workflow
- Saved in your project
- Reusable across sessions

---

### 6. `/resolve_todo_parallel` - Batch Fix Issues

**What it does:** Works through multiple todos simultaneously

**When to use:**
- You have many small issues to fix
- Issues are independent (can be fixed in any order)
- Want to save time

**Real-world example:**

```
Scenario: You have 20 todos from /triage, mostly small fixes

You: /resolve_todo_parallel

Claude analyzes todos:
"I found 20 todos. 15 are independent and can be parallelized."

Working on todos in parallel:

Group 1 (5 todos):
├─ Todo 1: Add TTL to user cache → In progress
├─ Todo 2: Add TTL to session cache → In progress
├─ Todo 3: Add TTL to post cache → In progress
├─ Todo 4: Fix TypeScript type → In progress
└─ Todo 5: Remove console.log → In progress

... 30 seconds later ...

All Group 1 complete ✅

Group 2 (5 todos):
├─ Todo 6: Update import path → In progress
... continues ...

Final result:
✅ 15 todos completed (parallelized)
⚠️ 3 todos require manual review
⏭️ 2 todos blocked by external dependencies

Time saved: ~45 minutes (vs sequential fixing)
```

**What you get:**
- Fast parallel execution
- Clear progress tracking
- Identification of blocking issues

---

### 7. `/cf-deploy` - Safe Production Deployment

**What it does:** Comprehensive pre-flight checks before deploying to production

**When to use:**
- Ready to deploy to production
- Want to catch issues before going live
- Need a safety checklist

**Real-world example:**

```
Scenario: You think your code is ready for production

You: /cf-deploy production

Claude runs multi-phase validation:

Phase 1: Configuration Validation ⚙️
═══════════════════════════════════════
✅ wrangler.toml exists
✅ wrangler.toml syntax valid
✅ compatibility_date = 2025-09-15 (current)
✅ All bindings have IDs
✅ Authentication valid (logged in as frank@example.com)

Phase 2: Code Quality Checks (5 agents in parallel) 🔍
═══════════════════════════════════════
Running agents:
├─ workers-runtime-guardian → ✅ No Node.js APIs
├─ cloudflare-security-sentinel → ✅ No hardcoded secrets
├─ binding-context-analyzer → ✅ All bindings match
├─ edge-performance-oracle → ⚠️ Bundle size is 480KB (OK, but close to limit)
└─ cloudflare-pattern-specialist → ✅ All patterns correct

Phase 3: Build & Test 🔨
═══════════════════════════════════════
Running: pnpm typecheck → ✅ Pass
Running: pnpm lint → ✅ Pass
Running: pnpm test → ✅ 47 tests pass
Building: pnpm build → ✅ Success
Analyzing bundle: 480KB (target < 500KB) → ⚠️ Warning

Phase 4: Pre-Deployment Summary 📋
═══════════════════════════════════════
Environment: production
Worker: my-app
Account: frank@example.com
Current deployment: v1.2.3 (deployed 2 days ago)
New deployment: v1.2.4

Changes since last deploy:
- Added rate limiting feature
- Fixed authentication bug
- Updated dependencies

⚠️ WARNINGS:
- Bundle size close to limit (480KB / 500KB)

✅ READY TO DEPLOY

Proceed? (yes/no)

You: yes

Phase 5: Deployment 🚀
═══════════════════════════════════════
Creating git tag: deploy-20250105-143022
Deploying to production...
✅ Deployed successfully!

URL: https://my-app.workers.dev
Deployment ID: abc123

Phase 6: Post-Deployment Validation ✅
═══════════════════════════════════════
Testing: curl -I https://my-app.workers.dev
Response: 200 OK ✅

Testing: curl https://my-app.workers.dev/api/health
Response: {"status":"healthy"} ✅

All smoke tests passed! 🎉

Deployment Report:
─────────────────
✅ Deployment successful
⏱️ Total time: 45 seconds
📦 Bundle size: 480KB
🌍 Available globally in 300+ locations

Rollback command (if needed):
wrangler rollback abc123
```

**What you get:**
- Comprehensive pre-flight checks
- Clear go/no-go decision
- Automatic smoke tests
- Rollback instructions
- Peace of mind

---

### 8. `/cf-migrate` - Platform Migration to Cloudflare

**What it does:** Migrates apps from other platforms (Heroku, AWS, etc.) to Cloudflare Workers

**When to use:**
- Moving from Heroku/AWS/Vercel to Cloudflare
- Converting a traditional server app to Workers
- Need help with data migration

**Real-world example:**

```
Scenario: You have a Node.js app on Heroku, want to move to Cloudflare

You: /cf-migrate "Heroku app with Postgres and Redis"

Claude detects platform:

Phase 1: Platform Detection 🔍
═══════════════════════════════════════
Detected: Heroku
├─ Found: Procfile
├─ Database: PostgreSQL (Heroku addon)
├─ Cache: Redis (Heroku addon)
├─ Framework: Express.js
└─ Environment: Node.js 18

Phase 2: Migration Assessment 📊
═══════════════════════════════════════
Analyzing app structure...

Discovered:
- 12 routes
- 8 components
- Express middleware (body-parser, cors, helmet)
- PostgreSQL queries (direct SQL)
- Redis caching
- Environment variables (23 detected)

Cloudflare Mapping:
├─ PostgreSQL → D1 database (SQLite on edge)
├─ Redis → KV storage (key-value on edge)
├─ Express → Hono (Workers-compatible framework)
├─ Node.js APIs → Web APIs
└─ Heroku dyno → Workers (serverless)

Phase 3: Migration Complexity 📈
═══════════════════════════════════════
Overall Complexity: MEDIUM

Challenges:
⚠️ PostgreSQL → D1 (schema conversion needed)
⚠️ Redis → KV (different API, need to adapt)
✅ Express → Hono (straightforward, same patterns)
✅ Small app (easy to migrate)

Estimated Timeline: 3-5 days
Estimated Effort: Medium

Claude generates comprehensive migration plan:

# Cloudflare Workers Migration Plan

## Phase 1: Infrastructure Setup (Day 1)
─────────────────────────────────────
1. Create Cloudflare account
2. Install wrangler CLI
3. Create wrangler.toml with bindings:
   - D1 database (for PostgreSQL replacement)
   - KV namespace (for Redis replacement)
4. Set up secrets (23 environment variables)

## Phase 2: Database Migration (Day 2-3)
─────────────────────────────────────
1. Export PostgreSQL schema
2. Convert to SQLite (D1-compatible)
3. Migrate data (batch upload to D1)
4. Test queries in D1

## Phase 3: Code Transformation (Day 3-4)
─────────────────────────────────────
Convert Node.js code to Workers-compatible:

OLD (Express + Node.js):
app.get('/users', async (req, res) => {
  const users = await db.query('SELECT * FROM users');
  const cached = await redis.get('users');
  res.json(users);
});

NEW (Hono + Workers):
app.get('/users', async (c) => {
  const cached = await c.env.CACHE.get('users', 'json');
  if (cached) return c.json(cached);

  const result = await c.env.DB.prepare('SELECT * FROM users').all();
  await c.env.CACHE.put('users', JSON.stringify(result), { expirationTtl: 300 });
  return c.json(result);
});

12 routes need conversion...

## Phase 4: Testing (Day 4-5)
─────────────────────────────────────
... complete plan continues ...

You: (Reviews plan, approves, Claude executes migration)
```

**What you get:**
- Platform detection
- Resource mapping (Postgres→D1, Redis→KV)
- Code transformation plan
- Step-by-step execution
- Data migration strategy

---

### 9. `/cf-nuxt-migrate` - Framework Migration to Nuxt 4

**What it does:** Migrates existing Cloudflare apps from any framework (React, Vue 2, etc.) to Nuxt 4

**When to use:**
- You have a Cloudflare Workers app with React/Vue/Svelte
- Want to standardize on Nuxt 4
- Need to modernize an old framework

**Real-world example:**

```
Scenario: You have a React app on Cloudflare, want to switch to Nuxt 4

You: /cf-nuxt-migrate "Convert React app to Nuxt 4"

Claude detects framework:

Phase 1: Framework Detection 🔍
═══════════════════════════════════════
Source Framework: React 18
├─ Found: package.json with "react": "^18.0.0"
├─ Structure: src/components, src/pages
├─ State: React Context API
├─ Styling: CSS Modules
└─ Routing: React Router

Target Framework: Nuxt 4 (Vue 3)
├─ Why Nuxt 4: Your preference (from PREFERENCES.md)
├─ Styling: Nuxt UI + Tailwind 4 (NO custom CSS)
└─ State: Pinia or composables

Cloudflare Infrastructure: ✅ PRESERVED
├─ Workers runtime: No changes
├─ Bindings: KV, D1, R2 (preserved)
├─ wrangler.toml: Configuration preserved
└─ Deployment: Same process

Phase 2: Migration Assessment 📊
═══════════════════════════════════════
Discovered:
- 15 React components
- 8 pages/routes
- Context API for state (user auth)
- CSS Modules (27 files)
- React Router (declarative routing)

Migration Complexity: HIGH
Reason: React → Vue is a paradigm shift

Estimated Timeline: 1-2 weeks
Estimated Effort: High

Phase 3: Component Mapping 🔄
═══════════════════════════════════════
Claude generates mapping table:

| React Component    | Nuxt 4 Component     | Effort | Notes                          |
|--------------------|---------------------|--------|--------------------------------|
| Button.jsx         | UButton (Nuxt UI)   | Low    | Direct replacement             |
| Card.jsx           | UCard (Nuxt UI)     | Low    | Direct replacement             |
| UserProfile.jsx    | UserProfile.vue     | High   | JSX → Vue template + script    |
| LoginForm.jsx      | LoginForm.vue       | High   | React hooks → Vue composition  |
| Dashboard.jsx      | pages/dashboard.vue | High   | Convert + routing change       |

Phase 4: Code Conversion Examples 💻
═══════════════════════════════════════
Claude shows how each pattern converts:

BEFORE (React):
─────────────────
import React, { useState, useEffect } from 'react';
import './UserProfile.module.css';

function UserProfile({ userId }) {
  const [user, setUser] = useState(null);

  useEffect(() => {
    fetch(`/api/users/${userId}`)
      .then(res => res.json())
      .then(setUser);
  }, [userId]);

  return (
    <div className="profile">
      <h1>{user?.name}</h1>
      <button onClick={() => console.log('clicked')}>
        Edit Profile
      </button>
    </div>
  );
}

AFTER (Nuxt 4 + Vue 3):
─────────────────
<script setup>
const props = defineProps({
  userId: { type: String, required: true }
});

const { data: user } = await useFetch(`/api/users/${props.userId}`);

const handleEdit = () => {
  console.log('clicked');
};
</script>

<template>
  <div>
    <h1>{{ user?.name }}</h1>
    <UButton @click="handleEdit">
      Edit Profile
    </UButton>
  </div>
</template>

Phase 5: Implementation Plan 🗓️
═══════════════════════════════════════
Week 1:
Day 1-2: Set up Nuxt 4 project
Day 3-4: Migrate shared components
Day 5: Migrate state management (Context → Pinia)

Week 2:
Day 1-3: Migrate pages and routing
Day 4: Replace CSS Modules with Nuxt UI + Tailwind
Day 5: Testing and deployment

You: (Reviews plan, approves, Claude executes migration)
```

**What you get:**
- Framework detection
- Component-by-component mapping
- Code conversion examples
- Preserves all Cloudflare infrastructure
- Step-by-step migration

---

### 10. `/cf-worker` - Quick Worker Scaffolding

**What it does:** Generates a new Cloudflare Worker from a template

**When to use:**
- Starting a brand new Worker project
- Need a quick scaffold
- Want best practices from the start

**Real-world example:**

```
Scenario: You want to create a new API Worker

You: /cf-worker "Simple REST API for managing todos"

Claude asks clarifying questions:

What type of Worker?
1. API server (Hono)
2. Web app (Nuxt 4)
3. Background job
4. WebSocket server (Durable Objects)

You: 1 (API server)

What storage?
1. D1 database (SQL)
2. KV (key-value)
3. R2 (file storage)
4. Multiple

You: 1 (D1 database)

Claude generates complete project:

✅ Created project structure:
my-todo-api/
├── src/
│   ├── index.ts (main Worker)
│   └── routes/
│       ├── todos.ts (CRUD routes)
│       └── health.ts (health check)
├── wrangler.toml (configured)
├── package.json (with Hono, TypeScript)
├── tsconfig.json
└── schema.sql (D1 database schema)

✅ Generated src/index.ts:
import { Hono } from 'hono';
import todos from './routes/todos';
import health from './routes/health';

const app = new Hono();

app.route('/api/todos', todos);
app.route('/api/health', health);

export default app;

✅ Generated wrangler.toml:
name = "my-todo-api"
main = "src/index.ts"
compatibility_date = "2025-09-15"

[[d1_databases]]
binding = "DB"
database_name = "todos"
database_id = "..." # Create with: wrangler d1 create todos
remote = true

✅ Generated schema.sql:
CREATE TABLE todos (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  completed BOOLEAN DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

Next steps:
1. Run: pnpm install
2. Create D1: wrangler d1 create todos
3. Apply schema: wrangler d1 execute DB --file=schema.sql
4. Start dev: pnpm dev
5. Deploy: pnpm deploy
```

**What you get:**
- Complete project structure
- Best practices baked in
- Ready to code immediately
- All config files set up

---

## Real-World Impact

### Before This Plugin

**Typical conversation:**
```
You: "Help me build a Cloudflare Workers API"

Claude: "Sure! Let's use Express.js..."
❌ Express doesn't work in Workers!

You: "No, I need it to work with Cloudflare"

Claude: "Oh, right. Use this pattern..."
❌ Suggests outdated --remote flag

You: "That's deprecated. Use the new remote bindings"

Claude: "Okay, here's updated code..."
⚠️ Forgets to add remote = true to config

You: (Spends 30 minutes fixing AI mistakes)
```

### After This Plugin

**Same conversation:**
```
You: "Help me build a Cloudflare Workers API"

Claude: "I'll create a Hono API (Workers-compatible) with:
- D1 database with remote = true (connects to your real database)
- compatibility_date = 2025-09-15 (current)
- TypeScript types for your env bindings
- Nuxt UI for frontend (your preference)
- Bundle size optimized (< 500KB)

Here's the code..."

✅ Everything works the first time
✅ Follows all best practices
✅ Matches your preferences
✅ Ready to deploy

You: (Deploys in 2 minutes)
```

**Time saved:** Hours per project

---

## The Technology Stack (For the Curious)

If you're wondering "what's under the hood," here's the tech:

**Built on:**
- Claude Code (Anthropic's AI coding assistant)
- Claude Opus model (smartest model for complex reasoning)
- MCP (Model Context Protocol) for live data
- Git hooks for automation
- Markdown for configuration (easy to read/edit)

**Inspired by:**
- [Every's Compounding Engineering Plugin](https://github.com/EveryInc/every-marketplace/tree/main/plugins/compounding-engineering) by Kieran Klaassen
- Cloudflare's official best practices
- vibesdk AI tuning philosophy

**Designed for:**
- Cloudflare Workers (edge computing platform)
- Nuxt 4 (modern web framework)
- Hono (lightweight API framework)
- Vercel AI SDK (for AI features)

---

## Getting Started

**Step 1: Install**
```bash
/plugin marketplace add hirefrank/hirefrank-marketplace
/plugin install cloudflare-engineering
```

**Step 2: (Optional) Set up MCP**
Add to your Claude settings for real-time Cloudflare account access

**Step 3: (Optional) Set up stop hooks**
Copy hook script for automatic validation

**Step 4: Start using commands**
```
/review - Review your code
/plan "new feature" - Create a plan
/cf-deploy - Deploy safely
```

**Step 5: Let it learn**
The plugin improves with every project. Just use it naturally!

---

## Who Built This?

Created for developers who:
- Build on Cloudflare Workers
- Use AI coding assistants
- Value quality and best practices
- Want AI that "just gets it"

Built with love, coffee, and a lot of prompt engineering.

---

## Questions?

**"Does this work with other frameworks?"**
The plugin is optimized for Nuxt 4 and Hono. But `/cf-nuxt-migrate` can convert React, Vue 2, Svelte, and more to Nuxt 4!

**"Will it work with my existing Cloudflare project?"**
Yes! It's designed to integrate with existing projects. Just run `/review` to get started.

**"Does it require MCP?"**
No, MCP is optional but recommended. The plugin works fine without it, but MCP adds real-time account context.

**"Can I customize it?"**
Absolutely! All preferences are in `PREFERENCES.md`. The plugin learns from your feedback and updates itself.

**"What if Claude makes a mistake?"**
Correct it once, and the `feedback-codifier` agent will remember for next time.

**"How much does it cost?"**
The plugin itself is free. You just need Claude Code (paid) and a Cloudflare account (free tier available).

---

## The Bottom Line

**Before:** AI assistants give generic advice that often doesn't work with Cloudflare.

**After:** You have a specialized AI expert that knows Cloudflare inside-out, learns your preferences, and catches mistakes before they reach production.

**Result:** Build faster, deploy confidently, spend less time debugging.

It's like upgrading from a generic GPS to one that knows every shortcut, road closure, and speed trap in your city.

---

## Try It Today

Start building better Cloudflare Workers apps with an AI that truly understands the platform.

```bash
/plugin install cloudflare-engineering
/review
```

Happy coding! 🚀
