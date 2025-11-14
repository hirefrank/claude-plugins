---
description: Initialize Playwright E2E testing for Tanstack Start projects with Cloudflare Workers-specific configuration
---

# Playwright Test Setup Command

<command_purpose> Configure Playwright for end-to-end testing in Tanstack Start projects deployed to Cloudflare Workers. Sets up test infrastructure, accessibility testing, and Workers-specific patterns. </command_purpose>

## Introduction

<role>Senior QA Engineer specializing in Playwright setup for Tanstack Start + Cloudflare Workers applications</role>

This command initializes a complete Playwright testing setup optimized for:
- Tanstack Start (React + TanStack Router)
- Cloudflare Workers deployment
- Server function testing
- Cloudflare bindings (KV, D1, R2, DO)
- Accessibility testing
- Performance monitoring

## Prerequisites

<requirements>
- Tanstack Start project initialized
- Cloudflare Workers configured (wrangler.jsonc)
- Node.js 18+
- npm/pnpm/yarn
</requirements>

## Main Tasks

### 1. Verify Project Setup

<thinking>
Ensure this is a Tanstack Start project before installing Playwright.
</thinking>

```bash
# Check for Tanstack Start
if ! grep -q "@tanstack/start" package.json; then
  echo "❌ Not a Tanstack Start project"
  echo "This command requires Tanstack Start."
  exit 1
fi

# Check for wrangler config
if [ ! -f "wrangler.jsonc" ] && [ ! -f "wrangler.toml" ]; then
  echo "⚠️  No wrangler config found"
  echo "Playwright will be configured, but Cloudflare bindings tests may not work."
fi
```

### 2. Install Playwright Dependencies

```bash
# Install Playwright and dependencies
pnpm add -D @playwright/test @axe-core/playwright

# Install browsers
npx playwright install --with-deps chromium firefox webkit
```

### 3. Create Playwright Configuration

**File**: `playwright.config.ts`

```typescript
import { defineConfig, devices } from '@playwright/test'

export default defineConfig({
  testDir: './e2e',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,

  reporter: [
    ['html'],
    ['list'],
    process.env.CI ? ['github'] : ['list'],
  ],

  use: {
    baseURL: process.env.PLAYWRIGHT_TEST_BASE_URL || 'http://localhost:3000',
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',
  },

  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
    {
      name: 'firefox',
      use: { ...devices['Desktop Firefox'] },
    },
    {
      name: 'webkit',
      use: { ...devices['Desktop Safari'] },
    },
    {
      name: 'Mobile Chrome',
      use: { ...devices['Pixel 5'] },
    },
    {
      name: 'Mobile Safari',
      use: { ...devices['iPhone 12'] },
    },
  ],

  webServer: {
    command: 'pnpm dev',
    url: 'http://localhost:3000',
    reuseExistingServer: !process.env.CI,
    timeout: 120 * 1000,
  },
})
```

### 4. Create Directory Structure

```bash
mkdir -p e2e/{routes,server-functions,components,auth,accessibility,performance,visual,fixtures}
```

### 5. Create Example Tests

**File**: `e2e/example.spec.ts`

```typescript
import { test, expect } from '@playwright/test'

test.describe('Example Tests', () => {
  test('home page loads', async ({ page }) => {
    await page.goto('/')

    await expect(page).toHaveTitle(/.*/)
    await expect(page.locator('body')).toBeVisible()
  })

  test('has no console errors', async ({ page }) => {
    const errors: string[] = []

    page.on('console', msg => {
      if (msg.type() === 'error') {
        errors.push(msg.text())
      }
    })

    await page.goto('/')

    expect(errors).toHaveLength(0)
  })
})
```

**File**: `e2e/accessibility/home.spec.ts`

```typescript
import { test, expect } from '@playwright/test'
import AxeBuilder from '@axe-core/playwright'

test.describe('Accessibility', () => {
  test('home page has no a11y violations', async ({ page }) => {
    await page.goto('/')

    const accessibilityScanResults = await new AxeBuilder({ page })
      .analyze()

    expect(accessibilityScanResults.violations).toEqual([])
  })
})
```

**File**: `e2e/performance/metrics.spec.ts`

```typescript
import { test, expect } from '@playwright/test'

test.describe('Performance', () => {
  test('measures page load time', async ({ page }) => {
    const startTime = Date.now()
    await page.goto('/')
    await page.waitForLoadState('networkidle')
    const loadTime = Date.now() - startTime

    console.log(`Page load time: ${loadTime}ms`)

    // Cloudflare Workers should load fast
    expect(loadTime).toBeLessThan(1000)
  })

  test('measures TTFB', async ({ page }) => {
    await page.goto('/')

    const timing = await page.evaluate(() =>
      JSON.parse(JSON.stringify(
        performance.getEntriesByType('navigation')[0]
      ))
    )

    const ttfb = timing.responseStart - timing.requestStart
    console.log(`TTFB: ${ttfb}ms`)

    // Time to First Byte should be fast on Workers
    expect(ttfb).toBeLessThan(200)
  })
})
```

### 6. Create Test Fixtures

**File**: `e2e/fixtures/test-users.ts`

```typescript
export const testUsers = {
  admin: {
    email: 'admin@test.com',
    password: 'admin123',
    name: 'Admin User',
  },
  regular: {
    email: 'user@test.com',
    password: 'user123',
    name: 'Regular User',
  },
}
```

### 7. Update package.json Scripts

```json
{
  "scripts": {
    "test:e2e": "playwright test",
    "test:e2e:ui": "playwright test --ui",
    "test:e2e:debug": "playwright test --debug",
    "test:e2e:headed": "playwright test --headed",
    "test:e2e:report": "playwright show-report"
  }
}
```

### 8. Create .env.test for Cloudflare Bindings

**File**: `.env.test`

```bash
# Cloudflare Test Environment
CLOUDFLARE_ACCOUNT_ID=your-test-account-id
CLOUDFLARE_API_TOKEN=your-test-api-token

# Test Bindings (separate from production)
KV_NAMESPACE_ID=test-kv-namespace-id
D1_DATABASE_ID=test-d1-database-id
R2_BUCKET_NAME=test-r2-bucket

# Test Base URL
PLAYWRIGHT_TEST_BASE_URL=http://localhost:3000
```

### 9. Create GitHub Actions Workflow (Optional)

**File**: `.github/workflows/e2e.yml`

```yaml
name: E2E Tests

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    timeout-minutes: 60
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3

      - name: Setup Node
        uses: actions/setup-node@v3
        with:
          node-version: 18

      - name: Install dependencies
        run: pnpm install

      - name: Install Playwright Browsers
        run: npx playwright install --with-deps

      - name: Run Playwright tests
        run: pnpm test:e2e
        env:
          CLOUDFLARE_ACCOUNT_ID: ${ secrets.CLOUDFLARE_ACCOUNT_ID}
          CLOUDFLARE_API_TOKEN: ${ secrets.CLOUDFLARE_API_TOKEN}

      - name: Upload Playwright Report
        uses: actions/upload-artifact@v3
        if: always()
        with:
          name: playwright-report
          path: playwright-report/
          retention-days: 30
```

### 10. Create Testing Guide

**File**: `e2e/README.md`

```markdown
# E2E Testing Guide

## Running Tests

```bash
# Run all tests
pnpm test:e2e

# Run with UI mode
pnpm test:e2e:ui

# Run specific test file
pnpm test:e2e e2e/routes/home.spec.ts

# Run in headed mode (see browser)
pnpm test:e2e:headed

# Debug mode
pnpm test:e2e:debug
```

## Test Organization

- `routes/` - Tests for TanStack Router routes
- `server-functions/` - Tests for server functions
- `components/` - Tests for shadcn/ui components
- `auth/` - Authentication flow tests
- `accessibility/` - Accessibility tests (axe-core)
- `performance/` - Performance and load time tests
- `visual/` - Visual regression tests
- `fixtures/` - Test data and helpers

## Best Practices

1. **Test user behavior, not implementation**
   - Focus on what users see and do
   - Avoid testing internal state

2. **Use data-testid for stable selectors**
   ```tsx
   <button data-testid="submit-button">Submit</button>
   ```

3. **Test with real Cloudflare bindings**
   - Use test environment bindings
   - Don't mock KV, D1, R2, DO

4. **Run accessibility tests on every page**
   - Zero violations policy
   - Use @axe-core/playwright

5. **Monitor performance metrics**
   - Cold start < 500ms
   - TTFB < 200ms
   - Bundle size < 200KB
```

### 11. Add .gitignore Entries

```bash
# Add to .gitignore
cat >> .gitignore << 'EOF'

# Playwright
/test-results/
/playwright-report/
/playwright/.cache/
EOF
```

### 12. Validation

**Task playwright-testing-specialist(verify setup)**:
- Confirm Playwright installed
- Verify browser binaries downloaded
- Check test directory structure
- Validate configuration file
- Run example test to ensure setup works

```bash
# Run validation
pnpm test:e2e --reporter=list

# Should see:
# ✓ example.spec.ts:5:3 › Example Tests › home page loads
# ✓ accessibility/home.spec.ts:6:3 › Accessibility › home page has no a11y violations
# ✓ performance/metrics.spec.ts:6:3 › Performance › measures page load time
```

## Output

After running `/es-test-setup`, you will have:

✅ Playwright installed with all browsers
✅ Test directory structure created
✅ Configuration file (playwright.config.ts)
✅ Example tests (routes, accessibility, performance)
✅ Test fixtures and helpers
✅ npm scripts for running tests
✅ CI/CD workflow template
✅ Testing guide documentation

## Next Steps

1. **Run example tests**:
   ```bash
   pnpm test:e2e
   ```

2. **Generate tests for your routes**:
   ```bash
   /es-test-gen /users/$id
   ```

3. **Add tests to your workflow**:
   - Write tests as you build features
   - Run tests before deployment
   - Monitor test results in CI/CD

## Troubleshooting

### Issue: "Cannot find module '@playwright/test'"

**Solution**:
```bash
pnpm install
npx playwright install
```

### Issue: "Browser not found"

**Solution**:
```bash
npx playwright install --with-deps
```

### Issue: "Tests timing out"

**Solution**: Increase timeout in `playwright.config.ts`:
```typescript
export default defineConfig({
  timeout: 60 * 1000, // 60 seconds per test
  // ...
})
```

### Issue: "Accessibility violations found"

**Solution**: Fix the violations! Playwright will show you exactly what's wrong:
```
Expected: []
Received: [
  {
    "id": "color-contrast",
    "impact": "serious",
    "description": "Ensures the contrast between foreground and background colors meets WCAG 2 AA contrast ratio thresholds",
    "nodes": [...]
  }
]
```

## Resources

- **Playwright Docs**: https://playwright.dev
- **Axe Accessibility**: https://github.com/dequelabs/axe-core-npm/tree/develop/packages/playwright
- **Cloudflare Testing**: https://developers.cloudflare.com/workers/testing/
- **Best Practices**: https://playwright.dev/docs/best-practices

## Success Criteria

✅ Playwright installed and configured
✅ Example tests passing
✅ Accessibility testing enabled
✅ Performance monitoring setup
✅ CI/CD workflow ready
✅ Team trained on testing practices
