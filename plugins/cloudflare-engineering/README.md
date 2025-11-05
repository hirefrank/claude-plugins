# Cloudflare Engineering Plugin

AI-powered Cloudflare development tools that get smarter with every use. Specialized for Workers, Durable Objects, KV, R2, and edge computing.

**Philosophy**: Self-improving through feedback codification, multi-agent parallel analysis, and structured workflow orchestration.

**Architecture**: Inspired by [Every's Compounding Engineering Plugin](https://github.com/EveryInc/every-marketplace/tree/main/plugins/compounding-engineering) by Kieran Klaassen, adapted for Cloudflare-only development.

## Overview

This plugin transforms Claude Code into a Cloudflare Workers expert through:
- 16 specialized agents (12 implemented, 4 planned)
- 6 workflow commands
- Self-improvement through feedback codification
- Multi-phase parallel execution
- Cloudflare-specific expertise baked in

## Installation

```bash
# Add the marketplace
/plugin marketplace add hirefrank/hirefrank-marketplace

# Install this plugin
/plugin install cloudflare-engineering

# Restart Claude Code to activate
```

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

### Cloudflare-Specific (3 implemented)

**`workers-runtime-guardian`** ✅ Implemented
- Ensures Workers runtime compatibility
- Detects Node.js API usage
- Validates env parameter patterns
- P1/P2/P3 severity classification

**`binding-context-analyzer`** ✅ Implemented
- Parses wrangler.toml bindings
- Generates TypeScript Env interface
- Validates binding usage in code
- Provides context to other agents

**`durable-objects-architect`** ✅ Implemented
- Durable Objects lifecycle patterns
- State management best practices
- ID generation strategies
- WebSocket handling patterns

**Planned** (TODO):
- `kv-optimization-specialist` - KV best practices
- `r2-storage-architect` - R2 patterns
- `workers-ai-specialist` - Workers AI integration
- `edge-caching-optimizer` - Cache API patterns

### Adapted for Cloudflare (5 agents)

**`cloudflare-architecture-strategist`** 🔄 Needs adaptation
- Workers/DO/KV/R2 architecture
- Edge-first design patterns
- Service binding strategies
- Currently generic - needs Cloudflare examples

**`cloudflare-security-sentinel`** 🔄 Needs adaptation
- Workers security model
- Env variable handling
- Runtime isolation patterns
- Currently generic - needs Cloudflare context

**`edge-performance-oracle`** 🔄 Needs adaptation
- Cold start optimization
- Edge caching strategies
- Global latency patterns
- Currently generic - needs edge focus

**`cloudflare-pattern-specialist`** 🔄 Needs adaptation
- Cloudflare-specific patterns
- Anti-patterns in Workers
- Idiomatic Cloudflare code
- Currently generic - needs Cloudflare examples

**`cloudflare-data-guardian`** 🔄 Needs adaptation
- KV/D1/R2 data patterns
- Consistency models
- Storage selection guidance
- Currently generic - needs Cloudflare storage focus

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

### ✅ Completed

- [x] Plugin structure copied from compounding-engineering
- [x] Language-specific agents removed (8 agents)
- [x] Generic agents preserved (4 agents)
- [x] Agents renamed for Cloudflare context (5 agents)
- [x] 3 key Cloudflare agents created:
  - workers-runtime-guardian
  - binding-context-analyzer
  - durable-objects-architect
- [x] All 6 commands preserved
- [x] UPSTREAM tracking setup
- [x] Attribution in LICENSE and plugin.json

### 🚧 In Progress

- [ ] Adapt 5 renamed agents with Cloudflare context
  - Replace generic examples with Workers/DO/KV/R2 examples
  - Add Cloudflare-specific patterns
  - Update security model for Workers
  - Focus performance on edge optimization

### 📋 Planned

- [ ] Create 4 additional Cloudflare agents:
  - kv-optimization-specialist
  - r2-storage-architect
  - workers-ai-specialist
  - edge-caching-optimizer

- [ ] Update commands with Cloudflare agent references:
  - /review → reference all Cloudflare agents
  - /plan → use binding-context-analyzer
  - /work → validate with workers-runtime-guardian

- [ ] Add Cloudflare-specific commands:
  - /cf-deploy → pre-flight checks + deployment
  - /cf-migrate → migration assistance (platform → Workers)

- [ ] Testing and validation:
  - Test all commands with real Cloudflare projects
  - Validate agent orchestration
  - Refine finding priorities
  - Optimize parallel execution

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

**Cloudflare Docs**:
- [Workers Documentation](https://developers.cloudflare.com/workers/)
- [Durable Objects](https://developers.cloudflare.com/durable-objects/)
- [Workers KV](https://developers.cloudflare.com/kv/)
- [R2 Storage](https://developers.cloudflare.com/r2/)
- [Wrangler CLI](https://developers.cloudflare.com/workers/wrangler/)

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
