---
name: component-aesthetic-checker
description: Validates Nuxt UI component customization depth, ensuring components aren't used with default props and checking for consistent design system implementation across the application
triggers: ["nuxt ui component usage", "component prop changes", "design token updates", "ui prop customization"]
---

# Component Aesthetic Checker SKILL

## Activation Patterns

This SKILL automatically activates when:
- Nuxt UI components (`UButton`, `UCard`, `UInput`, etc.) are used in `.vue` files
- Component props are added or modified
- The `ui` prop is customized for component variants
- Design system tokens are referenced in components
- Multiple components are refactored together
- Before component library updates

## Expertise Provided

### Component Customization Depth Analysis
- **Default Prop Detection**: Identifies components using only default values
- **UI Prop Validation**: Ensures `ui` prop is used for deep customization
- **Design System Consistency**: Validates consistent pattern usage across components
- **Spacing Patterns**: Checks for proper Tailwind spacing scale usage
- **Icon Usage**: Validates consistent icon library and sizing
- **Loading States**: Ensures async components have loading feedback

### Specific Checks Performed

#### ❌ Critical Issues (Insufficient Customization)
```vue
<!-- These patterns trigger alerts: -->

<!-- Using default props only -->
<UButton @click="submit">Submit</UButton>

<!-- No UI prop customization -->
<UCard>
  <template #header>Title</template>
  <p>Content</p>
</UCard>

<!-- Inconsistent spacing -->
<div class="p-4">  <!-- Random spacing values -->
  <UButton class="mt-3 ml-2">Action</UButton>
</div>

<!-- Missing loading states -->
<UButton @click="asyncAction">Save</UButton>  <!-- No :loading prop -->
```

#### ✅ Correct Customized Patterns
```vue
<!-- These patterns are validated as correct: -->

<!-- Deep customization with ui prop -->
<UButton
  color="brand-coral"
  size="lg"
  variant="solid"
  :ui="{
    font: 'font-heading',
    rounded: 'rounded-full',
    padding: { lg: 'px-8 py-4' }
  }"
  :loading="isSubmitting"
  class="transition-all duration-300 hover:scale-105"
  @click="submit"
>
  Submit
</UButton>

<!-- Fully customized card -->
<UCard
  :ui="{
    background: 'bg-white dark:bg-brand-midnight',
    ring: 'ring-1 ring-brand-coral/20',
    rounded: 'rounded-2xl',
    shadow: 'shadow-xl',
    body: { padding: 'p-8' },
    header: { padding: 'px-8 pt-8 pb-4' }
  }"
  class="transition-shadow duration-300 hover:shadow-2xl"
>
  <template #header>
    <h3 class="font-heading text-2xl">Title</h3>
  </template>
  <p class="text-gray-700 dark:text-gray-300">Content</p>
</UCard>

<!-- Consistent spacing (Tailwind scale) -->
<div class="p-6 space-y-4">
  <UButton class="mt-4">Action</UButton>
</div>

<!-- Proper loading state -->
<UButton
  :loading="isSubmitting"
  :disabled="isSubmitting"
  @click="asyncAction"
>
  {{ isSubmitting ? 'Saving...' : 'Save' }}
</UButton>
```

## Integration Points

### Complementary to Existing Components
- **nuxt-ui-architect agent**: Handles component selection and API guidance, SKILL validates implementation
- **frontend-design-specialist agent**: Provides design direction, SKILL enforces consistency
- **nuxt-ui-design-validator**: Catches generic patterns, SKILL ensures deep customization

### Escalation Triggers
- Component API questions → `nuxt-ui-architect` agent (with MCP lookup)
- Design consistency issues → `frontend-design-specialist` agent
- Complex component composition → `/es-component` command
- Full component audit → `/es-design-review` command

## Validation Rules

### P1 - Critical (Default Component Usage)
- **No UI Prop Customization**: Using Nuxt UI components without `ui` prop
- **All Default Props**: No color, size, variant, or other prop customizations
- **Missing Loading States**: Async actions without `:loading` prop
- **No Hover States**: Interactive components without hover feedback
- **Inconsistent Patterns**: Same component with wildly different customizations

### P2 - Important (Design System Consistency)
- **Random Spacing Values**: Not using Tailwind spacing scale (p-4, mt-6, etc.)
- **Inconsistent Icon Sizing**: Icons with different sizes in similar contexts
- **Mixed Color Approaches**: Some components use theme colors, others use arbitrary values
- **Incomplete Dark Mode**: Dark mode variants missing on customized components
- **No Focus States**: Interactive elements without focus-visible styling

### P3 - Polish (Enhanced UX)
- **Limited Prop Usage**: Only using 1-2 props when more would improve UX
- **No Micro-interactions**: Missing subtle animations on state changes
- **Generic Variants**: Using 'solid', 'outline' without brand customization
- **Underutilized UI Prop**: Not customizing padding, rounded, shadow in ui prop
- **Missing Icons**: Buttons/actions without supporting icons for clarity

## Remediation Examples

### Fixing Default Component Usage
```vue
<!-- ❌ Critical: Default props only -->
<template>
  <UButton @click="handleClick">
    Click me
  </UButton>
</template>

<!-- ✅ Correct: Deep customization -->
<template>
  <UButton
    color="primary"
    size="lg"
    variant="solid"
    icon="i-heroicons-sparkles"
    :ui="{
      font: 'font-heading tracking-wide',
      rounded: 'rounded-full',
      padding: { lg: 'px-8 py-4' },
      shadow: 'shadow-lg hover:shadow-xl'
    }"
    class="transition-all duration-300 hover:scale-105 active:scale-95"
    @click="handleClick"
  >
    Click me
  </UButton>
</template>
```

### Fixing Missing Loading States
```vue
<!-- ❌ Critical: No loading feedback -->
<script setup>
const handleSubmit = async () => {
  await submitForm();
};
</script>

<template>
  <UButton @click="handleSubmit">
    Submit Form
  </UButton>
</template>

<!-- ✅ Correct: Proper loading state -->
<script setup>
const isSubmitting = ref(false);

const handleSubmit = async () => {
  isSubmitting.value = true;
  try {
    await submitForm();
  } finally {
    isSubmitting.value = false;
  }
};
</script>

<template>
  <UButton
    :loading="isSubmitting"
    :disabled="isSubmitting"
    @click="handleSubmit"
  >
    <span class="flex items-center gap-2">
      <UIcon
        v-if="!isSubmitting"
        name="i-heroicons-paper-airplane"
      />
      {{ isSubmitting ? 'Submitting...' : 'Submit Form' }}
    </span>
  </UButton>
</template>
```

### Fixing Inconsistent Spacing
```vue
<!-- ❌ P2: Random spacing values -->
<template>
  <div class="p-3">
    <UCard class="mt-5 ml-7">
      <div class="p-2">
        <UButton class="mt-3.5">Action</UButton>
      </div>
    </UCard>
  </div>
</template>

<!-- ✅ Correct: Tailwind spacing scale -->
<template>
  <div class="p-4">
    <UCard class="mt-4">
      <div class="p-6 space-y-4">
        <UButton>Action</UButton>
      </div>
    </UCard>
  </div>
</template>

<!-- Using consistent spacing: 4, 6, 8, 12, 16 (Tailwind scale) -->
```

### Fixing Design System Inconsistency
```vue
<!-- ❌ P2: Inconsistent component styling -->
<template>
  <div>
    <!-- Button 1: Heavily customized -->
    <UButton
      color="primary"
      :ui="{ rounded: 'rounded-full', shadow: 'shadow-xl' }"
    >
      Action 1
    </UButton>

    <!-- Button 2: Default (inconsistent!) -->
    <UButton>Action 2</UButton>

    <!-- Button 3: Different customization pattern -->
    <UButton color="red" size="xs">
      Action 3
    </UButton>
  </div>
</template>

<!-- ✅ Correct: Consistent design system -->
<script setup>
// Define reusable button variants
const buttonVariants = {
  primary: {
    color: 'primary',
    size: 'lg',
    ui: {
      rounded: 'rounded-full',
      shadow: 'shadow-lg hover:shadow-xl',
      font: 'font-heading'
    },
    class: 'transition-all duration-300 hover:scale-105'
  },
  secondary: {
    color: 'gray',
    size: 'md',
    variant: 'outline',
    ui: {
      rounded: 'rounded-lg',
      font: 'font-sans'
    },
    class: 'transition-colors duration-200'
  }
};
</script>

<template>
  <div class="space-x-4">
    <UButton v-bind="buttonVariants.primary">
      Action 1
    </UButton>

    <UButton v-bind="buttonVariants.primary">
      Action 2
    </UButton>

    <UButton v-bind="buttonVariants.secondary">
      Action 3
    </UButton>
  </div>
</template>
```

### Fixing Underutilized UI Prop
```vue
<!-- ❌ P3: Not using ui prop for customization -->
<template>
  <UCard class="rounded-2xl shadow-xl p-8">
    <p>Content</p>
  </UCard>
</template>

<!-- ✅ Correct: Proper ui prop usage -->
<template>
  <UCard
    :ui="{
      rounded: 'rounded-2xl',
      shadow: 'shadow-xl hover:shadow-2xl',
      body: {
        padding: 'p-8',
        background: 'bg-white dark:bg-brand-midnight'
      },
      ring: 'ring-1 ring-brand-coral/20'
    }"
    class="transition-shadow duration-300"
  >
    <p class="text-gray-700 dark:text-gray-300">Content</p>
  </UCard>
</template>
```

## MCP Server Integration

When Nuxt UI MCP server is available:

### Component Prop Validation
```typescript
// Before validating customization depth, get actual component API
const componentDocs = await mcp.nuxt_ui.get_component("UButton");

// Validate that used props exist
// componentDocs.props: ['color', 'size', 'variant', 'icon', 'loading', 'disabled', ...]

// Check for underutilized props
const usedProps = ['color', 'size']; // From component code
const availableProps = componentDocs.props;
const unutilizedProps = availableProps.filter(p => !usedProps.includes(p));

// Suggest: "Consider using 'icon' or 'loading' props for richer UX"
```

### UI Prop Structure Validation
```typescript
// Validate ui prop structure against schema
const uiSchema = componentDocs.ui_schema;

// User code: :ui="{ font: 'font-heading', rounded: 'rounded-full' }"
// Validate: Are 'font' and 'rounded' valid keys in ui prop?
// Suggest: Other available ui customizations (padding, shadow, etc.)
```

### Consistency Across Components
```typescript
// Check multiple component instances
const buttonInstances = findAllComponents("UButton");

// Analyze customization patterns
// Flag: Component used with 5 different customization styles
// Suggest: Create composable or variant system for consistency
```

## Benefits

### Immediate Impact
- **Prevents Generic Appearance**: Ensures components are branded, not defaults
- **Enforces Design Consistency**: Catches pattern drift across components
- **Improves User Feedback**: Validates loading states and interactions
- **Educates on Component API**: Shows developers full customization capabilities

### Long-term Value
- **Consistent Component Library**: All components follow design system
- **Faster Component Development**: Clear patterns and examples
- **Better Code Maintainability**: Reusable component variants
- **Reduced Visual Debt**: Prevents accumulation of one-off styles

## Usage Examples

### During Component Usage
```vue
// Developer adds: <UButton>Click me</UButton>
// SKILL immediately activates: "⚠️ P1: UButton using all default props. Customize with color, size, variant, and ui prop for brand distinctiveness."
```

### During Async Actions
```vue
// Developer creates async button: <UButton @click="submitForm">Submit</UButton>
// SKILL immediately activates: "⚠️ P1: Button triggers async action but lacks :loading prop. Add loading state for user feedback."
```

### During Refactoring
```vue
// Developer adds 5th different button style
// SKILL immediately activates: "⚠️ P2: UButton used with 5 different customization patterns. Consider creating reusable variants for consistency."
```

### Before Deployment
```vue
// SKILL runs comprehensive check: "✅ Component aesthetic validation passed. 23 components with deep customization, consistent patterns, and proper loading states detected."
```

## Design System Maturity Levels

### Level 0: Defaults Only (Avoid)
```vue
<UButton>Action</UButton>
<UCard><p>Content</p></UCard>
<UInput v-model="value" />
```
**Issues**: Generic appearance, no brand identity, inconsistent with custom design

### Level 1: Basic Props (Minimum)
```vue
<UButton color="primary" size="lg">Action</UButton>
<UCard class="shadow-lg"><p>Content</p></UCard>
<UInput v-model="value" placeholder="Enter value" />
```
**Better**: Some customization, but limited depth

### Level 2: UI Prop + Classes (Target)
```vue
<UButton
  color="primary"
  size="lg"
  :ui="{ rounded: 'rounded-full', font: 'font-heading' }"
  class="transition-all duration-300 hover:scale-105"
>
  Action
</UButton>

<UCard
  :ui="{
    background: 'bg-white dark:bg-brand-midnight',
    ring: 'ring-1 ring-brand-coral/20',
    shadow: 'shadow-xl'
  }"
>
  <p>Content</p>
</UCard>
```
**Ideal**: Deep customization, brand-distinctive, consistent patterns

### Level 3: Design System (Advanced)
```vue
<!-- Reusable variants from composables -->
<UButton v-bind="designSystem.button.variants.primary">
  Action
</UButton>

<UCard v-bind="designSystem.card.variants.elevated">
  <p>Content</p>
</UCard>
```
**Advanced**: Centralized design system, maximum consistency

## Component Customization Checklist

For each Nuxt UI component, validate:

- [ ] **Props**: Uses at least 2-3 props (color, size, variant, etc.)
- [ ] **UI Prop**: Includes `ui` prop for deep customization (rounded, font, padding, shadow)
- [ ] **Classes**: Adds Tailwind utilities for animations and effects
- [ ] **Loading State**: Async actions have `:loading` and `:disabled` props
- [ ] **Icons**: Includes relevant icons for clarity (`:icon` prop or slot)
- [ ] **Hover State**: Interactive elements have hover feedback
- [ ] **Focus State**: Keyboard navigation has visible focus styles
- [ ] **Dark Mode**: Includes dark mode variants in `ui` prop
- [ ] **Spacing**: Uses Tailwind spacing scale (4, 6, 8, 12, 16)
- [ ] **Consistency**: Follows same patterns as other instances

This SKILL ensures every Nuxt UI component is deeply customized, consistently styled, and provides excellent user feedback, preventing the default/generic appearance that makes AI-generated UIs immediately recognizable.
