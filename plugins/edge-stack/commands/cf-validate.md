---
description: Run Cloudflare Workers validation checks before committing code
---

# Cloudflare Validation Command

Run comprehensive validation checks for Cloudflare Workers projects:

## Validation Checks

### Continuous SKILL-based Validation (Already Active During Development)

**Cloudflare Workers SKILLs**:
- **workers-runtime-validator**: Runtime compatibility validation
- **cloudflare-security-checker**: Security pattern validation
- **workers-binding-validator**: Binding configuration validation
- **edge-performance-optimizer**: Performance optimization guidance
- **kv-optimization-advisor**: KV storage optimization
- **durable-objects-pattern-checker**: DO best practices validation
- **cors-configuration-validator**: CORS setup validation

**Frontend Design SKILLs** (if Nuxt UI components detected):
- **nuxt-ui-design-validator**: Prevents generic aesthetics (Inter fonts, purple gradients, minimal animations)
- **component-aesthetic-checker**: Validates Nuxt UI component customization depth and consistency
- **animation-interaction-validator**: Ensures engaging animations, hover states, and loading feedback

### Explicit Command Validation (Run by /validate)
1. **wrangler.toml syntax** - Validates configuration file
2. **compatibility_date** - Ensures current runtime version
3. **TypeScript checks** - Runs typecheck if available
4. **Build verification** - Runs build command and checks for errors
5. **Linting** - Runs linter if available
6. **Bundle size analysis** - Checks deployment size limits
7. **Remote bindings** - Validates binding configuration

## Usage

Run this command before committing code:

```
/validate
```

## When to Use

- Before `git commit` 
- After making configuration changes
- Before deployment
- When troubleshooting issues

## Validation Rules

### Strict Requirements
- **0 errors** - All errors must be fixed before committing
- **≤5 warnings** - More than 5 warnings must be addressed before committing

### Exit Codes
- **0**: All checks passed ✅ (0 errors, ≤5 warnings)
- **1**: Validation failed ❌ (fix issues before committing)

## Build Requirements

The validation will:
- **SKILL Summary**: Report any P1/P2 issues found by active SKILLs during development
- Run `pnpm build` if build script exists (fails on any build errors)
- Run `pnpm typecheck` if typecheck script exists (fails on any TypeScript errors)
- Run `pnpm lint` if lint script exists (counts warnings toward threshold)
- Fail fast on first error to save time
- Enforce code quality: no errors, max 5 warnings

**Integration Note**: SKILLs provide continuous validation during development, catching issues early. The /validate command provides explicit validation and summarizes any SKILL findings alongside traditional build/lint checks.

This helps catch issues early and ensures code quality before committing to repository.