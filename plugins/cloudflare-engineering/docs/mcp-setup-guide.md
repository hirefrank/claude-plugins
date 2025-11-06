# MCP Server Setup Guide

This guide shows you how to configure official MCP (Model Context Protocol) servers to enhance the Cloudflare Engineering plugin with real-time account context and component documentation.

## Why Use MCP Servers?

**Without MCP**: Agents use static knowledge and can only analyze code files.

**With MCP**: Agents can:
- ✅ Query your real Cloudflare account (bindings, performance metrics, security events)
- ✅ Validate patterns against official Cloudflare documentation
- ✅ Get accurate Nuxt UI component APIs (no hallucinated props)
- ✅ Make data-driven recommendations based on your actual usage
- ✅ Reduce token usage by 98.7% (via execution environment filtering)

## Required MCP Servers

### 1. Cloudflare MCP Server (PRIORITY 1)

**What it provides**:
- Documentation search via Vectorize DB
- Bindings management (KV, R2, D1, DO namespaces)
- Performance metrics (cold starts, CPU time, request rates)
- Security events (DDoS attacks, rate limit violations)
- DNS and Digital Experience Monitoring data

**Setup**:

1. **Add to Claude Code settings** (`.config/claude/settings.json` or via UI):

```json
{
  "mcpServers": {
    "cloudflare-docs": {
      "type": "remote",
      "url": "https://docs.mcp.cloudflare.com/mcp",
      "enabled": true,
      "description": "Cloudflare documentation search and account context"
    }
  }
}
```

2. **Authenticate with Cloudflare**:
   - On first use, you'll be prompted to authenticate via OAuth
   - Opens browser to authorize Claude Code access to your Cloudflare account
   - Permissions: Read-only access to bindings, metrics, and documentation
   - **Secure**: Token stored locally, can revoke anytime from Cloudflare dashboard

3. **Verify connection**:
```bash
# In Claude Code, ask:
# "Can you check what KV namespaces exist in my Cloudflare account?"
# If MCP is working, you'll get real namespace data from your account
```

**Documentation**: https://docs.mcp.cloudflare.com/mcp

### 2. Nuxt UI MCP Server (PRIORITY 2)

**What it provides**:
- Complete Nuxt UI component catalog
- Accurate prop definitions (no hallucinations)
- Code examples and templates
- Composables documentation
- Component implementation generator

**Setup**:

1. **Add to Claude Code settings**:

```json
{
  "mcpServers": {
    "nuxt-ui": {
      "type": "remote",
      "url": "https://ui.nuxt.com/mcp",
      "enabled": true,
      "description": "Nuxt UI component documentation and implementation"
    }
  }
}
```

2. **No authentication required** (public MCP server)

3. **Verify connection**:
```bash
# In Claude Code, ask:
# "What props does UButton accept?"
# If MCP is working, you'll get accurate props from official Nuxt UI docs
```

**Documentation**: https://ui.nuxt.com/mcp

## Complete Configuration Example

Your `.config/claude/settings.json` should include:

```json
{
  "mcpServers": {
    "cloudflare-docs": {
      "type": "remote",
      "url": "https://docs.mcp.cloudflare.com/mcp",
      "enabled": true,
      "description": "Cloudflare documentation search and account context"
    },
    "nuxt-ui": {
      "type": "remote",
      "url": "https://ui.nuxt.com/mcp",
      "enabled": true,
      "description": "Nuxt UI component documentation and implementation"
    }
  }
}
```

## Verifying MCP Integration

### Test Cloudflare MCP

Ask Claude Code any of these:

1. **Bindings Check**:
   ```
   "What KV namespaces are configured in my Cloudflare account?"
   ```
   Expected: List of your actual KV namespaces with IDs

2. **Performance Metrics**:
   ```
   "What's my Worker's P99 cold start time?"
   ```
   Expected: Real cold start metrics from your account

3. **Documentation Search**:
   ```
   "What are the latest Cloudflare recommendations for Durable Objects state persistence?"
   ```
   Expected: Official Cloudflare documentation results

### Test Nuxt UI MCP

Ask Claude Code any of these:

1. **Component Props**:
   ```
   "What props does UForm accept?"
   ```
   Expected: Accurate props list from Nuxt UI docs

2. **Component List**:
   ```
   "What Nuxt UI components are available for forms?"
   ```
   Expected: List of form-related Nuxt UI components

3. **Implementation**:
   ```
   "Generate a UButton with primary color and large size"
   ```
   Expected: Correct component code with validated props

## Troubleshooting

### Cloudflare MCP not connecting

**Issue**: "Failed to authenticate with Cloudflare"

**Solutions**:
1. Check internet connection
2. Verify URL: `https://docs.mcp.cloudflare.com/mcp`
3. Try re-authenticating (revoke token from Cloudflare dashboard, try again)
4. Check Cloudflare account status

### Nuxt UI MCP not responding

**Issue**: "Cannot fetch Nuxt UI component data"

**Solutions**:
1. Verify URL: `https://ui.nuxt.com/mcp`
2. Check internet connection
3. Try disabling and re-enabling in settings

### Agents not using MCP

**Issue**: Agents provide generic answers instead of account-specific data

**Solutions**:
1. Verify MCP servers are `"enabled": true` in settings
2. Restart Claude Code after configuration changes
3. Explicitly mention your Cloudflare account: "Check MY Cloudflare account for..."
4. Check Claude Code logs for MCP connection errors

## Agent-Specific MCP Usage

Different agents use MCP servers for different purposes:

| Agent | Uses Cloudflare MCP? | Uses Nuxt UI MCP? | Purpose |
|-------|---------------------|-------------------|---------|
| binding-context-analyzer | ✅ Yes | ❌ No | Validate bindings exist in account |
| cloudflare-architecture-strategist | ✅ Yes | ✅ Yes | Resource discovery + component verification |
| cloudflare-security-sentinel | ✅ Yes | ❌ No | Security events + secret validation |
| edge-performance-oracle | ✅ Yes | ❌ No | Real performance metrics |
| cloudflare-pattern-specialist | ✅ Yes | ✅ Yes | Pattern validation + component checks |
| cloudflare-data-guardian | ✅ Yes | ❌ No | D1 schema + KV/R2 metrics |
| workers-runtime-guardian | ✅ Yes | ❌ No | Runtime API documentation |
| durable-objects-architect | ✅ Yes | ❌ No | DO metrics + patterns |
| feedback-codifier | ✅ Yes | ✅ Yes | **CRITICAL** - Validate before codifying |
| kv-optimization-specialist | ✅ Yes | ❌ No | KV usage metrics + optimization |
| r2-storage-architect | ✅ Yes | ❌ No | R2 metrics + bandwidth analysis |
| workers-ai-specialist | ✅ Yes | ✅ Yes | AI docs + UI components |
| edge-caching-optimizer | ✅ Yes | ❌ No | Cache hit rates + performance |

## Security and Privacy

### Cloudflare MCP OAuth

**What access does it have?**
- Read-only access to:
  - Bindings (KV, R2, D1, DO namespaces)
  - Metrics (performance, usage, security events)
  - Documentation (Cloudflare docs search)

**What it CANNOT do**:
- ❌ Create/modify resources
- ❌ Deploy Workers
- ❌ Change account settings
- ❌ Access secrets/environment variables (only sees that they exist, not values)
- ❌ Delete data

**Security**:
- OAuth token stored locally by Claude Code
- Token encrypted at rest
- Can revoke access anytime from Cloudflare dashboard → API Tokens
- Scoped permissions (read-only)
- HTTPS only

### Nuxt UI MCP

- **Public server** (no authentication required)
- **No account access** (just component documentation)
- **No data sent** (only receives queries, returns documentation)

## Benefits Summary

### With Both MCP Servers Configured

**Data-Driven Decisions**:
- "Your KV namespace is using 24.8GB (99% of limit) - add TTL to 70% of writes"
- Instead of: "Consider using TTL on KV writes"

**Accurate Component Usage**:
- "UButton props: `color`, `size`, `variant`, `icon`, `loading`"
- Instead of: "UButton probably has a `type` prop" (hallucinated)

**Real-Time Account Context**:
- "You already have a CACHE KV namespace. Reuse it?"
- Instead of: "Create a new KV namespace"

**Official Documentation**:
- "Cloudflare docs say: 'Use Durable Objects for rate limiting' (source: docs.cloudflare.com/...)"
- Instead of: "KV is probably fine for rate limiting" (wrong!)

**Token Efficiency**:
- Filter data in execution environment before passing to model
- 98.7% token reduction (per Anthropic's code execution pattern)

## Next Steps

1. ✅ Configure both MCP servers in Claude Code settings
2. ✅ Authenticate with Cloudflare (if prompted)
3. ✅ Test with example queries (see "Verifying MCP Integration" above)
4. ✅ Use Cloudflare Engineering plugin with full MCP enhancement

See [MCP Usage Examples](./mcp-usage-examples.md) for detailed agent workflows with MCP.

---

**Questions?**
- Cloudflare MCP: https://docs.mcp.cloudflare.com/mcp
- Nuxt UI MCP: https://ui.nuxt.com/mcp
- MCP Protocol: https://modelcontextprotocol.io
