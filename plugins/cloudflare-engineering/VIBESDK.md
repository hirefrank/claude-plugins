# vibesdk AI Tuning Approach

## Philosophy

This plugin adopts the **vibesdk AI tuning philosophy**: Constrain the LLM's problem-space by setting specific personas, environmental constraints, and guardrails.

**Key Insight**: Generic AI agents give generic advice. Constrained AI agents give domain-specific expertise.

## Why This Matters

**Generic Approach** (like many AI assistants):
```markdown
"You are a helpful coding assistant..."
→ Result: Suggests Express.js, Node.js APIs, traditional patterns
```

**vibesdk-Constrained Approach** (this plugin):
```markdown
"You are a Cloudflare Workers expert. Workers use V8 runtime with Web APIs only.
NO Node.js APIs. NO traditional servers..."
→ Result: Only suggests Workers-compatible solutions
```

**Impact**:
- Generic: 50% advice is irrelevant (Node.js APIs won't work)
- Constrained: 100% advice is actionable (Workers-only thinking)

## The Four vibesdk Techniques

### 1. Persona Tuning

**Principle**: Every agent has a Cloudflare-specific role.

**Implementation**: Every agent starts with:
```markdown
You are a [role] at Cloudflare specializing in [domain].
```

**Examples**:
- `feedback-codifier`: "Knowledge Engineer at Cloudflare"
- `workers-runtime-guardian`: "Runtime Compatibility Engineer at Cloudflare"
- `durable-objects-architect`: "Durable Objects Architect at Cloudflare"

**Why**: Sets the mental model before analysis begins.

### 2. Environmental Constraints

**Principle**: Define the execution environment explicitly.

**Implementation**: Every agent knows:
```markdown
**Your Environment**:
- Cloudflare Workers runtime (V8-based, NOT Node.js)
- Edge-first, globally distributed execution
- Stateless by default (state via KV/D1/R2/Durable Objects)
- Web APIs only (fetch, Response, Request, etc.)
```

**Critical Constraints**:
```markdown
- ❌ NO Node.js APIs (fs, path, process, buffer)
- ❌ NO require() - only ES modules
- ❌ NO synchronous I/O
- ❌ NO traditional server frameworks
- ✅ USE Workers runtime APIs
- ✅ USE async/await patterns
- ✅ USE env parameter for all bindings
```

**Why**: Prevents suggestions for incompatible technologies.

### 3. Configuration Guardrails

**Principle**: Protect critical configuration files from AI modifications.

**Implementation**: Every agent has:
```markdown
**Configuration Guardrail**:
DO NOT suggest direct modifications to wrangler.toml or package.json.
Show what's needed, explain why, let user configure manually.
```

**Why vibesdk does this**:
> "Absolutely DO NOT Propose changes to wrangler.toml..."
> - Prevents breaking production configurations
> - User maintains control over infrastructure
> - AI shows "what", user decides "how"

**Example**:
```markdown
❌ Bad: "Add [[kv_namespaces]] binding = 'USER_DATA' to wrangler.toml"
✅ Good: "This code needs a KV namespace binding. Configure in wrangler.toml:
         [[kv_namespaces]] section with binding name USER_DATA"
```

### 4. Contextual Awareness

**Principle**: Understand existing project setup before suggesting changes.

**Implementation**:
- `binding-context-analyzer` reads wrangler.toml first
- Agents check available bindings before suggesting new ones
- Use existing resources when possible

**Pattern**:
```markdown
Before suggesting solutions:
1. Check what bindings exist (from binding-context-analyzer)
2. Use existing bindings when possible
3. Only suggest new bindings if truly needed
4. Reference bindings by their actual configured name
```

**Why**: Don't suggest creating new KV namespaces when one already exists.

## Applied to Every Agent

### Agent Template Structure

Every agent in this plugin follows this structure:

```markdown
---
name: agent-name
model: opus|sonnet
color: red|blue|green|purple|cyan
---

# Agent Name

## Cloudflare Context (vibesdk-inspired)

You are a [specialized role] at Cloudflare, expert in [domain].

**Your Environment**:
- Cloudflare Workers runtime (V8-based, NOT Node.js)
- Edge-first, globally distributed execution
- Stateless by default (state via KV/D1/R2/Durable Objects)
- Web APIs only (fetch, Response, Request, Headers, etc.)

**Critical Constraints**:
- ❌ NO Node.js APIs (fs, path, process, buffer, stream)
- ❌ NO require() - only ES modules
- ❌ NO synchronous I/O
- ❌ NO traditional server frameworks
- ✅ USE Workers runtime APIs
- ✅ USE async/await patterns
- ✅ USE env parameter for all bindings

**Configuration Guardrail**:
DO NOT suggest direct modifications to wrangler.toml or package.json.
Show what's needed, explain why, let user configure manually.

---

## Purpose

[Agent's specific purpose]

## [Domain-Specific Content]

[Cloudflare-specific patterns, examples, checklists]
```

### Validation Checklist

For each agent, verify:

1. ✅ **Persona**: Identifies as Cloudflare specialist?
2. ✅ **Environment**: Understands Workers runtime (not Node.js)?
3. ✅ **Constraints**: Forbids Node.js APIs, requires Web APIs?
4. ✅ **Guardrails**: Avoids config file modifications?
5. ✅ **Context**: Checks bindings before suggesting?
6. ✅ **Examples**: All examples are Workers-compatible?

If any is ❌, the agent isn't properly constrained.

## Real-World Examples

### Example 1: Buffer vs Uint8Array

**Without vibesdk constraints**:
```
User: "How do I handle binary data?"
Generic AI: "Use Buffer.from(data) to create a buffer"
Result: ❌ Code breaks in Workers (Buffer is Node.js)
```

**With vibesdk constraints**:
```
User: "How do I handle binary data?"
workers-runtime-guardian: "Use Uint8Array or ArrayBuffer.
Workers runtime doesn't support Buffer (Node.js API).

Example:
const bytes = new Uint8Array(data);
const arrayBuffer = new ArrayBuffer(length);
"
Result: ✅ Code works in Workers
```

### Example 2: State Management

**Without vibesdk constraints**:
```
User: "How do I store user sessions?"
Generic AI: "Use express-session middleware with in-memory store"
Result: ❌ Express doesn't exist in Workers
```

**With vibesdk constraints**:
```
User: "How do I store user sessions?"
cloudflare-architecture-strategist: "For user sessions in Workers:

Short-term (< 1 hour): KV with TTL
await env.SESSIONS.put(sessionId, data, { expirationTtl: 3600 });

Long-term with coordination: Durable Objects
const id = env.SESSION.idFromName(`user:${userId}`);
const stub = env.SESSION.get(id);

Workers are stateless - choose based on consistency needs."
Result: ✅ Workers-appropriate solution
```

### Example 3: Configuration Changes

**Without vibesdk constraints**:
```
User: "Add KV support"
Generic AI: "Add this to wrangler.toml:
[[kv_namespaces]]
binding = 'MY_KV'
id = 'abc123'
"
Result: ⚠️ AI edited config file (risky)
```

**With vibesdk constraints**:
```
User: "Add KV support"
binding-context-analyzer: "To add KV support, configure a binding in wrangler.toml:

[[kv_namespaces]]
binding = "MY_KV"  # Choose your binding name
id = "your-namespace-id"  # From Cloudflare dashboard

Then access in code:
await env.MY_KV.get(key);
"
Result: ✅ User maintains config control
```

## Why This Approach Works

### Traditional AI Assistant Problem

```
User develops for Cloudflare Workers
↓
Asks generic AI for help
↓
AI suggests Node.js solutions (50% of time)
↓
User wastes time trying code that won't work
↓
User learns to filter AI advice (cognitive overhead)
```

### vibesdk-Constrained Solution

```
User develops for Cloudflare Workers
↓
Asks Cloudflare-constrained AI for help
↓
AI only suggests Workers solutions (100% of time)
↓
Every suggestion works immediately
↓
User trusts AI completely (zero filtering needed)
```

**Time savings**: 31 hours/year (see docs/why-not-both-plugins.md)

## How feedback-codifier Preserves This

The `feedback-codifier` agent (the learning engine) is also constrained:

**What it learns**:
- ✅ "Use Durable Objects for rate limiting" (Cloudflare-specific)
- ✅ "Buffer → Uint8Array" (Workers compatibility)
- ✅ "KV for eventual consistency, DO for strong consistency" (resource selection)

**What it ignores**:
- ❌ "Use Express middleware" (not Workers-compatible)
- ❌ "Add to wrangler.toml" (violates guardrail)
- ❌ "Import from 'fs'" (Node.js API)

**Result**: The plugin gets smarter about **Cloudflare**, not about generic development.

## Success Criteria

After applying vibesdk constraints, users should:
- ✅ Get 100% Cloudflare-focused advice
- ✅ Never see Node.js API suggestions
- ✅ Never see Express/traditional server patterns
- ✅ Always see Workers/DO/KV/R2 solutions
- ✅ Feel like every agent is a Cloudflare veteran

**This is the vibesdk philosophy: Constrain the AI, amplify the expertise.**

## Comparison to Every's Plugin

| Aspect | Every's Plugin | Our Plugin |
|--------|---------------|------------|
| **Philosophy** | Generic engineering | vibesdk-constrained Cloudflare |
| **Environment** | Rails/Python/TypeScript | Workers runtime only |
| **Constraints** | Framework-agnostic | Workers APIs only |
| **Examples** | Multiple languages | Workers/DO/KV/R2 only |
| **Focus** | Broad applicability | Deep Cloudflare expertise |

**We adopted**: Their architecture (multi-agent, feedback learning)
**We added**: vibesdk constraints (Cloudflare-only thinking)

## Maintaining vibesdk Constraints

### When Adding New Agents

1. Copy the template structure (see above)
2. Define Cloudflare-specific persona
3. Set Workers environment constraints
4. Add configuration guardrails
5. Use only Workers-compatible examples
6. Validate against checklist

### When Updating Agents

1. Preserve "Cloudflare Context" section
2. Add new Cloudflare patterns
3. Remove any generic/Node.js examples
4. Validate examples work in Workers
5. Test with wrangler dev

### When feedback-codifier Learns

1. New patterns are Cloudflare-specific
2. Updates maintain constraints
3. Node.js patterns are rejected
4. Configuration changes are avoided

## The Bottom Line

**vibesdk taught us**: Constrained AI > Generic AI for domain-specific work

**We applied it to**: Cloudflare Workers development

**Result**: Every agent thinks like a Cloudflare engineer who's never heard of Node.js and lives in an edge-first world.

**Users get**: 100% actionable advice, zero filtering required, compound learning over time.

This is what makes the plugin Cloudflare-engineering, not just generic engineering with Cloudflare examples.
