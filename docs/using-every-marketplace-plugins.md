# Using Every Marketplace Plugins with Your Cloudflare Projects

**Quick Answer:** You don't need to rewrite anything! You can use the compounding-engineering plugin directly from the Every marketplace.

---

## Immediate Setup (2 minutes)

### Step 1: Add the Every Marketplace

```bash
/plugin marketplace add EveryInc/every-marketplace
```

This adds their marketplace alongside yours. You'll now have access to:
- ✅ Your hirefrank marketplace plugins
- ✅ Every's compounding-engineering plugin
- ✅ All other Every marketplace plugins

### Step 2: Install the Plugin

```bash
/plugin install compounding-engineering
```

### Step 3: Start Using It

```bash
# Review any PR (including Cloudflare projects)
/review

# Create detailed GitHub issues
/plan "Add caching layer to Cloudflare Worker"

# Execute work plans systematically
/work

# Triage findings into actionable todos
/triage
```

---

## Available Commands

### `/review` - Comprehensive Code Review

**What it does:**
- Creates isolated git worktree
- Runs 6-8 specialized agents in parallel
- Analyzes security, performance, architecture, code quality
- Generates prioritized findings (P1/P2/P3)

**Perfect for:**
- Reviewing Cloudflare Worker code
- Validating edge function security
- Performance analysis for serverless functions
- Architecture review of distributed systems

**Usage:**
```bash
# Review current PR
/review

# The command will:
1. Create worktree in .worktrees/pr-XXX
2. Auto-detect your tech stack (TypeScript, etc.)
3. Run parallel agents:
   - security-sentinel (OWASP, vulnerabilities)
   - performance-oracle (bottlenecks, N+1 queries)
   - architecture-strategist (design patterns, coupling)
   - kieran-typescript-reviewer (if TypeScript detected)
   - pattern-recognition-specialist (anti-patterns)
4. Generate comprehensive findings report
5. Present for triage
```

---

### `/plan` - Create GitHub Issues

**What it does:**
- Researches project conventions
- Analyzes framework documentation
- Creates well-structured GitHub issues
- Includes technical context and success criteria

**Perfect for:**
- Planning Cloudflare Worker features
- Documenting infrastructure improvements
- Creating implementation specs
- Bug reports with full context

**Usage:**
```bash
/plan "Add rate limiting to Cloudflare Worker API endpoints"
```

**Output:**
- Researched issue with:
  - Clear title and description
  - Technical considerations
  - Acceptance criteria
  - Risk analysis
  - Implementation phases (if complex)

---

### `/work` - Execute Work Plans

**What it does:**
- Reads work document/plan
- Creates feature branch and worktree
- Builds todo list from requirements
- Executes tasks systematically
- Validates and tests
- Creates PR when complete

**Perfect for:**
- Implementing features from specs
- Following step-by-step guides
- Executing migration plans
- Building from requirements docs

**Usage:**
```bash
# Create a plan.md file with your requirements
/work docs/cloudflare-cache-plan.md
```

**Workflow:**
1. Environment setup (branch, worktree)
2. Document analysis (extract todos)
3. Systematic execution (one task at a time)
4. Completion (tests, commit, PR)

---

### `/triage` - Convert Findings to Todos

**What it does:**
- Presents findings one by one
- User decides: Yes / Next / Custom
- Creates structured todo files
- Tracks for future work

**Perfect for:**
- Processing code review findings
- Prioritizing security issues
- Planning refactoring work
- Managing technical debt

**Usage:**
```bash
# After running /review, you'll have findings
/triage

# For each finding:
# ⚠️  P1 - CRITICAL: SQL Injection Risk
# Location: api/database.ts:45
# [Description and solution]
#
# Create todo? (yes/next/custom): yes
# ✅ Created: 001-pending-p1-sql-injection-fix.md
```

---

## Cloudflare-Specific Use Cases

### 1. Worker Security Review

```bash
# Checkout worker PR
gh pr checkout 123

# Run comprehensive review
/review

# Common findings for Workers:
# - Environment variable handling
# - API key exposure
# - CORS configuration
# - Input validation
# - Rate limiting gaps
```

### 2. Edge Function Performance

```bash
# The performance-oracle agent will check:
# ✅ Cold start optimization
# ✅ Bundle size
# ✅ Cache utilization
# ✅ Database query efficiency
# ✅ Async operation handling
```

### 3. Creating Worker Feature Issues

```bash
/plan "Add Redis caching layer to reduce D1 database load"

# Will research:
# - Cloudflare Workers KV vs Durable Objects vs external Redis
# - Your existing caching patterns
# - D1 optimization best practices
# - Cost implications
```

### 4. Executing Infrastructure Changes

```bash
# Create migration-plan.md with steps
# Then execute:
/work docs/migration-plan.md

# The command will:
# - Parse each step as a todo
# - Execute systematically
# - Validate after each step
# - Handle errors gracefully
```

---

## Advanced: Combining Both Marketplaces

You can use plugins from both marketplaces together!

### Example Workflow

```bash
# Use YOUR plugin to analyze conversations
/analyze-skills

# Use THEIR plugin to review the generated skills
/review

# Use THEIR plugin to plan next features
/plan "Add web-based workflow analyzer"

# Use YOUR plugin to troubleshoot issues
/skills-troubleshoot
```

### Why This Works

Claude Code's plugin system is designed for composition:
- Multiple marketplaces coexist peacefully
- Plugins are isolated and don't conflict
- Commands from both are available
- You can reference external tools in your plugins

---

## Creating Cloudflare-Specific Reviewers

Want to extend the compounding-engineering plugin with Cloudflare expertise? You can create a specialized agent:

### Option A: Fork and Extend

```bash
# Fork the Every marketplace
# Add your agent: cloudflare-worker-specialist.md

## Agent: cloudflare-worker-specialist

**Purpose:** Review Cloudflare Workers, Pages, and edge functions

**Responsibilities:**
- Workers API usage validation
- KV/D1/Durable Objects best practices
- Edge caching strategies
- CPU time optimization
- Bundle size analysis

**Integration:**
Extend the /review command to include this agent when
Cloudflare platforms are detected.
```

### Option B: Create Complementary Plugin

Create a plugin in YOUR marketplace that works alongside theirs:

```bash
# In hirefrank-marketplace/plugins/cloudflare-reviewer/

commands/
  review-worker.md      # Cloudflare-specific review
  optimize-worker.md    # Performance optimization

agents/
  worker-security.md    # Cloudflare security patterns
  worker-performance.md # Edge optimization
```

Then use together:
```bash
# General review
/review

# Cloudflare-specific review
/review-worker
```

---

## Recommended Approach

**For immediate use:** Just install and use it as-is
```bash
/plugin marketplace add EveryInc/every-marketplace
/plugin install compounding-engineering
/review  # Use on your Cloudflare projects right now!
```

**For long-term:** Consider creating Cloudflare-specific extensions
- Add cloudflare-worker-specialist agent
- Create platform-specific commands
- Contribute back to Every marketplace OR
- Create complementary plugin in your marketplace

---

## Key Insights

1. **No Rewriting Needed** - Use their plugin directly
2. **Platform Agnostic** - Works with any codebase, including Cloudflare
3. **Composable** - Both marketplaces work together
4. **Extensible** - You can add Cloudflare-specific agents
5. **Immediate Value** - Start using in 2 minutes

---

## Next Steps

1. **Right now:** Add marketplace and install plugin (see Step 1-2)
2. **This week:** Try `/review` on a Cloudflare PR
3. **This month:** Create Cloudflare-specific agents if needed
4. **Long-term:** Build complementary plugins in your marketplace

---

## Questions?

**Q: Will this conflict with my marketplace?**
A: No! Multiple marketplaces coexist. Your plugins remain available.

**Q: Do I need to configure anything for Cloudflare?**
A: No! It auto-detects TypeScript and applies appropriate reviewers.

**Q: Can I modify their agents?**
A: You can fork their marketplace and customize, or create complementary agents in yours.

**Q: What if I want Cloudflare-specific checks?**
A: Three options:
1. Use as-is (TypeScript reviewer will catch most issues)
2. Fork and add cloudflare-worker-specialist agent
3. Create complementary plugin in your marketplace

**Q: Does /review work with Workers KV, D1, Durable Objects?**
A: The general patterns apply (security, performance, architecture). For platform-specific checks, you'd add a specialized agent.
