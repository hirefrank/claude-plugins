---
description: Perform comprehensive pre-flight checks and deploy Cloudflare Workers safely using wrangler
---

# Cloudflare Workers Deployment Command

<command_purpose> Perform comprehensive pre-flight checks and deploy Cloudflare Workers safely using wrangler with multi-agent validation. </command_purpose>

## Introduction

<role>Cloudflare Deployment Specialist with expertise in Workers deployment, wrangler CLI, and production readiness validation</role>

This command performs thorough pre-deployment validation, runs all necessary checks, and safely deploys your Worker to Cloudflare's edge network.

## Prerequisites

<requirements>
- Cloudflare account with Workers enabled
- wrangler CLI installed (`npm install -g wrangler`)
- Authenticated with Cloudflare (`wrangler login`)
- Valid `wrangler.toml` configuration
- Clean git working directory (recommended)
</requirements>

## Deployment Target

<deployment_target> #$ARGUMENTS </deployment_target>

**Supported targets**:
- Empty (default) - Deploy to production
- `--env staging` - Deploy to staging environment
- `--env preview` - Deploy to preview environment
- `--dry-run` - Perform all checks without deploying

## Main Tasks

### 1. Pre-Flight Checks (Critical - Must Pass)

<critical_requirement> ALL pre-flight checks must pass before deployment. No exceptions. </critical_requirement>

#### Phase 1: Configuration Validation

<thinking>
First, validate the wrangler.toml configuration and ensure all required settings are present.
</thinking>

**Checks to perform**:

1. **Verify wrangler.toml exists**
   ```bash
   if [ ! -f wrangler.toml ]; then
     echo "❌ CRITICAL: wrangler.toml not found"
     exit 1
   fi
   ```

2. **Validate required fields**
   - Task binding-context-analyzer(deployment target)
     - Parse wrangler.toml
     - Verify all bindings have valid IDs
     - Check compatibility_date is 2025-09-15 or later (required for remote bindings GA)
     - Verify all bindings have `remote = true` configured for development
     - Validate name, main, and account_id fields

3. **Check authentication**
   ```bash
   wrangler whoami
   # Verify logged in to correct account
   ```

#### Phase 2: Code Quality Checks

Run these agents in parallel for comprehensive validation:

**Critical Checks (Must Pass)**:

1. Task workers-runtime-guardian(current code)
   - Verify no Node.js APIs (fs, process, Buffer)
   - Ensure env parameter usage
   - Validate Web APIs only
   - **Status**: Must be CRITICAL-free (P1 issues block deployment)

2. Task cloudflare-security-sentinel(current code)
   - Check no hardcoded secrets
   - Verify secrets configured via wrangler secret
   - Validate CORS configuration
   - Ensure input validation present
   - **Status**: Must be CRITICAL-free (P1 security issues block deployment)

3. Task binding-context-analyzer(current code)
   - Verify all code bindings match wrangler.toml
   - Check no references to undefined bindings
   - Validate TypeScript Env interface accuracy
   - **Status**: Must have no mismatches

**Important Checks (Warnings)**:

4. Task edge-performance-oracle(current code)
   - Check bundle size (target < 50KB, warn if > 100KB)
   - Verify no heavy dependencies
   - Analyze cold start implications
   - **Status**: P2 issues generate warnings

5. Task cloudflare-pattern-specialist(current code)
   - Verify Cloudflare best practices
   - Check for anti-patterns (stateful Workers, KV for strong consistency)
   - Validate DO state persistence patterns
   - **Status**: P2 issues generate warnings

#### Phase 3: Build & Test

<thinking>
Build the Worker and run tests to ensure everything works before deployment.
</thinking>

1. **Clean previous builds**
   ```bash
   rm -rf dist/ .wrangler/
   ```

2. **Install dependencies**
   ```bash
   npm ci  # Clean install from lock file
   ```

3. **Type checking**
   ```bash
   npm run typecheck || tsc --noEmit
   ```

4. **Linting**
   ```bash
   npm run lint
   ```

5. **Run tests**
   ```bash
   npm test
   ```

6. **Build Worker**
   ```bash
   wrangler deploy --dry-run --outdir=./dist
   ```

7. **Analyze bundle size**
   ```bash
   du -h ./dist/*.js
   # Warn if > 100KB, error if > 500KB
   ```

#### Phase 4: Local Testing (Optional but Recommended)

<thinking>
Test the Worker locally with wrangler dev to catch runtime issues.
</thinking>

Ask user: "Run local testing with wrangler dev? (recommended, y/n)"

If yes:
1. Start wrangler dev in background
2. Wait 5 seconds for startup
3. Test basic endpoints:
   ```bash
   curl http://localhost:8787/
   # Verify 200 response
   ```
4. Stop wrangler dev

### 2. Pre-Deployment Summary

<deliverable>
Present comprehensive pre-deployment report to user
</deliverable>

```markdown
## Deployment Pre-Flight Summary

**Target Environment**: [production/staging/preview]
**Worker Name**: [from wrangler.toml]
**Account**: [from wrangler whoami]

### ✅ Configuration
- wrangler.toml: Valid
- Bindings: [X] configured
  - KV: [list]
  - R2: [list]
  - D1: [list]
  - DO: [list]
- Compatibility Date: [date] (✅ recent / ⚠️ outdated)

### ✅ Code Quality
- Runtime Compatibility: [PASS/FAIL]
  - Issues: [X] Critical, [Y] Important
- Security: [PASS/FAIL]
  - Issues: [X] Critical, [Y] Important
- Binding Validation: [PASS/FAIL]
  - Mismatches: [count]

### ✅ Build
- TypeScript: [PASS/FAIL]
- Linting: [PASS/FAIL]
- Tests: [PASS/FAIL] ([X] passed, [Y] failed)
- Bundle Size: [size] (✅ < 100KB / ⚠️ > 100KB / ❌ > 500KB)

### 🔍 Performance Analysis
- Cold Start (estimated): [X]ms
- Heavy Dependencies: [list if any]
- Warnings: [count]

### ⚠️ Blocking Issues (Must Fix)
[List any P1 issues that prevent deployment]

### ⚠️ Warnings (Recommended to Fix)
[List any P2 issues]

---
**Decision**: [READY TO DEPLOY / ISSUES MUST BE FIXED]
```

### 3. User Confirmation

<critical_requirement> Always require explicit user confirmation before deploying. </critical_requirement>

**If blocking issues exist**:
```
❌ Cannot deploy - [X] critical issues must be fixed:
1. [Issue description]
2. [Issue description]

Run /triage to create todos for these issues.
```

**If only warnings exist**:
```
⚠️ Ready to deploy with [X] warnings:
1. [Warning description]
2. [Warning description]

Deploy anyway? (yes/no/show-details)
```

**If all checks pass**:
```
✅ All checks passed. Ready to deploy.

Deploy to [environment]? (yes/no)
```

### 4. Deployment Execution

<thinking>
Execute the actual deployment with appropriate wrangler commands.
</thinking>

**If user confirms YES**:

1. **Create git tag (if production)**
   ```bash
   if [ "$environment" = "production" ]; then
     timestamp=$(date +%Y%m%d-%H%M%S)
     git tag -a "deploy-$timestamp" -m "Production deployment $timestamp"
   fi
   ```

2. **Deploy with wrangler**
   ```bash
   # For default/production
   wrangler deploy

   # For specific environment
   wrangler deploy --env $environment
   ```

3. **Capture deployment output**
   - Worker URL
   - Deployment ID
   - Custom domain (if configured)

4. **Verify deployment**
   ```bash
   # Test deployed Worker
   curl -I $worker_url
   # Verify 200 response
   ```

### 5. Post-Deployment Validation

<thinking>
Verify the deployment was successful and the Worker is responding correctly.
</thinking>

Run quick smoke tests:

1. **Health check**
   ```bash
   curl $worker_url/health || curl $worker_url/
   # Expect 200 status
   ```

2. **Verify bindings accessible** (if applicable)
   - Test endpoint that uses KV/R2/D1/DO
   - Verify no binding errors

3. **Check Cloudflare dashboard**
   ```bash
   wrangler tail --format json | head -n 5
   # Show first 5 requests/logs
   ```

### 6. Deployment Report

<deliverable>
Final deployment summary with all details
</deliverable>

```markdown
## 🚀 Deployment Complete

**Environment**: [production/staging/preview]
**Deployed At**: [timestamp]
**Worker URL**: [url]
**Custom Domain**: [domain] (if configured)

### Deployment Details
- Worker Name: [name]
- Bundle Size: [size]
- Deployment ID: [id]
- Git Tag: [tag] (if production)

### Verification
- Health Check: [✅ PASS / ❌ FAIL]
- Response Time: [X]ms
- Status Code: [code]

### Next Steps
1. Monitor logs: `wrangler tail`
2. View analytics: https://dash.cloudflare.com
3. Test endpoints: [list key endpoints]

### Rollback (if needed)
```bash
# View previous deployments
wrangler deployments list

# Rollback to previous version
wrangler rollback [deployment-id]
```

---
**Status**: ✅ Deployment Successful
```

## Emergency Rollback

If deployment fails or issues are detected:

1. **Immediate rollback**
   ```bash
   wrangler deployments list
   wrangler rollback [previous-deployment-id]
   ```

2. **Notify user**
   ```
   ❌ Deployment rolled back to previous version
   Reason: [failure reason]

   Investigate issues:
   - Check logs: wrangler tail
   - Review errors: [error details]
   ```

## Deployment Checklist

<checklist>
Before confirming deployment, verify:

- [ ] wrangler.toml is valid and complete
- [ ] All bindings have valid IDs
- [ ] No Node.js APIs in code
- [ ] No hardcoded secrets
- [ ] TypeScript compiles without errors
- [ ] Linting passes
- [ ] All tests pass
- [ ] Bundle size is acceptable (< 500KB)
- [ ] No CRITICAL (P1) issues from agents
- [ ] User has confirmed deployment
- [ ] Correct environment selected
- [ ] Git working directory is clean (if production)
</checklist>

## Environment-Specific Notes

### Production Deployment
- Requires explicit confirmation
- Creates git tag for tracking
- Runs full validation suite
- Monitors initial requests

### Staging Deployment
- Slightly relaxed validation (P2 warnings allowed)
- No git tag created
- Faster deployment process

### Preview Deployment
- Minimal validation
- Quick iteration for testing
- Temporary URL

## Troubleshooting

### Common Issues

**Issue**: "Error: Could not find binding {name}"
**Solution**: Run `Task binding-context-analyzer` to verify wrangler.toml

**Issue**: "Error: Bundle size too large"
**Solution**: Run `Task edge-performance-oracle` for optimization recommendations

**Issue**: "Error: Authentication failed"
**Solution**: Run `wrangler login` to re-authenticate

**Issue**: "Error: Worker exceeded CPU limit"
**Solution**: Check for blocking operations, infinite loops, or heavy computation

## Success Criteria

✅ **Deployment considered successful when**:
- All pre-flight checks pass (no P1 issues)
- Worker deploys without errors
- Health check returns 200
- No immediate runtime errors in logs
- Rollback capability confirmed available

## Notes

- Always test in staging before production
- Monitor logs for first 5-10 minutes after deployment
- Keep rollback procedure ready
- Document any configuration changes
- Update team on deployment status

---

**Remember**: It's better to fail pre-flight checks than to deploy broken code. Every check exists to prevent production issues.
