---
name: nuxt-ui-design-validator
description: Automatically validates frontend design patterns to prevent generic aesthetics (Inter fonts, purple gradients, minimal animations) and enforce distinctive, branded design during Nuxt 4 development
triggers: ["vue file creation", "component changes", "tailwind config changes", "nuxt config changes", "design system updates"]
---

# Nuxt UI Design Validator SKILL

## Activation Patterns

This SKILL automatically activates when:
- New `.vue` components are created in Nuxt projects
- Tailwind configuration (`tailwind.config.ts`) is modified
- Nuxt configuration (`nuxt.config.ts`) is modified
- Component styling or classes are changed
- Design token definitions are updated
- Before deployment commands are executed

## Expertise Provided

### Design Pattern Validation
- **Generic Pattern Detection**: Identifies default/overused design patterns
- **Typography Analysis**: Ensures distinctive font choices and hierarchy
- **Animation Validation**: Checks for engaging micro-interactions and transitions
- **Color System**: Validates distinctive color palettes vs generic defaults
- **Component Customization**: Ensures Nuxt UI components are customized, not default

### Specific Checks Performed

#### ❌ Critical Violations (Generic Design Patterns)
```vue
<!-- These patterns trigger alerts: -->

<!-- Generic font (Inter/Roboto) -->
<div class="font-sans">  <!-- Using default Inter -->

<!-- Purple gradient on white (overused pattern) -->
<div class="bg-gradient-to-r from-purple-500 to-purple-600">

<!-- No animations/transitions -->
<UButton @click="submit">Submit</UButton>  <!-- No hover state -->

<!-- Default background colors -->
<div class="bg-gray-50">  <!-- Generic #f9fafb -->
```

#### ✅ Correct Distinctive Patterns
```vue
<!-- These patterns are validated as correct: -->

<!-- Custom distinctive fonts -->
<h1 class="font-heading">  <!-- Custom font family -->

<!-- Custom brand colors -->
<div class="bg-brand-coral">  <!-- Distinctive palette -->

<!-- Engaging animations -->
<UButton
  class="transition-all duration-300 hover:scale-105 hover:shadow-xl"
  @click="submit"
>
  Submit
</UButton>

<!-- Atmospheric backgrounds -->
<div class="bg-gradient-to-br from-brand-ocean via-brand-sky to-brand-coral">
```

## Integration Points

### Complementary to Existing Components
- **frontend-design-specialist agent**: Handles deep design analysis, SKILL provides immediate validation
- **nuxt-ui-architect agent**: Component expertise, SKILL validates implementation
- **es-design-review command**: SKILL provides continuous validation between explicit reviews

### Escalation Triggers
- Complex design system questions → `frontend-design-specialist` agent
- Component customization help → `nuxt-ui-architect` agent
- Accessibility concerns → `accessibility-guardian` agent
- Full design review → `/es-design-review` command

## Validation Rules

### P1 - Critical (Generic Patterns to Avoid)
- **Default Fonts**: Inter, Roboto, Helvetica (in over 80% of sites)
- **Purple Gradients**: `from-purple-*` to `to-purple-*` on white backgrounds
- **Generic Grays**: `bg-gray-50`, `bg-gray-100` (overused neutrals)
- **No Animations**: Interactive elements without hover/focus transitions
- **Default Component Props**: Using Nuxt UI components with all default props

### P2 - Important (Polish and Engagement)
- **Missing Hover States**: Buttons/links without hover effects
- **No Loading States**: Async actions without loading feedback
- **Inconsistent Spacing**: Not using Tailwind spacing scale consistently
- **No Micro-interactions**: Forms/buttons without feedback animations
- **Weak Typography Hierarchy**: Similar font sizes for different heading levels

### P3 - Best Practices
- **Font Weight Variety**: Using only one or two font weights
- **Limited Color Palette**: Not defining custom brand colors
- **No Custom Tokens**: Not extending Tailwind theme with brand values
- **Missing Dark Mode**: No dark mode variants (if applicable)

## Remediation Examples

### Fixing Generic Fonts
```vue
<!-- ❌ Critical: Default Inter font -->
<template>
  <h1 class="text-4xl font-sans">Welcome</h1>
</template>

<!-- ✅ Correct: Distinctive custom font -->
<template>
  <h1 class="text-4xl font-heading tracking-tight">Welcome</h1>
</template>

<!-- tailwind.config.ts -->
<script>
export default {
  theme: {
    extend: {
      fontFamily: {
        // ❌ NOT: sans: ['Inter', 'sans-serif']
        // ✅ YES: Distinctive fonts
        sans: ['Space Grotesk', 'system-ui', 'sans-serif'],
        heading: ['Archivo Black', 'system-ui', 'sans-serif'],
        mono: ['JetBrains Mono', 'monospace']
      }
    }
  }
}
</script>
```

### Fixing Generic Colors
```vue
<!-- ❌ Critical: Purple gradient (overused) -->
<template>
  <div class="bg-gradient-to-r from-purple-500 to-purple-600">
    <h2 class="text-white">Hero Section</h2>
  </div>
</template>

<!-- ✅ Correct: Custom brand colors -->
<template>
  <div class="bg-gradient-to-br from-brand-coral via-brand-ocean to-brand-sunset">
    <h2 class="text-white">Hero Section</h2>
  </div>
</template>

<!-- tailwind.config.ts -->
<script>
export default {
  theme: {
    extend: {
      colors: {
        // ❌ NOT: Using only default Tailwind colors
        // ✅ YES: Custom brand palette
        brand: {
          coral: '#FF6B6B',
          ocean: '#4ECDC4',
          sunset: '#FFE66D',
          midnight: '#2C3E50',
          cream: '#FFF5E1'
        }
      }
    }
  }
}
</script>
```

### Fixing Missing Animations
```vue
<!-- ❌ Critical: No hover/transition effects -->
<template>
  <UButton @click="handleSubmit">
    Submit Form
  </UButton>
</template>

<!-- ✅ Correct: Engaging animations -->
<template>
  <UButton
    class="transition-all duration-300 hover:scale-105 hover:shadow-xl active:scale-95"
    @click="handleSubmit"
  >
    <span class="inline-flex items-center gap-2">
      Submit Form
      <UIcon
        name="i-heroicons-arrow-right"
        class="transition-transform duration-300 group-hover:translate-x-1"
      />
    </span>
  </UButton>
</template>
```

### Fixing Default Component Usage
```vue
<!-- ❌ P2: All default props (generic appearance) -->
<template>
  <UCard>
    <p>Content here</p>
  </UCard>
</template>

<!-- ✅ Correct: Customized for brand distinctiveness -->
<template>
  <UCard
    :ui="{
      background: 'bg-white dark:bg-brand-midnight',
      ring: 'ring-1 ring-brand-coral/20',
      rounded: 'rounded-2xl',
      shadow: 'shadow-xl hover:shadow-2xl',
      body: { padding: 'p-8' }
    }"
    class="transition-all duration-300 hover:-translate-y-1"
  >
    <p class="text-gray-700 dark:text-gray-300">Content here</p>
  </UCard>
</template>
```

## MCP Server Integration

When Nuxt UI MCP server is available:
- Query component customization options before validation
- Verify that suggested customizations use valid props
- Get latest component API to prevent hallucination
- Validate `ui` prop structure against actual schema

**Example MCP Usage**:
```typescript
// Validate UButton customization
const buttonDocs = await mcp.nuxt_ui.get_component("UButton");
// Check if suggested props exist: color, size, variant, ui, etc.
// Ensure customizations align with actual API
```

## Benefits

### Immediate Impact
- **Prevents Generic Design**: Catches overused patterns before they ship
- **Enforces Brand Identity**: Ensures consistent, distinctive aesthetics
- **Improves User Engagement**: Validates animations and interactions
- **Educates Developers**: Clear explanations of design best practices

### Long-term Value
- **Consistent Visual Identity**: All components follow brand guidelines
- **Faster Design Iterations**: Immediate feedback on design choices
- **Better User Experience**: Polished animations and interactions
- **Reduced Design Debt**: Prevents accumulation of generic patterns

## Usage Examples

### During Component Creation
```vue
// Developer creates: <div class="font-sans bg-purple-500">
// SKILL immediately activates: "⚠️ WARNING: Using default 'font-sans' (Inter) and purple gradient. Consider custom brand fonts and colors for distinctive design."
```

### During Styling
```vue
// Developer adds: <UButton>Click me</UButton>
// SKILL immediately activates: "⚠️ P2: Button lacks hover animations. Add transition utilities for better engagement: class='transition-all duration-300 hover:scale-105'"
```

### During Configuration
```typescript
// Developer modifies tailwind.config.ts with default Inter
// SKILL immediately activates: "⚠️ P1: Using Inter font (appears in 80%+ of sites). Replace with distinctive font choices like Space Grotesk, Archivo, or other brand-appropriate fonts."
```

### Before Deployment
```vue
// SKILL runs comprehensive check: "✅ Design validation passed. Custom fonts, distinctive colors, engaging animations, and customized components detected."
```

## Design Philosophy Alignment

This SKILL implements the core insight from Claude's "Improving Frontend Design Through Skills" blog post:

> "Think about frontend design the way a frontend engineer would. The more you can map aesthetic improvements to implementable frontend code, the better Claude can execute."

**Key Mappings**:
- **Typography** → Tailwind `fontFamily` config + utility classes
- **Animations** → Tailwind `transition-*`, `hover:*`, `duration-*` utilities
- **Background effects** → Custom gradient combinations, `backdrop-*` utilities
- **Themes** → Extended Tailwind color palette with brand tokens

## Distinctive vs Generic Patterns

### ❌ Generic Patterns (What to Avoid)
```vue
<!-- The "AI default aesthetic" -->
<div class="bg-white">
  <h1 class="font-sans text-gray-900">Title</h1>
  <div class="bg-gradient-to-r from-purple-500 to-purple-600">
    <UButton>Action</UButton>
  </div>
</div>
```

**Problems**:
- Inter font (default)
- Purple gradient (overused)
- Gray backgrounds (generic)
- No animations (flat)
- Default components (no customization)

### ✅ Distinctive Patterns (What to Strive For)
```vue
<!-- Brand-distinctive aesthetic -->
<div class="bg-gradient-to-br from-brand-cream via-white to-brand-ocean/10">
  <h1 class="font-heading text-6xl text-brand-midnight tracking-tighter">
    Title
  </h1>
  <div class="relative overflow-hidden rounded-3xl bg-brand-coral p-8">
    <!-- Atmospheric background -->
    <div class="absolute inset-0 bg-gradient-to-br from-brand-coral to-brand-sunset opacity-80" />

    <UButton
      :ui="{
        font: 'font-heading',
        rounded: 'rounded-full',
        size: 'xl'
      }"
      class="relative z-10 transition-all duration-500 hover:scale-110 hover:rotate-2 hover:shadow-2xl active:scale-95"
    >
      <span class="flex items-center gap-2">
        Action
        <UIcon
          name="i-heroicons-sparkles"
          class="animate-pulse"
        />
      </span>
    </UButton>
  </div>
</div>
```

**Strengths**:
- Custom fonts (Archivo Black for headings)
- Brand-specific colors (coral, ocean, sunset)
- Atmospheric gradients (multiple layers)
- Rich animations (scale, rotate, shadow transitions)
- Heavily customized components (ui prop + utility classes)
- Micro-interactions (icon pulse, hover effects)

This SKILL ensures every Nuxt 4 project develops a distinctive visual identity by preventing generic patterns and guiding developers toward branded, engaging design implementations.
