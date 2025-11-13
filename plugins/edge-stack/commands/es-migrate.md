---
description: Migrate applications from other platforms to Cloudflare Workers with comprehensive analysis and validation
---

# Cloudflare Workers Migration Command

<command_purpose> Migrate applications from other platforms (Heroku, AWS Lambda, Vercel Functions, etc.) to Cloudflare Workers with comprehensive analysis, code transformation, and multi-agent validation. </command_purpose>

## Introduction

<role>Platform Migration Specialist with expertise in Cloudflare Workers, runtime compatibility, and multi-cloud architecture patterns</role>

This command analyzes your existing application, identifies migration challenges, transforms code for Workers compatibility, and guides you through a safe migration to Cloudflare's edge network.

## Prerequisites

<requirements>
- Existing application codebase (Node.js, Python, Go, etc.)
- Cloudflare account with Workers enabled
- wrangler CLI installed (`npm install -g wrangler`)
- Git repository for tracking migration changes
- Understanding of your current platform's architecture
</requirements>

## Migration Source

<migration_source> #$ARGUMENTS </migration_source>

**Supported platforms**:
- Heroku (Node.js, Python, Ruby)
- AWS Lambda (Node.js, Python, Go)
- Vercel Functions (Node.js, Edge Functions)
- Netlify Functions (Node.js)
- Google Cloud Functions (Node.js, Python, Go)
- Azure Functions (Node.js, Python)
- Custom Node.js applications
- Express/Fastify/Koa applications

**Target**: Cloudflare Workers (V8 runtime)

## Main Tasks

### 1. Platform Detection & Analysis

<thinking>
First, identify the current platform and analyze the application structure.
This informs all subsequent migration decisions.
</thinking>

#### Step 1: Detect Current Platform

**Automatic detection via files**:

```bash
# Check for platform-specific files
if [ -f "Procfile" ]; then
  echo "Detected: Heroku"
  PLATFORM="heroku"
elif [ -f "vercel.json" ]; then
  echo "Detected: Vercel"
  PLATFORM="vercel"
elif [ -f "netlify.toml" ]; then
  echo "Detected: Netlify"
  PLATFORM="netlify"
elif [ -d ".aws-sam" ] || grep -q "AWS::Serverless" template.yaml 2>/dev/null; then
  echo "Detected: AWS Lambda"
  PLATFORM="aws-lambda"
elif [ -f "function.json" ]; then
  echo "Detected: Azure Functions"
  PLATFORM="azure"
elif [ -f "cloudbuild.yaml" ]; then
  echo "Detected: Google Cloud Functions"
  PLATFORM="gcp"
else
  echo "Platform: Generic Node.js/Python/Go application"
  PLATFORM="generic"
fi
```

#### Step 2: Analyze Application Structure

**Discovery tasks** (run in parallel):

1. **List all endpoints/routes**
   ```bash
   # For Express apps
   grep -r "app\.\(get\|post\|put\|delete\|patch\)" src/

   # For serverless functions
   find . -name "*.handler.js" -o -name "api/*.ts"
   ```

2. **Identify runtime dependencies**
   ```bash
   # Node.js
   jq '.dependencies + .devDependencies' package.json

   # Python
   cat requirements.txt

   # Go
   cat go.mod
   ```

3. **Find environment variables**
   ```bash
   # Check for .env files
   cat .env.example .env 2>/dev/null | grep -v '^#' | cut -d= -f1

   # Check code for process.env usage
   grep -r "process\.env\." src/ --include="*.js" --include="*.ts"
   ```

4. **Detect database/storage usage**
   ```bash
   # Database clients
   grep -r "new.*Client\|createConnection\|mongoose\.connect" src/

   # Storage SDKs
   grep -r "S3Client\|Storage\|GridFS" src/
   ```

#### Step 3: Generate Migration Assessment Report

<deliverable>
Comprehensive report on migration complexity and requirements
</deliverable>

```markdown
## Migration Assessment Report

**Source Platform**: [Platform detected]
**Application Type**: [Web app / API / Background jobs]
**Primary Language**: [Node.js / Python / Go]

### Application Inventory

**Endpoints Discovered**: [X] routes
- GET: [count]
- POST: [count]
- PUT/PATCH: [count]
- DELETE: [count]

**Dependencies**: [Y] packages
- Compatible with Workers: [count] ✅
- Require replacement: [count] ⚠️
- Incompatible: [count] ❌

**Environment Variables**: [Z] variables
- Public config: [count]
- Secrets: [count]

**Data Storage**:
- Databases: [PostgreSQL / MySQL / MongoDB / etc.]
- File storage: [S3 / Local files / etc.]
- Caching: [Redis / Memcached / etc.]

### Migration Complexity

**Estimated Effort**: [Small / Medium / Large]
**Risk Level**: [Low / Medium / High]

**Complexity Factors**:
- [ ] Node.js-specific APIs (fs, process, Buffer) - [count] instances
- [ ] Long-running operations (> 30 seconds)
- [ ] Stateful operations (in-memory sessions)
- [ ] Large dependencies (> 50KB bundles)
- [ ] WebSocket connections (need Durable Objects)
- [ ] Database schema changes required
- [ ] Custom middleware/plugins

### Migration Strategy Recommendation

[Detailed strategy based on analysis]
```

### 2. Multi-Agent Migration Planning

<thinking>
Use specialized agents to analyze different aspects of the migration.
Run in parallel for comprehensive coverage.
</thinking>

#### Phase 1: Cloudflare Context Analysis (Parallel)

1. **Task binding-context-analyzer(migration source)**
   - Analyze current data storage needs
   - Recommend Cloudflare bindings (KV/R2/D1/DO)
   - Generate initial wrangler.toml structure
   - Map platform resources to Workers equivalents:
     - Redis → KV or Durable Objects
     - PostgreSQL/MySQL → D1
     - S3 → R2
     - Sessions → KV or Durable Objects
     - WebSockets → Durable Objects

2. **Task cloudflare-architecture-strategist(migration source)**
   - Design Workers architecture (single Worker vs. multiple)
   - Service binding strategy for microservices
   - Recommend DO usage for stateful components
   - Edge-first architecture patterns

3. **Task repo-research-analyst(migration source)**
   - Document current architecture patterns
   - Identify dependencies and integrations
   - Map data flows

#### Phase 2: Code Compatibility Analysis (Parallel)

4. **Task workers-runtime-guardian(current codebase)**
   - **CRITICAL**: Identify Node.js API usage
   - List all incompatible APIs (fs, process, Buffer, crypto, etc.)
   - Recommend Web API replacements
   - Estimate transformation effort

5. **Task cloudflare-pattern-specialist(current codebase)**
   - Identify anti-patterns for Workers
   - Detect stateful operations needing Durable Objects
   - Analyze request/response patterns
   - Recommend Cloudflare-idiomatic replacements

6. **Task edge-performance-oracle(current codebase)**
   - Analyze bundle size (target < 50KB for Workers)
   - Identify heavy dependencies needing replacement
   - Estimate cold start impact
   - Recommend performance optimizations

#### Phase 3: Data & Security Analysis (Parallel)

7. **Task cloudflare-data-guardian(current codebase)**
   - Analyze database schema and queries
   - D1 migration planning (if SQL database)
   - KV data modeling (if NoSQL)
   - R2 migration (if object storage)
   - Consistency model analysis

8. **Task cloudflare-security-sentinel(current codebase)**
   - Identify secrets and credentials
   - Plan migration to wrangler secret
   - CORS configuration for Workers
   - Auth pattern recommendations (Workers-compatible)

#### Phase 4: Specialized Analysis (Parallel - if applicable)

9. **Task durable-objects-architect(current codebase)**
   - Identify stateful components needing Durable Objects:
     - WebSocket connections
     - Real-time collaboration
     - Rate limiting
     - Distributed locks
   - Design DO classes
   - State persistence patterns

10. **Task workers-ai-specialist(current codebase)** (if AI features detected)
    - Identify AI/ML usage
    - Recommend Cloudflare AI or Vectorize alternatives
    - Vercel AI SDK integration patterns
    - RAG architecture (if needed)

### 3. Migration Plan Synthesis

<deliverable>
Detailed, step-by-step migration plan with todos
</deliverable>

<critical_requirement> Present complete migration plan for user approval before starting any code changes. </critical_requirement>

```markdown
## Cloudflare Workers Migration Plan

**Estimated Timeline**: [X weeks/days]
**Risk Level**: [Low/Medium/High]

### Phase 1: Infrastructure Setup (Day 1-2)

**Tasks**:
1. Create wrangler.toml configuration
   - Worker name: [name]
   - Account ID: [from wrangler whoami]
   - Compatibility date: [latest]

2. Set up Cloudflare bindings:
   - [ ] KV namespaces: [list]
   - [ ] R2 buckets: [list]
   - [ ] D1 databases: [list]
   - [ ] Durable Objects: [list]

3. Configure secrets:
   ```bash
   wrangler secret put DATABASE_URL
   wrangler secret put API_KEY
   # [etc.]
   ```

**Validation**: `wrangler whoami` and `wrangler dev` start successfully

---

### Phase 2: Code Transformation (Day 3-7)

**2.1 Runtime Compatibility**

Critical transformations (MUST DO):

| Current Code | Workers Replacement | Effort |
|--------------|-------------------|--------|
| `fs.readFileSync()` | Store in KV/R2, fetch at runtime | Medium |
| `process.env.VAR` | `env.VAR` (from handler) | Small |
| `Buffer.from()` | `TextEncoder/TextDecoder` or native Uint8Array | Small |
| `crypto` (Node.js) | Web Crypto API | Medium |
| `setTimeout` (long) | Durable Objects Alarms | Large |
| `express` middleware | Hono framework | Medium |

**Example transformations**:

```typescript
// ❌ OLD (Node.js / Express)
import express from 'express';
import fs from 'fs';

const app = express();

app.get('/data', (req, res) => {
  const data = fs.readFileSync('./data.json', 'utf-8');
  res.json(JSON.parse(data));
});

app.listen(3000);

// ✅ NEW (Cloudflare Workers + Hono)
import { Hono } from 'hono';

const app = new Hono();

app.get('/data', async (c) => {
  // Data stored in KV at build time or fetched from R2
  const data = await c.env.DATA_KV.get('data.json', 'json');
  return c.json(data);
});

export default app;
```

**2.2 Dependency Replacement**

| Heavy Dependency | Workers Alternative | Bundle Size Savings |
|-----------------|-------------------|-------------------|
| `axios` | `fetch()` (native) | ~12KB → 0KB |
| `moment` | `Date` or `Temporal` | ~70KB → 0KB |
| `lodash` | Native methods or `lodash-es` (tree-shake) | ~70KB → ~5KB |
| `bcrypt` | Web Crypto `crypto.subtle` | ~25KB → 0KB |
| `jsonwebtoken` | `jose` library (Workers-compatible) | ~15KB → ~8KB |

**2.3 Database Migration**

**If PostgreSQL/MySQL → D1**:

```bash
# Export existing schema
pg_dump --schema-only mydb > schema.sql

# Create D1 database
wrangler d1 create my-database

# Convert to SQLite-compatible SQL
# (remove PostgreSQL-specific syntax)

# Apply schema to D1
wrangler d1 execute my-database --file=schema.sql

# Migrate data (iterative batches)
# Export: pg_dump --data-only --table=users mydb > users.sql
# Import: wrangler d1 execute my-database --file=users.sql
```

**If MongoDB → KV or D1**:

- Small documents → KV (key-value)
- Relational queries needed → D1 (design relational schema)
- Large objects → R2 + metadata in KV/D1

**If Redis → KV or Durable Objects**:

- Simple caching → KV with TTL
- Atomic operations (INCR, etc.) → Durable Objects
- Pub/sub → Durable Objects with WebSockets

**2.4 Storage Migration**

**If S3 → R2**:

```typescript
// ❌ OLD (AWS S3)
import { S3Client, PutObjectCommand } from '@aws-sdk/client-s3';

const s3 = new S3Client({ region: 'us-east-1' });
await s3.send(new PutObjectCommand({
  Bucket: 'my-bucket',
  Key: 'file.txt',
  Body: buffer
}));

// ✅ NEW (Cloudflare R2)
export default {
  async fetch(request, env) {
    const buffer = await request.arrayBuffer();
    await env.MY_BUCKET.put('file.txt', buffer, {
      httpMetadata: { contentType: 'text/plain' }
    });
    return new Response('Uploaded');
  }
};
```

**Validation Tasks**:
- [ ] All Node.js APIs replaced with Web APIs
- [ ] All dependencies < 1MB total bundle
- [ ] TypeScript compiles without errors
- [ ] `wrangler dev` runs locally

---

### Phase 3: Testing & Validation (Day 8-10)

**3.1 Local Testing**

```bash
# Start Workers dev server
wrangler dev

# Test all endpoints
curl http://localhost:8787/api/users
curl -X POST http://localhost:8787/api/users -d '{"name":"test"}'

# Load testing
wrk -t4 -c100 -d30s http://localhost:8787/
```

**3.2 Agent Validation**

Run all agents on migrated code:

- Task workers-runtime-guardian(migrated code)
  - MUST be CRITICAL-free (no Node.js APIs)

- Task cloudflare-security-sentinel(migrated code)
  - Verify secrets not hardcoded
  - Check CORS configuration

- Task edge-performance-oracle(migrated code)
  - Bundle size < 50KB
  - Cold start < 10ms

- Task binding-context-analyzer(migrated code)
  - All bindings properly configured
  - TypeScript Env interface accurate

**3.3 Integration Testing**

- [ ] Database queries return correct data (D1/KV/R2)
- [ ] Authentication works (JWT validation, etc.)
- [ ] External API calls succeed (fetch to third-party APIs)
- [ ] Webhooks can be received
- [ ] Scheduled jobs work (if using Cron Triggers)

**Validation**: All critical paths tested, no P1 issues

---

### Phase 4: Staging Deployment (Day 11-12)

```bash
# Deploy to staging environment
wrangler deploy --env staging

# Smoke tests on staging
curl https://my-worker-staging.workers.dev/health

# Monitor logs
wrangler tail --env staging
```

**Validation**:
- [ ] All endpoints return 200 OK
- [ ] No runtime errors in logs
- [ ] Performance metrics acceptable (P95 < 100ms)
- [ ] Database connections work
- [ ] Secrets accessible

---

### Phase 5: Data Migration (Day 13-14)

**5.1 Read-Only Migration** (safe approach):

1. Keep old platform running (read/write)
2. Copy data to Cloudflare (D1/KV/R2)
3. Workers read from Cloudflare
4. Validate data integrity
5. Monitor for discrepancies

**5.2 Cutover Migration** (when confident):

1. Enable maintenance mode on old platform
2. Final data sync
3. Switch DNS to Workers
4. Disable old platform
5. Monitor closely

**Rollback Plan**:
- DNS TTL set to 60 seconds (fast rollback)
- Old platform on standby for 48 hours
- Database replication (if applicable)

---

### Phase 6: Production Deployment (Day 15)

**Pre-deployment checklist**:
- [ ] All tests pass
- [ ] Staging validated for 48+ hours
- [ ] Data migration complete
- [ ] Monitoring configured (Cloudflare Analytics)
- [ ] Rollback plan documented
- [ ] Team notified

**Deployment**:

Use the `/es-deploy` command:

```bash
/es-deploy
# Runs all pre-flight checks
# Deploys to production
# Validates deployment
```

**Post-deployment**:
- Monitor logs: `wrangler tail`
- Check analytics: https://dash.cloudflare.com
- Verify key endpoints
- Monitor error rates

---

### Phase 7: Optimization (Week 3-4)

**7.1 Performance Tuning**

- Task edge-caching-optimizer(production metrics)
  - Add Cache API for static responses
  - Implement stale-while-revalidate

- Task edge-performance-oracle(production metrics)
  - Analyze cold start P99
  - Optimize hot paths

**7.2 Cost Optimization**

- Task kv-optimization-specialist(KV usage)
  - Add TTL to 70%+ of KV writes
  - Implement tiered TTL strategy

- Task r2-storage-architect(R2 usage)
  - Optimize bandwidth (use CDN)
  - Implement lifecycle policies

**7.3 Decommission Old Platform**

After 2 weeks of stable production:
- [ ] Export final logs from old platform
- [ ] Document migration learnings
- [ ] Shut down old infrastructure
- [ ] Cancel old platform billing

---

## Migration Metrics

**Track these KPIs**:

| Metric | Old Platform | Target (Workers) | Actual |
|--------|-------------|-----------------|--------|
| P95 Response Time | [X]ms | < 50ms | __ |
| P99 Response Time | [Y]ms | < 100ms | __ |
| Error Rate | [Z]% | < 0.1% | __ |
| Monthly Cost | $[A] | < $[A/2] | __ |
| Global Availability | [B] regions | 300+ locations | __ |
| Cold Start | N/A | < 10ms | __ |

---

## Success Criteria

✅ **Migration considered successful when**:
- All endpoints migrated and functional
- No P1 runtime errors for 48 hours
- Performance meets or exceeds old platform
- Data integrity validated (100% match)
- Cost reduced by 30%+ (typical for Workers)
- Old platform successfully decommissioned
```

### 4. User Approval & Confirmation

<critical_requirement> MUST get explicit user approval before proceeding with any code changes or deployments. </critical_requirement>

**Present the migration plan and ask**:

```
📋 Migration Plan Complete

Summary:
- Estimated timeline: [X] days
- Risk level: [Low/Medium/High]
- Blocking issues: [count] must be addressed
- Warnings: [count] recommended improvements

Key transformations required:
1. [Major change 1]
2. [Major change 2]
3. [Major change 3]

Do you want to proceed with this migration plan?

Options:
1. yes - Start Phase 1 (Infrastructure Setup)
2. show-details - View detailed transformation examples
3. modify - Adjust plan before starting
4. export - Save plan to .claude/todos/ for later
5. no - Cancel migration
```

### 5. Automated Migration Execution

<thinking>
Only execute if user approves. Work through phases systematically.
</thinking>

**If user says "yes"**:

1. **Create migration branch**
   ```bash
   git checkout -b cloudflare-migration
   ```

2. **Phase 1: Infrastructure Setup**

   Create `wrangler.toml`:
   ```toml
   name = "my-app"
   main = "src/index.ts"
   compatibility_date = "2025-09-15"  # Always 2025-09-15 or later

   [[kv_namespaces]]
   binding = "CACHE"
   id = "..."  # User must fill in after creating
   remote = true  # Connect to real KV during development

   [[d1_databases]]
   binding = "DB"
   database_name = "my-database"
   database_id = "..."  # From wrangler d1 create
   remote = true  # Connect to real D1 during development

   [[r2_buckets]]
   binding = "STORAGE"
   bucket_name = "my-bucket"
   remote = true  # Connect to real R2 during development
   ```

3. **Phase 2: Code Transformation**

   For each identified incompatibility, present fix:

   ```
   ⚠️ Incompatibility #1: fs.readFileSync
   Location: src/utils/config.ts:12

   Current:
   const config = JSON.parse(fs.readFileSync('./config.json', 'utf-8'));

   Recommended fix:
   // Option 1: Store in KV (if dynamic config)
   const config = await env.CONFIG_KV.get('config', 'json');

   // Option 2: Import at build time (if static config)
   import config from './config.json';

   Apply fix? (yes/skip/custom)
   ```

4. **Phase 3: Testing**

   Run automated tests:
   ```bash
   npm run typecheck
   npm test
   wrangler dev  # Uses remote bindings configured in wrangler.toml
   # Test all endpoints at http://localhost:8787
   ```

5. **Phase 4: Deploy to Staging**

   ```bash
   wrangler deploy --env staging
   ```

### 6. Migration Validation Report

<deliverable>
Final migration report with metrics and next steps
</deliverable>

```markdown
## 🚀 Migration to Cloudflare Workers Complete

**Migration Date**: [timestamp]
**Total Duration**: [X] days
**Status**: ✅ SUCCESS / ⚠️ PARTIAL / ❌ FAILED

### Changes Summary

**Files Modified**: [count]
**Dependencies Replaced**: [count]
- [old-package] → [new-package]
- ...

**Bindings Created**:
- KV: [count] namespaces
- D1: [count] databases
- R2: [count] buckets
- DO: [count] classes

**Code Transformations**:
- Node.js APIs replaced: [count]
- Express → Hono: ✅
- Bundle size: [X]KB → [Y]KB ([-Z]% reduction)

### Performance Comparison

| Metric | Old Platform | Workers | Improvement |
|--------|-------------|---------|-------------|
| P95 Latency | [X]ms | [Y]ms | [Z]% faster |
| Cold Start | N/A | [A]ms | N/A |
| Global Locations | [B] | 300+ | [C]x increase |

### Deployment URLs

**Staging**: https://my-app-staging.workers.dev
**Production**: https://my-app.workers.dev
**Custom Domain**: (configure in Cloudflare dashboard)

### Post-Migration Tasks

**Immediate** (next 24 hours):
- [ ] Monitor error rates (target < 0.1%)
- [ ] Verify all critical endpoints
- [ ] Check database data integrity
- [ ] Validate secret access

**Short-term** (next week):
- [ ] Add Cache API for performance
- [ ] Implement edge caching strategy
- [ ] Configure custom domain
- [ ] Set up Cloudflare Analytics

**Long-term** (next month):
- [ ] Optimize bundle size further
- [ ] Add Durable Objects (if needed)
- [ ] Implement Workers AI features
- [ ] Decommission old platform

### Monitoring

**Logs**:
```bash
wrangler tail --format pretty
```

**Analytics**:
https://dash.cloudflare.com → Workers & Pages → [your-worker] → Metrics

**Alerts** (configure):
- Error rate > 1%
- CPU time > 50ms P95
- Request rate spike

### Rollback (if needed)

If issues detected:

```bash
# List deployments
wrangler deployments list

# Rollback to previous
wrangler rollback [previous-deployment-id]

# Or revert DNS to old platform
# (if DNS already switched)
```

### Cost Savings

**Old Platform**: $[X]/month
**Cloudflare Workers**: $[Y]/month
**Savings**: $[Z]/month ([P]% reduction)

Breakdown:
- Workers requests: $[A]
- KV operations: $[B]
- D1 queries: $[C]
- R2 storage: $[D]

### Success Criteria

- [✅/❌] All endpoints functional
- [✅/❌] Performance targets met
- [✅/❌] No P1 errors for 48 hours
- [✅/❌] Data integrity validated
- [✅/❌] Cost reduction achieved

---

**Migration Status**: [✅ COMPLETE / ⚠️ NEEDS ATTENTION]

**Recommended Next Steps**:
1. [Action 1]
2. [Action 2]
3. [Action 3]
```

## Platform-Specific Migration Guides

### Heroku → Workers

**Common patterns**:
- `Procfile` → `wrangler.toml`
- `process.env.PORT` → Not needed (Workers handle HTTP automatically)
- Postgres addon → D1 or external Postgres via Hyperdrive
- Redis addon → KV or Durable Objects
- Heroku Scheduler → Cron Triggers

**Example**:
```bash
# Heroku Procfile
web: node server.js

# Workers (no equivalent needed)
# HTTP handled by Workers runtime
```

### AWS Lambda → Workers

**Common patterns**:
- `handler(event, context)` → `fetch(request, env, ctx)`
- Lambda layers → npm packages (bundled)
- DynamoDB → D1 or KV
- S3 → R2
- CloudWatch → Cloudflare Analytics

**Example**:
```typescript
// AWS Lambda handler
export const handler = async (event, context) => {
  return {
    statusCode: 200,
    body: JSON.stringify({ message: 'Hello' })
  };
};

// Workers handler
export default {
  async fetch(request, env, ctx) {
    return new Response(JSON.stringify({ message: 'Hello' }), {
      headers: { 'content-type': 'application/json' }
    });
  }
};
```

### Vercel Functions → Workers

**Common patterns**:
- `api/*.ts` → Single Worker with Hono routing
- Vercel KV → Cloudflare KV
- Vercel Postgres → D1 or Hyperdrive
- Vercel Blob → R2
- Vercel Edge Functions → Already similar to Workers!

**Example**:
```typescript
// Vercel Function (api/hello.ts)
export default function handler(req, res) {
  res.status(200).json({ message: 'Hello' });
}

// Workers + Hono
import { Hono } from 'hono';
const app = new Hono();

app.get('/api/hello', (c) => {
  return c.json({ message: 'Hello' });
});

export default app;
```

## Troubleshooting

### Common Migration Issues

**Issue**: "Error: Cannot find module 'fs'"
**Solution**: Replace with KV/R2 or bundle file at build time
```typescript
// ❌ Runtime file read
const data = fs.readFileSync('./data.json');

// ✅ Build-time import
import data from './data.json';

// ✅ Runtime from KV
const data = await env.DATA_KV.get('data', 'json');
```

**Issue**: "Error: Buffer is not defined"
**Solution**: Use TextEncoder/TextDecoder or Uint8Array
```typescript
// ❌ Node.js Buffer
const buf = Buffer.from('hello', 'utf-8');

// ✅ Web APIs
const encoder = new TextEncoder();
const buf = encoder.encode('hello');
```

**Issue**: "Error: Worker exceeded CPU time limit"
**Solution**: Optimize heavy operations or use Durable Objects
- Use streaming for large responses
- Move long operations to Durable Objects with alarms
- Cache expensive computations

**Issue**: "Error: D1 database not found"
**Solution**: Verify binding name and database ID in wrangler.toml
```bash
# Create D1 database
wrangler d1 create my-database

# Add to wrangler.toml with exact ID from output
[[d1_databases]]
binding = "DB"  # Must match env.DB in code
database_id = "..." # From create command
```

**Issue**: Bundle size too large (> 1MB)
**Solution**:
- Replace heavy dependencies
- Use dynamic imports for optional features
- Enable tree-shaking
- Check for duplicate dependencies

## Best Practices

### Do's ✅

- **Start small**: Migrate one endpoint/route at a time
- **Test locally**: Use `wrangler dev` extensively before deploying
- **Staging first**: Always deploy to staging before production
- **Monitor closely**: Watch logs and metrics for first 48 hours
- **Keep rollback ready**: Maintain old platform for 1-2 weeks
- **Use MCP**: Configure Cloudflare MCP for real-time validation
- **Follow user preferences**: Hono (backend), Nuxt 4 (UI), Vercel AI SDK (AI)

### Don'ts ❌

- **Don't rush**: Take time to understand Workers runtime differences
- **Don't skip validation**: Run all agents before deployment
- **Don't ignore warnings**: P2 issues often become P1 in production
- **Don't hardcode secrets**: Always use `wrangler secret put`
- **Don't assume compatibility**: Test Node.js packages in Workers
- **Don't forget TTL**: Add expirationTtl to KV writes
- **Don't use heavy frameworks**: Avoid full Express, use Hono instead

## Success Metrics

Track these to measure migration success:

**Performance**:
- ✅ P95 latency < 50ms
- ✅ P99 latency < 100ms
- ✅ Cold start < 10ms

**Reliability**:
- ✅ Error rate < 0.1%
- ✅ Uptime > 99.9%

**Cost**:
- ✅ 30-70% cost reduction (typical)

**Developer Experience**:
- ✅ Faster deployments (< 30 seconds)
- ✅ Simpler infrastructure (no servers to manage)

---

**Remember**: Cloudflare Workers is a different runtime. Take time to learn the platform, use the specialized agents, and don't hesitate to ask for help with complex migrations.
