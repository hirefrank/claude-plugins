---
description: Run Cloudflare Workers validation checks before committing code
---

# Cloudflare Validation Command

Run comprehensive validation checks for Cloudflare Workers projects:

## Validation Checks

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
- Run `pnpm build` if build script exists (fails on any build errors)
- Run `pnpm typecheck` if typecheck script exists (fails on any TypeScript errors)
- Run `pnpm lint` if lint script exists (counts warnings toward threshold)
- Fail fast on first error to save time
- Enforce code quality: no errors, max 5 warnings

This helps catch issues early and ensures code quality before committing to repository.