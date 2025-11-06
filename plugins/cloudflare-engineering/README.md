# Cloudflare Engineering Plugin

AI-powered Cloudflare development tools that get smarter with every use. Specialized for Workers, Durable Objects, KV, R2, and edge computing.

**Philosophy**: Self-improving through feedback codification, multi-agent parallel analysis, and structured workflow orchestration.

**Architecture**: Inspired by [Every's Compounding Engineering Plugin](https://github.com/EveryInc/every-marketplace/tree/main/plugins/compounding-engineering) by Kieran Klaassen, adapted for Cloudflare-only development.

## Overview

This plugin transforms Claude Code into a Cloudflare Workers expert through:
- **16 specialized agents** (all with MCP integration)
- **6 workflow commands**
- **Self-improvement** through feedback codification
- **Multi-phase parallel execution**
- **Real-time account context** via MCP servers (optional but recommended)
- **Cloudflare-specific expertise** baked in

## 🚀 MCP Server Integration (Recommended)

Enhance agents with real-time Cloudflare account context and accurate component documentation:

### Quick Setup

```json
// Add to .config/claude/settings.json
{
  "mcpServers": {
    "cloudflare-docs": {
      "type": "remote",
      "url": "https://docs.mcp.cloudflare.com/mcp",
      "enabled": true
    },
    "nuxt-ui": {
      "type": "remote",
      "url": "https://ui.nuxt.com/mcp",
      "enabled": true
    }
  }
}
```

### What MCP Provides

**Without MCP**: Agents use static knowledge
- "Consider adding a KV namespace"
- "Bundle size should be < 50KB"
- "UButton probably has these props..."

**With MCP**: Agents use your real Cloudflare account
- "You already have a CACHE KV namespace (ID: abc123). Reuse it?"
- "Your bundle is 850KB causing 250ms cold starts. Target: < 50KB"
- "UButton props (validated): `color`, `size`, `variant`, `icon`, `loading`"

**Benefits**:
- ✅ **98.7% token reduction** (via execution environment filtering)
- ✅ **Real-time account data** (bindings, metrics, security events)
- ✅ **Accurate documentation** (always latest from Cloudflare)
- ✅ **No hallucinations** (Nuxt UI component props validated)
- ✅ **Data-driven recommendations** (based on your actual usage)

**Setup Guide**: See [docs/mcp-setup-guide.md](./docs/mcp-setup-guide.md)

## Installation

```bash
# Add the marketplace
/plugin marketplace add hirefrank/hirefrank-marketplace

# Install this plugin
/plugin install cloudflare-engineering

# Restart Claude Code to activate
```

## Stop Hooks (Optional but Recommended)

Automated validation and cleanup before ending sessions:

```bash
# Copy stop hook to Claude Code hooks directory
cp plugins/cloudflare-engineering/hooks/stop-cloudflare-validation.sh ~/.claude/hooks/
chmod +x ~/.claude/hooks/stop-cloudflare-validation.sh
```

**What it checks**:
- ✅ wrangler.toml syntax and validity
- ✅ compatibility_date is 2025-09-15+
- ✅ Remote bindings configuration
- ✅ TypeScript errors (if applicable)
- ✅ Bundle size estimation

**Prompt-based stop hook** (for comprehensive cleanup):

Add to `~/.claude/settings.json`:
```json
{
  "hooks": {
    "Stop": [
      {
        "type": "prompt",
        "prompt": "Before ending: Run pnpm typecheck, pnpm lint, pnpm test. Validate wrangler.toml. Check compatibility_date >= 2025-09-15. Verify bindings have remote = true. Remove console.log and unused code. Ensure files < 500 LOC. Verify all changes committed and pushed. Provide summary of work completed."
      }
    ]
  }
}
```

See `hooks/README.md` for detailed hook documentation and customization.

## Commands

### `/review` - Comprehensive Code Review

Multi-phase review with parallel Cloudflare-focused agents:
- Workers runtime compatibility
- Binding usage validation
- Security analysis (env vars, runtime isolation)
- Performance optimization (cold starts, edge patterns)
- Architecture assessment (Workers/DO/KV/R2 patterns)

**Example**:
```bash
/review
# Launches all agents in parallel
# Synthesizes findings with P1/P2/P3 priorities
# Creates triage-ready findings list
```

### `/work` - Execute Work Plan

Structured execution of work documents:
- Environment setup (Git worktree)
- Document analysis
- Task planning (TodoWrite)
- Sequential execution with validation
- Testing and PR creation

**Example**:
```bash
/work plan.md
# Sets up isolated worktree
# Breaks down tasks
# Executes systematically
# Validates each step
```

### `/plan` - Create GitHub Issues

Transform feature descriptions into well-structured GitHub issues:
- Repository research (Cloudflare patterns)
- Binding context analysis
- Issue structuring with templates
- Searchable titles and proper formatting

**Example**:
```bash
/plan Add real-time presence tracking with Durable Objects
# Researches existing patterns
# Analyzes available bindings
# Creates comprehensive GitHub issue
```

### `/triage` - Manage Findings

Process code review findings systematically:
- One-by-one presentation with severity
- User decision (yes/next/custom)
- Template-based todo creation
- Progress tracking with metrics

**Example**:
```bash
/triage
# Shows finding #1 of 15
# User: yes/next/custom
# Creates: 001-pending-p1-workers-runtime-violation.md
# Tracks: 1/15 complete, 14 remaining
```

### `/generate_command` - Create New Commands

Meta-command for creating custom commands:
- Analyzes requirements
- Generates command structure
- Includes agent orchestration patterns
- Creates documentation

### `/resolve_todo_parallel` - Parallel Todo Execution

Execute multiple todos concurrently:
- Identifies independent todos
- Runs in parallel worktrees
- Validates each completion
- Merges results

## Agents

All 16 agents are complete with MCP integration for enhanced real-time context.

### Model Assignments (Optimized for Cost/Performance)

Based on the latest Anthropic models (2025), agents are assigned models matching their complexity:

| Model | Count | Use Case | Agents |
|-------|-------|----------|--------|
| **Haiku 4.5** | 4 | Structured/rule-based tasks | `binding-context-analyzer`, `git-history-analyzer`, `repo-research-analyst`, `code-simplicity-reviewer` |
| **Sonnet 4.5** | 11 | Technical analysis & coding | `workers-runtime-guardian`, `durable-objects-architect`, `kv-optimization-specialist`, `r2-storage-architect`, `edge-caching-optimizer`, `edge-performance-oracle`, `cloudflare-security-sentinel`, `cloudflare-data-guardian`, `cloudflare-pattern-specialist`, `workers-ai-specialist`, `nuxt-migration-specialist` |
| **Opus 4.1** | 2 | Strategic/meta-learning | `cloudflare-architecture-strategist`, `feedback-codifier` |

**Rationale:**
- **Haiku 4.5**: 3x cheaper, 2x faster than Sonnet 4, perfect for config parsing, git commands, and rule application
- **Sonnet 4.5**: "Best coding model in the world" (Anthropic 2025), ideal for technical reviews and pattern detection
- **Opus 4.1**: Reserved for architecture decisions (creative/strategic) and feedback learning (meta-cognitive)

### Core Cloudflare Agents (3)

**`workers-runtime-guardian`** ✅
- Ensures Workers runtime compatibility (V8, not Node.js)
- Detects forbidden APIs (fs, process, Buffer)
- Validates env parameter patterns
- **MCP**: Queries latest Workers runtime docs

**`binding-context-analyzer`** ✅
- Parses wrangler.toml bindings (KV/R2/D1/DO)
- Generates TypeScript Env interface
- Validates binding usage in code
- **MCP**: Cross-checks bindings with real Cloudflare account

**`durable-objects-architect`** ✅
- DO lifecycle patterns & state persistence
- ID generation strategies (idFromName/idFromString/newUniqueId)
- WebSocket handling patterns
- **MCP**: Real DO metrics (active count, CPU, requests)

### Cloudflare Architecture Agents (5)

**`cloudflare-architecture-strategist`** ✅
- Workers/DO/KV/R2 architecture decisions
- Edge-first design patterns
- Service binding strategies
- **MCP**: Resource discovery + Nuxt UI component verification

**`cloudflare-security-sentinel`** ✅
- Workers security model (runtime isolation, env vars)
- Secret management (wrangler secret, not process.env)
- CORS, CSP, auth patterns
- **MCP**: Security events + secret validation + bundle analysis

**`edge-performance-oracle`** ✅
- Cold start optimization (bundle size, dependencies)
- Edge caching strategies (Cache API)
- Global latency patterns
- **MCP**: Real performance metrics (cold start, CPU, latency by region)

**`cloudflare-pattern-specialist`** ✅
- Cloudflare-specific patterns (KV TTL, DO state, service bindings)
- Anti-patterns (stateful Workers, KV for strong consistency)
- Idiomatic Cloudflare code
- **MCP**: Pattern validation against official docs + Nuxt UI checks

**`cloudflare-data-guardian`** ✅
- KV/D1/R2 data integrity & consistency models
- D1 migrations & schema validation
- Storage selection guidance
- **MCP**: D1 schema checks + KV/R2 usage metrics

### Specialized Storage Agents (4)

**`kv-optimization-specialist`** ✅
- TTL strategies (tiered, scheduled, cache-specific)
- Key naming & namespacing patterns
- Batch operations & pagination
- **MCP**: KV metrics (reads, writes, latency, storage limits)

**`r2-storage-architect`** ✅
- Upload patterns (simple, multipart, presigned URLs)
- Streaming & download optimization
- CDN integration & lifecycle
- **MCP**: R2 metrics (storage, bandwidth, request rates)

**`workers-ai-specialist`** ✅
- Vercel AI SDK patterns (REQUIRED per preferences)
- Cloudflare AI Agents (agentic workflows)
- RAG patterns (Vectorize + AI SDK)
- **MCP**: Latest AI docs + Nuxt UI for AI UIs

**`edge-caching-optimizer`** ✅
- Cache hierarchy (Browser/CDN/Cache API/KV/R2)
- Cache API patterns (stale-while-revalidate)
- Cache invalidation strategies
- **MCP**: Cache hit rates + performance metrics

### Generic (4 agents - unchanged)

**`feedback-codifier`** ✅
- **THE LEARNING ENGINE**
- Analyzes corrections from users
- Extracts recurring patterns
- Updates other agents automatically
- Makes the plugin "get smarter with every use"

**`git-history-analyzer`** ✅
- Analyzes commit history
- Identifies patterns over time
- Understands project evolution

**`repo-research-analyst`** ✅
- Researches codebase patterns
- Identifies conventions
- Documents findings with file paths

**`code-simplicity-reviewer`** ✅
- YAGNI enforcement
- Complexity reduction
- Cognitive load minimization

## How It Works

### Multi-Phase Workflow Example: `/review`

```markdown
**Phase 1: Context Gathering** (Parallel)
├─ binding-context-analyzer: Parse wrangler.toml
├─ repo-research-analyst: Understand codebase patterns
└─ git-history-analyzer: Review recent changes

**Phase 2: Cloudflare-Specific Review** (Parallel)
├─ workers-runtime-guardian: Runtime compatibility
├─ durable-objects-architect: DO pattern review
├─ binding-context-analyzer: Binding usage validation
└─ edge-performance-oracle: Performance analysis

**Phase 3: Security & Architecture** (Parallel)
├─ cloudflare-security-sentinel: Security review
├─ cloudflare-architecture-strategist: Architecture assessment
└─ cloudflare-pattern-specialist: Pattern detection

**Phase 4: Finding Synthesis**
- Consolidate all agent reports
- Classify by severity (P1/P2/P3)
- Remove duplicates
- Format for triage

**Phase 5: User Triage**
- Present findings one-by-one
- Create todos for approved items
- Track metrics
```

### Self-Improvement Loop

```markdown
1. User runs /cf-worker generate API endpoint
2. Claude generates code using Workers runtime patterns
3. User corrects: "Use Durable Objects for rate limiting"
4. feedback-codifier agent analyzes the correction
5. Extracts pattern: "Rate limiting → Durable Objects (not KV)"
6. Updates workers-runtime-guardian with new guideline
7. Next time: Automatically suggests Durable Objects for rate limiting
```

**Result**: Plugin learns from your corrections and preferences.

## Current Status

### ✅ Completed (Priority 1-5)

**Priority 1: Core Infrastructure** ✅
- [x] Plugin structure from compounding-engineering
- [x] 3 core Cloudflare agents created
- [x] All 6 commands preserved
- [x] User preferences codified (PREFERENCES.md)
- [x] MCP integration strategy (MCP-INTEGRATION.md)

**Priority 2: MCP Integration** ✅
- [x] All 13 Cloudflare agents with MCP integration
- [x] Real-time account context support
- [x] Documentation validation patterns
- [x] Nuxt UI component verification
- [x] MCP setup guide created
- [x] README updated with MCP benefits

**Priority 3: Specialized Agents** ✅
- [x] kv-optimization-specialist (TTL, naming, batching)
- [x] r2-storage-architect (uploads, streaming, CDN)
- [x] workers-ai-specialist (Vercel AI SDK, RAG)
- [x] edge-caching-optimizer (cache hierarchies, invalidation)

**Priority 4: Command Updates** ✅
- [x] Update all 6 commands with Cloudflare agent references
- [x] /review → reference all 16 agents in 4 phases
- [x] /plan → use binding-context-analyzer as critical first step
- [x] /work → validate with 4 Cloudflare agents after each task
- [x] /triage → add Cloudflare-specific tags
- [x] /generate_command → Workers examples and MCP integrations
- [x] /resolve_todo_parallel → no changes needed (already generic)

**Priority 5: Cloudflare Commands** ✅
- [x] Create /cf-deploy command (pre-flight + deployment)
- [x] Create /cf-migrate command (platform → Workers migration)

### 📋 Remaining Priorities

**Priority 6: Testing & Refinement** (8-12 hours)
- [ ] Test with real Cloudflare projects
- [ ] Validate agent orchestration
- [ ] Refine finding priorities
- [ ] Optimize parallel execution

## Usage Examples

### Example 1: Review Workers Code

```bash
# Run comprehensive review
/review

# Output:
🔍 Phase 1: Context Gathering (3 agents)...
✅ Found 4 bindings: KV, R2, DO, D1

🔍 Phase 2: Cloudflare Review (4 agents)...
🔴 CRITICAL: Using process.env (src/index.ts:45)
🟡 IMPORTANT: KV get without error handling (src/api.ts:23)

🔍 Phase 3: Synthesis...
Total findings: 12 (3 P1, 5 P2, 4 P3)

Ready for triage: /triage
```

### Example 2: Build New Feature

```bash
# Create GitHub issue from description
/plan Add WebSocket-based chat with Durable Objects

# Output creates comprehensive issue:
## Summary
Build real-time chat using Durable Objects for message coordination...

## Architecture
- 1 Worker: HTTP + WebSocket upgrade handler
- 1 Durable Object class: ChatRoom (manages connections)
- Bindings needed: CHAT_ROOM (DO), MESSAGES (KV)

## Files to Create
- src/chat-room.ts (Durable Object)
- src/index.ts (Worker, WebSocket handling)

[Full implementation plan...]
```

### Example 3: Execute Work Plan

```bash
# Execute the plan
/work .claude/todos/001-pending-p1-add-chat.md

# Output:
🔧 Creating worktree...
📋 Task breakdown:
  1. Create Durable Object class
  2. Add WebSocket handling
  3. Update wrangler.toml
  4. Write tests
  5. Deploy to preview

✅ Task 1/5 complete
✅ Task 2/5 complete
...
✅ All tasks complete
📤 Creating PR...
```

## Architecture Inspiration

This plugin adopts Every's compounding-engineering philosophy:

**From Every's Plugin**:
- ✅ Multi-agent orchestration
- ✅ Parallel execution
- ✅ Feedback codification (self-improvement)
- ✅ Multi-phase workflows
- ✅ Git worktree isolation
- ✅ Triage system
- ✅ Command structure

**Our Cloudflare Adaptation**:
- ✅ All agents specialized for Workers/DO/KV/R2
- ✅ Runtime compatibility enforcement
- ✅ Binding-aware code generation
- ✅ Edge-first architecture patterns
- ✅ Cloudflare security model
- ✅ wrangler.toml integration

**Result**: Proven architecture + Cloudflare expertise

## Contributing

### To This Plugin

Issues and suggestions:
- [GitHub Issues](https://github.com/hirefrank/hirefrank-marketplace/issues)
- Label: `cloudflare-engineering`

### To Upstream (Every's Plugin)

If you create genuinely generic improvements (not Cloudflare-specific), consider contributing to Every's original plugin:
- [Every Marketplace](https://github.com/EveryInc/every-marketplace)

## Credits

**Architecture & Philosophy**: [Every's Compounding Engineering Plugin](https://github.com/EveryInc/every-marketplace/tree/main/plugins/compounding-engineering) by Kieran Klaassen

**Cloudflare Adaptation**: Frank Harris (frank@hirefrank.com)

## License

MIT License

Original architecture: Copyright (c) 2024 Every Inc.
Cloudflare adaptations: Copyright (c) 2025 Frank Harris

See [LICENSE](./LICENSE) for full details.

## Resources

**MCP Servers**:
- [Cloudflare MCP](https://docs.mcp.cloudflare.com/mcp) - Account context + documentation
- [Nuxt UI MCP](https://ui.nuxt.com/mcp) - Component documentation
- [MCP Setup Guide](./docs/mcp-setup-guide.md) - Configuration instructions
- [MCP Protocol](https://modelcontextprotocol.io) - Official MCP specification

**Cloudflare Docs**:
- [Workers Documentation](https://developers.cloudflare.com/workers/)
- [Durable Objects](https://developers.cloudflare.com/durable-objects/)
- [Workers KV](https://developers.cloudflare.com/kv/)
- [R2 Storage](https://developers.cloudflare.com/r2/)
- [Wrangler CLI](https://developers.cloudflare.com/workers/wrangler/)

**User Preferences**:
- [PREFERENCES.md](./PREFERENCES.md) - Strict framework/SDK requirements
- [Nuxt 4](https://nuxt.com) - Required UI framework
- [Hono](https://hono.dev) - Required backend framework
- [Vercel AI SDK](https://ai-sdk.dev) - Required AI SDK
- [Cloudflare AI Agents](https://developers.cloudflare.com/agents/) - Agentic workflows

**Every's Original**:
- [Blog Post](https://every.to/source-code/my-ai-had-already-fixed-the-code-before-i-saw-it)
- [Plugin Repository](https://github.com/EveryInc/every-marketplace/tree/main/plugins/compounding-engineering)

## Version History

- **v1.0.0**: Initial release
  - Template copied from compounding-engineering
  - Language-specific agents removed
  - 3 Cloudflare agents created
  - 5 agents renamed for adaptation
  - All commands preserved
  - UPSTREAM tracking established
