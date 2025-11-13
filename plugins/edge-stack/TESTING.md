# Frontend Design Features Testing Plan

## Overview

This document outlines the testing strategy for the frontend design features added to the Cloudflare toolkit plugin. These features prevent generic "AI aesthetics" and ensure distinctive, accessible designs.

## Testing Scope

### New Features to Test
- **3 SKILLs**: `nuxt-ui-design-validator`, `component-aesthetic-checker`, `animation-interaction-validator`
- **3 Agents**: `frontend-design-specialist`, `nuxt-ui-architect`, `accessibility-guardian`
- **3 Commands**: `/cf-design-review`, `/cf-component`, `/cf-theme`
- **Distinctiveness Scoring**: Calculation methodology and accuracy
- **MCP Integration**: Nuxt UI MCP server interaction

---

## Unit Tests (Priority 1)

### Pattern Detection Tests

#### Test: Inter Font Detection
**File**: `tests/design-validation/test-inter-font-detection.spec.ts`

```typescript
describe('Inter Font Detection', () => {
  it('should detect Inter font in tailwind.config.ts', () => {
    const config = {
      fontFamily: {
        sans: ['Inter', 'system-ui']
      }
    };
    expect(hasGenericFont(config)).toBe(true);
  });

  it('should pass custom fonts', () => {
    const config = {
      fontFamily: {
        sans: ['Space Grotesk', 'system-ui'],
        heading: ['Archivo Black', 'system-ui']
      }
    };
    expect(hasGenericFont(config)).toBe(false);
  });
});
```

#### Test: Purple Gradient Detection
**File**: `tests/design-validation/test-purple-gradient-detection.spec.ts`

```typescript
describe('Purple Gradient Detection', () => {
  it('should detect purple gradients in Vue templates', () => {
    const template = `
      <div class="bg-gradient-to-r from-purple-500 to-purple-600">
        Content
      </div>
    `;
    expect(hasGenericGradient(template)).toBe(true);
  });

  it('should pass custom color gradients', () => {
    const template = `
      <div class="bg-gradient-to-br from-brand-coral to-brand-ocean">
        Content
      </div>
    `;
    expect(hasGenericGradient(template)).toBe(false);
  });
});
```

#### Test: Animation Detection
**File**: `tests/design-validation/test-animation-detection.spec.ts`

```typescript
describe('Animation Detection', () => {
  it('should detect missing hover states', () => {
    const component = `<UButton @click="submit">Submit</UButton>`;
    expect(hasHoverAnimation(component)).toBe(false);
  });

  it('should pass components with animations', () => {
    const component = `
      <UButton
        class="transition-all duration-300 hover:scale-105"
        @click="submit"
      >
        Submit
      </UButton>
    `;
    expect(hasHoverAnimation(component)).toBe(true);
  });

  it('should validate reduced motion support', () => {
    const component = `
      <div class="motion-safe:animate-bounce motion-reduce:animate-none">
        Content
      </div>
    `;
    expect(hasReducedMotionSupport(component)).toBe(true);
  });
});
```

### Component Customization Tests

#### Test: UI Prop Usage Detection
**File**: `tests/design-validation/test-ui-prop-usage.spec.ts`

```typescript
describe('UI Prop Usage Detection', () => {
  it('should detect default props only', () => {
    const component = `<UButton>Click me</UButton>`;
    expect(hasCustomization(component)).toBe(false);
  });

  it('should pass deeply customized components', () => {
    const component = `
      <UButton
        :ui="{
          font: 'font-heading',
          rounded: 'rounded-full',
          padding: { lg: 'px-8 py-4' }
        }"
      >
        Click me
      </UButton>
    `;
    expect(hasCustomization(component)).toBe(true);
  });
});
```

### Accessibility Tests

#### Test: Color Contrast Validation
**File**: `tests/accessibility/test-contrast-validation.spec.ts`

```typescript
describe('Color Contrast Validation', () => {
  it('should fail insufficient contrast', () => {
    const textColor = '#999999';
    const bgColor = '#FFFFFF';
    const ratio = calculateContrastRatio(textColor, bgColor);
    expect(ratio).toBeLessThan(4.5);
    expect(meetsWCAGAA(ratio, 'normal')).toBe(false);
  });

  it('should pass sufficient contrast', () => {
    const textColor = '#4A5568'; // gray-700
    const bgColor = '#FFFFFF';
    const ratio = calculateContrastRatio(textColor, bgColor);
    expect(ratio).toBeGreaterThanOrEqual(4.5);
    expect(meetsWCAGAA(ratio, 'normal')).toBe(true);
  });
});
```

#### Test: ARIA Label Validation
**File**: `tests/accessibility/test-aria-validation.spec.ts`

```typescript
describe('ARIA Label Validation', () => {
  it('should detect missing aria-label on icon buttons', () => {
    const component = `<UButton icon="i-heroicons-x-mark" />`;
    expect(hasAccessibleLabel(component)).toBe(false);
  });

  it('should pass buttons with aria-label', () => {
    const component = `
      <UButton
        icon="i-heroicons-x-mark"
        aria-label="Close dialog"
      />
    `;
    expect(hasAccessibleLabel(component)).toBe(true);
  });
});
```

### Distinctiveness Score Tests

#### Test: Score Calculation
**File**: `tests/scoring/test-distinctiveness-score.spec.ts`

```typescript
describe('Distinctiveness Score Calculation', () => {
  it('should calculate typography score correctly', () => {
    const config = {
      typography: {
        customFonts: 2, // 15 pts
        headingHierarchy: true, // 5 pts
        customTracking: true // 5 pts
      }
    };
    expect(calculateTypographyScore(config)).toBe(25);
  });

  it('should penalize Inter font', () => {
    const config = {
      typography: {
        fonts: ['Inter', 'system-ui'],
        headingHierarchy: true,
        customTracking: true
      }
    };
    expect(calculateTypographyScore(config)).toBe(10); // 0 + 5 + 5
  });

  it('should calculate total score correctly', () => {
    const project = {
      typography: 25,
      colors: 20,
      animations: 15,
      components: 20
    };
    expect(calculateTotalScore(project)).toBe(80);
    expect(getRating(80)).toBe('Good');
  });
});
```

---

## Integration Tests (Priority 2)

### SKILL Integration Tests

#### Test: nuxt-ui-design-validator Activation
**File**: `tests/integration/test-skill-activation.spec.ts`

```typescript
describe('SKILL Activation', () => {
  it('should activate on .vue file creation', async () => {
    const result = await createVueFile('components/Button.vue', `
      <template>
        <button class="font-sans">Click me</button>
      </template>
    `);

    expect(result.skillTriggered).toBe('nuxt-ui-design-validator');
    expect(result.findings).toContain('Generic font detected: Inter');
  });

  it('should activate on tailwind.config.ts changes', async () => {
    const result = await modifyTailwindConfig({
      fontFamily: {
        sans: ['Inter', 'system-ui']
      }
    });

    expect(result.skillTriggered).toBe('nuxt-ui-design-validator');
  });
});
```

### Command Integration Tests

#### Test: /cf-design-review Command
**File**: `tests/integration/test-cf-design-review.spec.ts`

```typescript
describe('/cf-design-review Command', () => {
  it('should analyze project and generate report', async () => {
    const result = await runCommand('/cf-design-review');

    expect(result).toHaveProperty('findings');
    expect(result).toHaveProperty('distinctivenessScore');
    expect(result.findings).toBeInstanceOf(Array);
    expect(result.distinctivenessScore).toBeGreaterThanOrEqual(0);
    expect(result.distinctivenessScore).toBeLessThanOrEqual(100);
  });

  it('should detect Inter fonts in project', async () => {
    await setupProject({
      tailwindConfig: {
        fontFamily: { sans: ['Inter', 'system-ui'] }
      }
    });

    const result = await runCommand('/cf-design-review');
    const interFinding = result.findings.find(f =>
      f.issue.includes('Inter font')
    );

    expect(interFinding).toBeDefined();
    expect(interFinding.priority).toBe('P1');
  });
});
```

#### Test: /cf-theme Command
**File**: `tests/integration/test-cf-theme.spec.ts`

```typescript
describe('/cf-theme Command', () => {
  it('should generate custom theme configuration', async () => {
    const result = await runCommand('/cf-theme --palette coral-ocean --fonts modern');

    expect(result.files).toContain('tailwind.config.ts');
    expect(result.files).toContain('app.config.ts');

    const tailwindConfig = await readFile('tailwind.config.ts');
    expect(tailwindConfig).not.toContain('Inter');
    expect(tailwindConfig).toContain('brand-coral');
  });
});
```

#### Test: /cf-component Command
**File**: `tests/integration/test-cf-component.spec.ts`

```typescript
describe('/cf-component Command', () => {
  it('should scaffold component with customizations', async () => {
    const result = await runCommand('/cf-component button PrimaryButton');

    expect(result.file).toBe('components/PrimaryButton.vue');

    const content = await readFile('components/PrimaryButton.vue');
    expect(content).toContain(':ui=');
    expect(content).toContain('transition-all');
    expect(content).toContain('aria-label');
  });
});
```

### Agent Integration Tests

#### Test: Agent Collaboration
**File**: `tests/integration/test-agent-collaboration.spec.ts`

```typescript
describe('Agent Collaboration', () => {
  it('should run Phase 2.5 agents in parallel', async () => {
    const result = await runReview('pr-with-nuxt-ui');

    expect(result.phase25).toBeDefined();
    expect(result.phase25.agents).toHaveLength(3);
    expect(result.phase25.agents).toContain('frontend-design-specialist');
    expect(result.phase25.agents).toContain('nuxt-ui-architect');
    expect(result.phase25.agents).toContain('accessibility-guardian');
  });
});
```

### MCP Integration Tests

#### Test: Nuxt UI MCP Server
**File**: `tests/integration/test-nuxt-ui-mcp.spec.ts`

```typescript
describe('Nuxt UI MCP Integration', () => {
  it('should query component props from MCP', async () => {
    const props = await mcpQuery('nuxt-ui', 'get_component', {
      name: 'UButton'
    });

    expect(props).toHaveProperty('color');
    expect(props).toHaveProperty('size');
    expect(props).toHaveProperty('variant');
    expect(props).toHaveProperty('ui');
  });

  it('should prevent prop hallucination', async () => {
    const component = `
      <UButton
        :magic-prop="true"
        :nonexistent="false"
      />
    `;

    const validation = await validateComponent(component);
    expect(validation.invalidProps).toContain('magic-prop');
    expect(validation.invalidProps).toContain('nonexistent');
  });
});
```

---

## End-to-End Tests (Priority 3)

### Test: Complete Design Review Workflow
**File**: `tests/e2e/test-design-review-workflow.spec.ts`

```typescript
describe('Design Review Workflow', () => {
  it('should perform complete review and fix cycle', async () => {
    // Step 1: Create generic project
    await createProject({
      components: [
        { name: 'Hero.vue', usesInterFont: true, hasPurpleGradient: true }
      ]
    });

    // Step 2: Run design review
    const review = await runCommand('/cf-design-review');
    expect(review.distinctivenessScore).toBeLessThan(50);
    expect(review.findings).toHaveLength(2); // Inter + purple gradient

    // Step 3: Generate theme
    await runCommand('/cf-theme --palette coral-ocean --fonts modern');

    // Step 4: Update component
    await runCommand('/cf-component hero Hero --theme custom');

    // Step 5: Re-run review
    const review2 = await runCommand('/cf-design-review');
    expect(review2.distinctivenessScore).toBeGreaterThanOrEqual(85);
    expect(review2.findings).toHaveLength(0);
  });
});
```

---

## Manual Testing Checklist

### SKILL Validation
- [ ] Create new .vue file with Inter font → SKILL triggers
- [ ] Add purple gradient to component → SKILL detects
- [ ] Create button without hover state → SKILL flags
- [ ] Modify tailwind.config.ts → SKILL validates

### Command Validation
- [ ] Run `/cf-design-review` on project with generic patterns
- [ ] Verify distinctiveness score calculation
- [ ] Generate theme with `/cf-theme` → verify no Inter/purple
- [ ] Scaffold component with `/cf-component` → verify customization
- [ ] Run `/validate` → SKILLs included in checks

### Agent Validation
- [ ] Review PR with Nuxt UI components → Phase 2.5 triggers
- [ ] Verify `frontend-design-specialist` identifies generic patterns
- [ ] Verify `nuxt-ui-architect` catches invalid props (if MCP available)
- [ ] Verify `accessibility-guardian` finds contrast violations

### Accessibility Validation
- [ ] Test contrast checker with various color combinations
- [ ] Verify keyboard navigation guidance
- [ ] Check ARIA label validation
- [ ] Test reduced motion support detection

---

## Performance Testing

### Agent Execution Time
**Target**: Phase 2.5 should complete in < 30 seconds for typical project

```typescript
describe('Performance', () => {
  it('should complete design review in reasonable time', async () => {
    const start = Date.now();
    await runCommand('/cf-design-review');
    const duration = Date.now() - start;

    expect(duration).toBeLessThan(30000); // 30 seconds
  });
});
```

### Token Usage
**Target**: < 50k tokens for typical design review

```typescript
describe('Token Efficiency', () => {
  it('should use tokens efficiently', async () => {
    const usage = await runWithTokenTracking('/cf-design-review');

    expect(usage.inputTokens).toBeLessThan(30000);
    expect(usage.outputTokens).toBeLessThan(20000);
  });
});
```

---

## Regression Testing

### Existing Functionality
- [ ] `/review` command still works for non-Nuxt projects
- [ ] `/validate` command includes new SKILLs but doesn't break
- [ ] Cloudflare agents still function correctly
- [ ] MCP integration doesn't break existing servers

---

## Test Data Setup

### Sample Projects

#### Generic Project (Low Score)
```
project-generic/
  ├── components/
  │   ├── Hero.vue (Inter font, purple gradient)
  │   └── Button.vue (default props, no animations)
  └── tailwind.config.ts (default Inter font)
```

#### Distinctive Project (High Score)
```
project-distinctive/
  ├── components/
  │   ├── Hero.vue (custom fonts, brand colors)
  │   └── Button.vue (ui prop, animations)
  ├── composables/
  │   └── useDesignSystem.ts
  └── tailwind.config.ts (custom fonts + colors)
```

---

## Continuous Integration

### GitHub Actions Workflow
```yaml
name: Frontend Design Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
      - run: npm install
      - run: npm test -- tests/design-validation/
      - run: npm test -- tests/accessibility/
      - run: npm test -- tests/scoring/
```

---

## Success Criteria

### Phase 1: Unit Tests (Immediate)
- [ ] All pattern detection tests passing
- [ ] All scoring calculation tests passing
- [ ] All accessibility validation tests passing

### Phase 2: Integration Tests (1 week)
- [ ] SKILL activation tests passing
- [ ] Command execution tests passing
- [ ] Agent collaboration tests passing

### Phase 3: E2E Tests (2 weeks)
- [ ] Complete workflow tests passing
- [ ] Performance targets met
- [ ] Manual testing checklist complete

---

## Test Execution

### Run All Tests
```bash
# Unit tests
npm test -- tests/design-validation/
npm test -- tests/accessibility/
npm test -- tests/scoring/

# Integration tests
npm test -- tests/integration/

# E2E tests
npm test -- tests/e2e/

# All tests
npm test
```

### Coverage Target
- **Minimum**: 80% code coverage
- **Target**: 90% code coverage
- **Focus**: Pattern detection logic, scoring calculations, accessibility checks

---

## Notes

- Tests should be added incrementally, starting with critical pattern detection
- Mock MCP server responses for consistent testing
- Use snapshot testing for generated component templates
- Performance benchmarks should run on CI to catch regressions
