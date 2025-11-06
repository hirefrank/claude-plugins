# MCP Usage Examples

Real-world examples of how Cloudflare Engineering agents use MCP servers to provide data-driven, account-specific recommendations.

## Overview

This document shows **before/after comparisons** demonstrating the power of MCP integration. All examples use actual MCP server capabilities from:
- **Cloudflare MCP**: https://docs.mcp.cloudflare.com/mcp
- **Nuxt UI MCP**: https://ui.nuxt.com/mcp

---

## Example 1: Preventing Duplicate Resources

**Scenario**: User wants to add caching functionality

### Without MCP (Static Knowledge)

**User**: "I need to add caching for API responses. Should I create a new KV namespace?"

**Agent Response**:
```markdown
Yes, create a new KV namespace for caching:

1. Add to wrangler.toml:
   [[kv_namespaces]]
   binding = "CACHE"
   id = "your-namespace-id-here"

2. Use in Worker:
   await env.CACHE.put(key, value, { expirationTtl: 3600 });
```

**Result**: User creates duplicate KV namespace, increases complexity

### With MCP (Account Context)

**User**: "I need to add caching for API responses. Should I create a new KV namespace?"

**Agent Workflow**:
1. Call `cloudflare-bindings.listKV()`
2. **Sees**: Existing namespaces: `CACHE`, `SESSION_CACHE`, `USER_DATA`
3. Call `cloudflare-observability.getKVMetrics("CACHE")`
4. **Sees**: Only 10K operations/day, plenty of capacity

**Agent Response**:
```markdown
⚠️ You already have a KV namespace called "CACHE" (ID: abc123def456)
   Current usage: 10K ops/day
   Capacity: ~1M ops/day on free tier

Recommendation: REUSE your existing CACHE namespace instead of creating a new one.

Code example:
await env.CACHE.put(`api:${endpoint}`, response, {
  expirationTtl: 3600  // 1 hour
});
```

**Result**: ✅ Reuses existing resource, ✅ Simpler architecture, ✅ No duplicate namespaces

---

## Example 2: Data-Driven Performance Optimization

**Scenario**: User reports slow API responses

### Without MCP (Generic Advice)

**User**: "My Worker API is slow. How can I optimize it?"

**Agent Response**:
```markdown
Common Worker performance improvements:
1. Reduce bundle size (use native APIs instead of libraries)
2. Add edge caching (Cache API)
3. Minimize origin requests
4. Use parallel operations

Try these and see which helps most.
```

**Result**: User tries random optimizations without knowing the actual bottleneck

### With MCP (Metrics-Driven)

**User**: "My Worker API is slow. How can I optimize it?"

**Agent Workflow**:
1. Call `cloudflare-observability.getWorkerMetrics()`
2. **Sees**:
   - `coldStartP99: 250ms` ❌ (target < 10ms)
   - `cpuTimeP95: 8ms` ✅ (acceptable)
   - `requestLatencyP95: 280ms` ❌ (high)
3. Call `cloudflare-bindings.getWorkerScript()`
4. **Sees**: `bundleSize: 850KB` ❌ (target < 50KB)
5. Call `cloudflare-observability.getCacheHitRate()`
6. **Sees**: `cacheHitRate: 15%` ❌ (very low)

**Agent Response**:
```markdown
🔴 CRITICAL Performance Issues Identified:

1. Cold Start: 250ms P99 (target < 10ms)
   Root Cause: Bundle size is 850KB (target < 50KB)
   Impact: Every cold start adds 240ms+ latency

   Fix: Review dependencies
   - Check package.json for heavy libraries (moment, lodash, axios)
   - Replace with native alternatives
   - Target: Reduce to < 50KB for < 5ms cold starts

2. Cache Hit Rate: 15% (target > 80%)
   Impact: 85% of requests going to origin

   Fix: Add Cache API
   - Cache GET responses for 1 hour
   - Use stale-while-revalidate pattern
   - Expected: 80%+ hit rate → 200ms latency reduction

Priority: Fix bundle size FIRST (biggest impact: 240ms → 5ms)
```

**Result**: ✅ Specific, measurable targets, ✅ Prioritized fixes, ✅ Expected impact quantified

---

## Example 3: Preventing Security Issues

**Scenario**: User is implementing authentication

### Without MCP (Generic Security)

**User**: "I'm adding JWT authentication. Where should I store the secret?"

**Agent Response**:
```markdown
Store JWT secret as an environment variable:

1. Add to wrangler.toml:
   [vars]
   JWT_SECRET = "your-secret-here"  # ❌ WRONG!

2. Access in Worker:
   const secret = env.JWT_SECRET;
```

**Result**: ❌ Secret committed to git, ❌ Security vulnerability

### With MCP (Secret Validation)

**User**: "I'm adding JWT authentication. Where should I store the secret?"

**Agent Workflow**:
1. Scan code for `env.JWT_SECRET` usage
2. Call `cloudflare-bindings.listSecrets()`
3. **Sees**: Configured secrets: `API_KEY`, `DATABASE_URL` (no `JWT_SECRET`)
4. Call `cloudflare-docs.search("Workers secrets management")`
5. **Sees**: Official docs: "Use `wrangler secret put`, never [vars]"

**Agent Response**:
```markdown
🔐 Correct way to store JWT secret:

1. ❌ NEVER add to wrangler.toml [vars] section (visible in git!)

2. ✅ Use wrangler secret put:
   ```bash
   wrangler secret put JWT_SECRET
   # Prompts for value securely
   # Encrypted at rest
   # Not visible in code/git
   ```

3. ✅ Access in Worker:
   ```typescript
   const secret = env.JWT_SECRET;  // From secure secret storage
   ```

⚠️ Status Check:
Your Cloudflare account currently has these secrets configured:
- API_KEY ✅
- DATABASE_URL ✅
- JWT_SECRET ❌ (MISSING - add with `wrangler secret put JWT_SECRET`)

After adding JWT_SECRET, your code will work securely.
```

**Result**: ✅ Secure implementation, ✅ Real-time validation, ✅ Detected missing secret before deployment

---

## Example 4: Accurate Component Usage (Nuxt UI)

**Scenario**: User building a form in Nuxt 4 project

### Without MCP (Hallucinated Props)

**User**: "How do I create a submit button in Nuxt UI?"

**Agent Response**:
```vue
<UButton type="submit" color="primary" size="large">
  Submit Form
</UButton>
```

**Result**: ❌ Invalid prop `type` (doesn't exist), ❌ Invalid size `large` (should be `lg`)

### With MCP (Validated Props)

**User**: "How do I create a submit button in Nuxt UI?"

**Agent Workflow**:
1. Call `nuxt-ui.get_component("UButton")`
2. **Sees**: Valid props: `color`, `size`, `variant`, `icon`, `loading`, `submit` (NOT `type`)
3. **Sees**: Valid sizes: `xs`, `sm`, `md`, `lg`, `xl` (NOT `large`)
4. Call `nuxt-ui.implement_component_with_props()`

**Agent Response**:
```vue
<!-- Validated against official Nuxt UI API -->
<UButton
  :submit="true"
  color="primary"
  size="lg"
>
  Submit Form
</UButton>

<!-- Props validated:
  - ✅ submit: boolean (correct, not type: "submit")
  - ✅ color: "primary" (valid value)
  - ✅ size: "lg" (correct, not "large")
-->

<!-- Available UButton props (from Nuxt UI docs):
  - color: "primary" | "secondary" | "success" | "warning" | "error"
  - size: "xs" | "sm" | "md" | "lg" | "xl"
  - variant: "solid" | "outline" | "ghost" | "link"
  - icon: string (e.g., "i-heroicons-check")
  - loading: boolean
  - disabled: boolean
  - submit: boolean
  - ...
-->
```

**Result**: ✅ Correct props, ✅ No runtime errors, ✅ No hallucinations

---

## Example 5: Pattern Validation (Learning Engine)

**Scenario**: Feedback codifier validates patterns before codifying

### Without MCP (Unvalidated)

**User Feedback**: "Always use KV for rate limiting - it's fast enough"

**Agent Behavior**:
```markdown
Pattern extracted: "Use KV for rate limiting"
Codified to: workers-runtime-guardian.md
Reason: User feedback indicates KV is sufficient for rate limiting

Future reviews will recommend KV for rate limiting.
```

**Result**: ❌ Anti-pattern codified, ❌ Will recommend wrong approach to future users

### With MCP (Validated)

**User Feedback**: "Always use KV for rate limiting - it's fast enough"

**Agent Workflow**:
1. Extract proposed pattern: "KV for rate limiting"
2. Call `cloudflare-docs.search("KV rate limiting best practices")`
3. **Sees**: Official docs: "KV is eventually consistent. Use Durable Objects for rate limiting where strong consistency is required."
4. Call `cloudflare-docs.search("Durable Objects rate limiting")`
5. **Sees**: Official pattern: "Durable Objects provide atomic counters ideal for rate limiting"

**Agent Response**:
```markdown
❌ PATTERN REJECTED

Proposed: "Use KV for rate limiting"
Source: User feedback

Validation: ❌ CONTRADICTS official Cloudflare documentation

Official Cloudflare Guidance:
- KV is eventually consistent (no atomicity guarantees)
- Race conditions possible with concurrent requests
- Recommended: Durable Objects for rate limiting
  Source: https://developers.cloudflare.com/durable-objects/examples/rate-limiting/

Reason for rejection:
KV's eventual consistency model causes race conditions in rate limiting.
Two requests can both read the same count and both proceed, bypassing the limit.

Correct pattern: Use Durable Objects for strong consistency + atomic operations.

This pattern will NOT be codified.
```

**Result**: ✅ Anti-pattern rejected, ✅ Official docs cited, ✅ Future users get correct guidance

---

## Example 6: Cost Optimization

**Scenario**: User's KV storage is approaching limits

### Without MCP (No Awareness)

**User**: "My app is getting slower over time. Any ideas why?"

**Agent Response**:
```markdown
Possible causes of slowdown:
1. Increased traffic
2. Inefficient code paths
3. Network latency
4. Database performance

Run profiling to identify the bottleneck.
```

**Result**: Generic advice, actual problem not detected

### With MCP (Usage Monitoring)

**User**: "My app is getting slower over time. Any ideas why?"

**Agent Workflow**:
1. Call `cloudflare-observability.getKVMetrics("USER_DATA")`
2. **Sees**:
   - `storageUsed: 24.8GB` ❌ (approaching 25GB free tier limit!)
   - `keyCount: 50,000`
   - `avgValueSize: 512KB` (large!)
3. Scan code for KV writes
4. **Finds**: Only 30% of writes have TTL
5. Calculate: 35,000 keys without TTL → indefinite storage

**Agent Response**:
```markdown
🔴 CRITICAL: KV Storage at 99% Capacity!

Current Status:
- Storage: 24.8GB / 25GB (99% of free tier limit!)
- Keys: 50,000
- Average value size: 512KB (high)

Root Cause Analysis:
Scanned code: Only 30% of KV writes use expirationTtl
Impact: 35,000 keys stored indefinitely → 24.8GB accumulated

Immediate Fix Required:
1. Add TTL to all KV writes:
   ```typescript
   // ❌ Current (no TTL):
   await env.USER_DATA.put(key, value);

   // ✅ Fixed (with TTL):
   await env.USER_DATA.put(key, value, {
     expirationTtl: 86400  // 24 hours
   });
   ```

2. Cleanup script for existing keys:
   ```typescript
   // List all keys and add expiration
   const list = await env.USER_DATA.list();
   for (const key of list.keys) {
     const value = await env.USER_DATA.get(key.name);
     await env.USER_DATA.put(key.name, value, {
       expirationTtl: 86400
     });
   }
   ```

Expected Impact:
- Storage will decrease to ~7.4GB (70% reduction)
- Performance restored (fewer large keys)
- Cost: Stay within free tier
```

**Result**: ✅ Problem identified before limit hit, ✅ Specific fix with measurable impact, ✅ Cost savings

---

## Key Takeaways

### MCP Transforms Agents From Generic to Specific

| Capability | Without MCP | With MCP |
|-----------|-------------|----------|
| **Resource Awareness** | "Create a KV namespace" | "You already have CACHE (ID: abc). Reuse it?" |
| **Performance** | "Optimize bundle size" | "850KB bundle → 250ms cold start. Target: < 50KB" |
| **Security** | "Use env variables" | "JWT_SECRET missing. Add: `wrangler secret put`" |
| **Components** | "Use UButton" (hallucinated props) | "`color`, `size`, `submit`" (validated) |
| **Cost** | Generic advice | "24.8GB/25GB. Add TTL to 70% of writes" |

### Token Efficiency

**Without MCP**: Large context windows with entire documentation
```
Context: 50,000 tokens (all Cloudflare docs)
Result: Slow, expensive, may not find specific answer
```

**With MCP**: Filtered in execution environment
```
Context: 500 tokens (only relevant query results)
Result: 99% token reduction, faster, cheaper, precise answers
```

### Data-Driven Decision Making

Every recommendation backed by:
- ✅ Real account state (not assumptions)
- ✅ Actual performance metrics (not estimates)
- ✅ Official documentation (not outdated training data)
- ✅ Validated component APIs (no hallucinations)

---

## Setup

To enable these capabilities, configure MCP servers:

**Quick Setup**:
```json
// .config/claude/settings.json
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

**Full Guide**: See [mcp-setup-guide.md](./mcp-setup-guide.md)

---

## Agent-Specific MCP Usage

| Agent | Primary MCP Use | Example Query |
|-------|----------------|---------------|
| binding-context-analyzer | Binding validation | `getProjectBindings()` → Cross-check wrangler.toml |
| cloudflare-architecture-strategist | Resource discovery | `listKV()` → Suggest reuse, not duplication |
| cloudflare-security-sentinel | Secret validation | `listSecrets()` → Verify secrets configured |
| edge-performance-oracle | Performance metrics | `getWorkerMetrics()` → Data-driven optimization |
| cloudflare-pattern-specialist | Pattern validation | `docs.search()` → Verify against official docs |
| cloudflare-data-guardian | Schema validation | `getD1Schema()` → Prevent migration issues |
| kv-optimization-specialist | Usage metrics | `getKVMetrics()` → Prevent limit breaches |
| r2-storage-architect | Storage analysis | `getR2Metrics()` → Cost optimization |
| workers-ai-specialist | Latest AI docs | `docs.search("AI")` → Current patterns |
| edge-caching-optimizer | Cache effectiveness | `getCacheHitRate()` → Improve hit rates |
| feedback-codifier | **CRITICAL** Pattern validation | `docs.search()` → Reject anti-patterns |

---

**Next Steps**:
1. Configure MCP servers (5 minutes)
2. Test with example queries
3. Experience data-driven development
4. Never hallucinate component props again!
