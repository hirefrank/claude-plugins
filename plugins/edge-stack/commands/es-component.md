---
description: Scaffold Nuxt UI components with distinctive design, accessibility, and animation best practices built-in. Prevents generic aesthetics from the start.
---

# Component Generator Command

<command_purpose> Generate Nuxt UI components with distinctive design patterns, deep customization, accessibility features, and engaging animations built-in. Prevents generic "AI aesthetic" by providing branded templates from the start. </command_purpose>

## Introduction

<role>Senior Component Architect with expertise in Nuxt UI, Vue 3 Composition API, Tailwind CSS, accessibility, and distinctive design patterns</role>

**Design Philosophy**: Start with distinctive, accessible, engaging components rather than fixing generic patterns later.

## Prerequisites

<requirements>
- Nuxt 4 project with Vue 3
- Nuxt UI component library installed
- Tailwind 4 CSS configured with custom theme (or will be created)
- (Optional) Nuxt UI MCP server for component API validation
- (Optional) Existing `composables/useDesignSystem.ts` for consistent patterns
</requirements>

## Command Usage

```bash
/es-component <type> <name> [options]
```

### Arguments:

- `<type>`: Component type (button, card, form, modal, hero, navigation, etc.)
- `<name>`: Component name in PascalCase (e.g., `PrimaryButton`, `FeatureCard`)
- `[options]`: Optional flags:
  - `--theme <dark|light|custom>`: Theme variant
  - `--animations <minimal|standard|rich>`: Animation complexity
  - `--accessible`: Include enhanced accessibility features (default: true)
  - `--output <path>`: Custom output path (default: `components/`)

### Examples:

```bash
# Generate primary button component
/es-component button PrimaryButton

# Generate feature card with rich animations
/es-component card FeatureCard --animations rich

# Generate hero section with custom theme
/es-component hero LandingHero --theme custom

# Generate modal with custom output path
/es-component modal ConfirmDialog --output components/dialogs/
```

## Main Tasks

### 1. Project Context Analysis

<thinking>
First, I need to understand existing design system, theme configuration, and component patterns.
This ensures generated components match existing project aesthetics.
</thinking>

#### Immediate Actions:

<task_list>

- [ ] Check for `tailwind.config.ts` and extract custom theme (fonts, colors, animations)
- [ ] Check for `composables/useDesignSystem.ts` and extract existing variants
- [ ] Check for `app.config.ts` and extract Nuxt UI global customization
- [ ] Scan existing components for naming conventions and structure patterns
- [ ] Determine if design system is established or needs creation

</task_list>

#### Output Summary:

<summary_format>
📦 **Project Context**:
- Custom fonts: Found/Not Found (Inter ❌ or Custom ✅)
- Brand colors: Found/Not Found (Purple ❌ or Custom ✅)
- Design system composable: Exists/Missing
- Component count: X components found
- Naming convention: Detected pattern
</summary_format>

### 2. Validate Component Type with MCP (if available)

<thinking>
If Nuxt UI MCP is available, validate that the requested component type exists
and get accurate props/slots before generating.
</thinking>

#### MCP Validation:

<mcp_workflow>

If Nuxt UI MCP available:
1. Query `nuxt-ui.list_components()` to get available components
2. Map component type to Nuxt UI component:
   - `button` → `UButton`
   - `card` → `UCard`
   - `modal` → `UModal`
   - `form` → `UForm` + `UInput`/`UTextarea`/etc.
   - `hero` → Custom layout with `UButton`, `UCard`
   - `navigation` → `UTabs` or custom
3. Query `nuxt-ui.get_component("UButton")` for accurate props
4. Use real props in generated component (prevent hallucination)

If MCP not available:
- Use documented Nuxt UI API
- Include comment: "// TODO: Verify props with Nuxt UI docs"

</mcp_workflow>

### 3. Generate Component with Design Best Practices

<thinking>
Generate Vue component with:
1. Distinctive typography (custom fonts, not Inter)
2. Brand colors (custom palette, not purple)
3. Rich animations (transitions, micro-interactions)
4. Deep Nuxt UI customization (ui prop + utilities)
5. Accessibility features (ARIA, keyboard, focus states)
6. Responsive design
</thinking>

#### Component Templates by Type:

#### Button Component

<button_template>

```vue
<!-- components/PrimaryButton.vue -->
<script setup lang="ts">
import { computed } from 'vue';

interface Props {
  /** Button label */
  label?: string;
  /** Icon name (Iconify format) */
  icon?: string;
  /** Loading state */
  loading?: boolean;
  /** Disabled state */
  disabled?: boolean;
  /** Button size */
  size?: 'sm' | 'md' | 'lg' | 'xl';
  /** Full width */
  fullWidth?: boolean;
}

const props = withDefaults(defineProps<Props>(), {
  label: '',
  icon: '',
  loading: false,
  disabled: false,
  size: 'lg',
  fullWidth: false
});

const emit = defineEmits<{
  click: [event: MouseEvent];
}>();

const buttonClasses = computed(() => ({
  'w-full': props.fullWidth
}));
</script>

<template>
  <UButton
    :color="primary"
    :size="size"
    :loading="loading"
    :disabled="disabled || loading"
    :icon="icon"
    :ui="{
      font: 'font-heading tracking-wide',
      rounded: 'rounded-full',
      padding: {
        sm: 'px-4 py-2',
        md: 'px-6 py-3',
        lg: 'px-8 py-4',
        xl: 'px-10 py-5'
      },
      shadow: 'shadow-lg hover:shadow-xl'
    }"
    :class="[
      'transition-all duration-300 ease-out',
      'hover:scale-105 hover:-rotate-1',
      'active:scale-95 active:rotate-0',
      'focus:outline-none',
      'focus-visible:ring-2 focus-visible:ring-primary-500 focus-visible:ring-offset-2',
      'motion-safe:hover:scale-105',
      'motion-reduce:hover:bg-primary-700',
      buttonClasses
    ]"
    @click="emit('click', $event)"
  >
    <span class="inline-flex items-center gap-2">
      <slot>{{ label }}</slot>

      <!-- Animated icon on hover -->
      <UIcon
        v-if="icon && !loading"
        :name="icon"
        class="
          transition-transform duration-300
          group-hover:translate-x-1 group-hover:-translate-y-0.5
        "
      />
    </span>
  </UButton>
</template>
```

**Usage Example**:
```vue
<script setup>
const handleClick = () => {
  console.log('Clicked!');
};
</script>

<template>
  <PrimaryButton
    label="Get Started"
    icon="i-heroicons-arrow-right"
    size="lg"
    @click="handleClick"
  />
</template>
```

</button_template>

#### Card Component

<card_template>

```vue
<!-- components/FeatureCard.vue -->
<script setup lang="ts">
import { ref } from 'vue';

interface Props {
  /** Card title */
  title: string;
  /** Card description */
  description?: string;
  /** Icon name */
  icon?: string;
  /** Enable hover effects */
  hoverable?: boolean;
  /** Card variant */
  variant?: 'default' | 'elevated' | 'outlined';
}

const props = withDefaults(defineProps<Props>(), {
  description: '',
  icon: '',
  hoverable: true,
  variant: 'elevated'
});

const isHovered = ref(false);

const cardUi = computed(() => ({
  background: 'bg-white dark:bg-brand-midnight',
  ring: props.variant === 'outlined' ? 'ring-1 ring-brand-coral/20' : '',
  rounded: 'rounded-2xl',
  shadow: props.variant === 'elevated' ? 'shadow-xl hover:shadow-2xl' : 'shadow-md',
  body: {
    padding: 'p-8',
    background: 'bg-gradient-to-br from-white to-gray-50 dark:from-brand-midnight dark:to-gray-900'
  }
}));
</script>

<template>
  <UCard
    :ui="cardUi"
    :class="[
      'transition-all duration-300',
      hoverable && 'hover:-translate-y-2 hover:rotate-1 cursor-pointer',
      'motion-safe:hover:-translate-y-2',
      'motion-reduce:hover:shadow-xl'
    ]"
    @mouseenter="isHovered = true"
    @mouseleave="isHovered = false"
  >
    <div class="space-y-4">
      <!-- Icon -->
      <div
        v-if="icon"
        :class="[
          'inline-flex items-center justify-center',
          'w-16 h-16 rounded-2xl',
          'bg-gradient-to-br from-brand-coral to-brand-ocean',
          'transition-transform duration-300',
          isHovered && 'scale-110 rotate-3'
        ]"
      >
        <UIcon
          :name="icon"
          class="w-8 h-8 text-white"
        />
      </div>

      <!-- Title -->
      <h3
        :class="[
          'font-heading text-2xl',
          'text-brand-midnight dark:text-white',
          'transition-colors duration-300',
          isHovered && 'text-brand-coral'
        ]"
      >
        {{ title }}
      </h3>

      <!-- Description -->
      <p
        v-if="description"
        class="text-gray-700 dark:text-gray-300 leading-relaxed"
      >
        {{ description }}
      </p>

      <!-- Default slot for custom content -->
      <div v-if="$slots.default">
        <slot />
      </div>

      <!-- Footer slot -->
      <div v-if="$slots.footer" class="pt-4 border-t border-gray-200 dark:border-gray-700">
        <slot name="footer" />
      </div>
    </div>
  </UCard>
</template>
```

**Usage Example**:
```vue
<template>
  <FeatureCard
    title="Fast Deployment"
    description="Deploy to the edge in seconds with Cloudflare Workers"
    icon="i-heroicons-rocket-launch"
    hoverable
  >
    <template #footer>
      <PrimaryButton label="Learn More" size="sm" />
    </template>
  </FeatureCard>
</template>
```

</card_template>

#### Form Component

<form_template>

```vue
<!-- components/ContactForm.vue -->
<script setup lang="ts">
import { ref, reactive } from 'vue';
import { z } from 'zod';
import type { FormSubmitEvent } from '#ui/types';

// Validation schema
const schema = z.object({
  name: z.string().min(2, 'Name must be at least 2 characters'),
  email: z.string().email('Invalid email address'),
  message: z.string().min(10, 'Message must be at least 10 characters')
});

type Schema = z.output<typeof schema>;

const formData = reactive<Schema>({
  name: '',
  email: '',
  message: ''
});

const isSubmitting = ref(false);
const showSuccess = ref(false);
const showError = ref(false);
const errorMessage = ref('');

const onSubmit = async (event: FormSubmitEvent<Schema>) => {
  isSubmitting.value = true;
  showSuccess.value = false;
  showError.value = false;

  try {
    // Simulate API call
    await new Promise(resolve => setTimeout(resolve, 2000));

    console.log('Form submitted:', event.data);

    showSuccess.value = true;

    // Reset form
    formData.name = '';
    formData.email = '';
    formData.message = '';

    // Hide success message after 5 seconds
    setTimeout(() => {
      showSuccess.value = false;
    }, 5000);
  } catch (error) {
    showError.value = true;
    errorMessage.value = 'Failed to submit form. Please try again.';
  } finally {
    isSubmitting.value = false;
  }
};
</script>

<template>
  <div class="space-y-6">
    <!-- Success Alert -->
    <Transition
      enter-active-class="transition-all duration-300 ease-out"
      enter-from-class="opacity-0 translate-y-2 scale-95"
      enter-to-class="opacity-100 translate-y-0 scale-100"
      leave-active-class="transition-all duration-200 ease-in"
      leave-from-class="opacity-100"
      leave-to-class="opacity-0"
    >
      <UAlert
        v-if="showSuccess"
        color="green"
        icon="i-heroicons-check-circle"
        title="Success!"
        description="Your message has been sent successfully."
        :closable="true"
        :ui="{ rounded: 'rounded-xl', padding: 'p-4' }"
        @close="showSuccess = false"
      />
    </Transition>

    <!-- Error Alert -->
    <Transition
      enter-active-class="transition-all duration-300 ease-out"
      enter-from-class="opacity-0 translate-y-2"
      enter-to-class="opacity-100 translate-y-0"
    >
      <UAlert
        v-if="showError"
        color="red"
        icon="i-heroicons-x-circle"
        title="Error"
        :description="errorMessage"
        :closable="true"
        @close="showError = false"
      />
    </Transition>

    <!-- Form -->
    <UForm
      :schema="schema"
      :state="formData"
      class="space-y-6"
      @submit="onSubmit"
    >
      <!-- Name Field -->
      <UFormGroup
        label="Name"
        name="name"
        required
        :ui="{ label: { base: 'font-medium text-sm' } }"
      >
        <UInput
          v-model="formData.name"
          placeholder="Your name"
          icon="i-heroicons-user"
          :ui="{
            rounded: 'rounded-lg',
            padding: { sm: 'px-4 py-3' },
            icon: { leading: { padding: { sm: 'ps-11' } } }
          }"
          class="transition-all duration-200 focus-within:ring-2 focus-within:ring-brand-coral"
        />
      </UFormGroup>

      <!-- Email Field -->
      <UFormGroup
        label="Email"
        name="email"
        required
      >
        <UInput
          v-model="formData.email"
          type="email"
          placeholder="your@email.com"
          icon="i-heroicons-envelope"
          :ui="{
            rounded: 'rounded-lg',
            padding: { sm: 'px-4 py-3' }
          }"
          class="transition-all duration-200 focus-within:ring-2 focus-within:ring-brand-coral"
        />
      </UFormGroup>

      <!-- Message Field -->
      <UFormGroup
        label="Message"
        name="message"
        required
      >
        <UTextarea
          v-model="formData.message"
          placeholder="Your message..."
          :rows="5"
          :ui="{
            rounded: 'rounded-lg',
            padding: { sm: 'px-4 py-3' }
          }"
          class="transition-all duration-200 focus-within:ring-2 focus-within:ring-brand-coral"
        />
      </UFormGroup>

      <!-- Submit Button -->
      <UButton
        type="submit"
        :loading="isSubmitting"
        :disabled="isSubmitting"
        color="primary"
        size="lg"
        :ui="{
          font: 'font-heading',
          rounded: 'rounded-full',
          padding: { lg: 'px-8 py-4' }
        }"
        class="
          w-full
          transition-all duration-300
          hover:scale-105 hover:shadow-xl
          active:scale-95
          motion-safe:hover:scale-105
          motion-reduce:hover:bg-primary-700
        "
      >
        <span class="inline-flex items-center gap-2">
          <UIcon
            v-if="!isSubmitting"
            name="i-heroicons-paper-airplane"
            class="transition-transform duration-300 group-hover:translate-x-1 group-hover:-translate-y-0.5"
          />
          {{ isSubmitting ? 'Sending...' : 'Send Message' }}
        </span>
      </UButton>
    </UForm>
  </div>
</template>
```

</form_template>

#### Hero Component

<hero_template>

```vue
<!-- components/LandingHero.vue -->
<script setup lang="ts">
interface Props {
  /** Hero title */
  title: string;
  /** Hero subtitle */
  subtitle?: string;
  /** Primary CTA label */
  primaryCta?: string;
  /** Secondary CTA label */
  secondaryCta?: string;
}

const props = withDefaults(defineProps<Props>(), {
  subtitle: '',
  primaryCta: 'Get Started',
  secondaryCta: 'Learn More'
});

const emit = defineEmits<{
  primaryClick: [];
  secondaryClick: [];
}>();
</script>

<template>
  <div class="relative min-h-screen flex items-center justify-center overflow-hidden">
    <!-- Atmospheric Background -->
    <div class="absolute inset-0 bg-gradient-to-br from-brand-cream via-white to-brand-ocean/10" />

    <!-- Animated Gradient Orbs -->
    <div
      class="absolute top-20 left-20 w-96 h-96 bg-brand-coral/20 rounded-full blur-3xl animate-pulse"
      aria-hidden="true"
    />
    <div
      class="absolute bottom-20 right-20 w-96 h-96 bg-brand-ocean/20 rounded-full blur-3xl animate-pulse"
      style="animation-delay: 1s;"
      aria-hidden="true"
    />

    <!-- Subtle Pattern Overlay -->
    <div
      class="absolute inset-0 opacity-5"
      style="background-image: radial-gradient(circle, #000 1px, transparent 1px); background-size: 20px 20px;"
      aria-hidden="true"
    />

    <!-- Content -->
    <div class="relative z-10 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-24">
      <div class="text-center space-y-8">
        <!-- Animated Badge -->
        <div
          class="
            inline-flex items-center gap-2
            px-4 py-2 rounded-full
            bg-brand-coral/10 border border-brand-coral/20
            text-brand-coral font-medium
            animate-in slide-in-from-top duration-500
          "
        >
          <UIcon name="i-heroicons-sparkles" class="w-4 h-4 animate-pulse" />
          <span class="text-sm">New: Now on Cloudflare Workers</span>
        </div>

        <!-- Title -->
        <h1
          class="
            font-heading text-6xl sm:text-7xl lg:text-8xl
            tracking-tighter leading-none
            text-brand-midnight dark:text-white
            animate-in slide-in-from-top duration-700
          "
          style="animation-delay: 100ms;"
        >
          {{ title }}
        </h1>

        <!-- Subtitle -->
        <p
          v-if="subtitle"
          class="
            max-w-2xl mx-auto
            text-xl sm:text-2xl leading-relaxed
            text-gray-700 dark:text-gray-300
            animate-in slide-in-from-top duration-700
          "
          style="animation-delay: 200ms;"
        >
          {{ subtitle }}
        </p>

        <!-- CTAs -->
        <div
          class="
            flex flex-col sm:flex-row items-center justify-center gap-4
            animate-in slide-in-from-top duration-700
          "
          style="animation-delay: 300ms;"
        >
          <UButton
            color="primary"
            size="xl"
            :ui="{
              font: 'font-heading tracking-wide',
              rounded: 'rounded-full',
              padding: { xl: 'px-10 py-5' }
            }"
            class="
              transition-all duration-300
              hover:scale-110 hover:-rotate-2 hover:shadow-2xl
              active:scale-95 active:rotate-0
              motion-safe:hover:scale-110
            "
            @click="emit('primaryClick')"
          >
            <span class="inline-flex items-center gap-2">
              {{ primaryCta }}
              <UIcon
                name="i-heroicons-arrow-right"
                class="transition-transform duration-300 group-hover:translate-x-2"
              />
            </span>
          </UButton>

          <UButton
            color="gray"
            variant="outline"
            size="xl"
            :ui="{
              font: 'font-sans',
              rounded: 'rounded-full'
            }"
            class="
              transition-all duration-300
              hover:scale-105 hover:shadow-lg
              active:scale-95
            "
            @click="emit('secondaryClick')"
          >
            {{ secondaryCta }}
          </UButton>
        </div>

        <!-- Slot for additional content -->
        <div v-if="$slots.default" class="mt-12">
          <slot />
        </div>
      </div>
    </div>
  </div>
</template>
```

</hero_template>

### 4. Create Design System Composable (if missing)

<thinking>
If design system composable doesn't exist, generate it to ensure consistency
across all components.
</thinking>

<design_system_composable>

```typescript
// composables/useDesignSystem.ts
import type { ButtonProps } from '#ui/types';

export const useDesignSystem = () => {
  /**
   * Button Variants
   */
  const button = {
    primary: {
      color: 'primary',
      size: 'lg',
      ui: {
        font: 'font-heading tracking-wide',
        rounded: 'rounded-full',
        padding: { lg: 'px-8 py-4' },
        shadow: 'shadow-lg hover:shadow-xl'
      },
      class: 'transition-all duration-300 hover:scale-105 hover:-rotate-1 active:scale-95 active:rotate-0'
    } as ButtonProps,

    secondary: {
      color: 'gray',
      variant: 'outline',
      size: 'md',
      ui: {
        font: 'font-sans',
        rounded: 'rounded-lg'
      },
      class: 'transition-colors duration-200 hover:bg-gray-100 dark:hover:bg-gray-800'
    } as ButtonProps,

    ghost: {
      variant: 'ghost',
      size: 'md',
      ui: {
        font: 'font-sans'
      },
      class: 'transition-colors duration-200'
    } as ButtonProps
  };

  /**
   * Card Variants
   */
  const card = {
    elevated: {
      ui: {
        background: 'bg-white dark:bg-brand-midnight',
        rounded: 'rounded-2xl',
        shadow: 'shadow-xl hover:shadow-2xl',
        body: { padding: 'p-8' }
      },
      class: 'transition-all duration-300 hover:-translate-y-1'
    },

    outlined: {
      ui: {
        background: 'bg-white dark:bg-brand-midnight',
        ring: 'ring-1 ring-brand-coral/20',
        rounded: 'rounded-2xl',
        body: { padding: 'p-8' }
      },
      class: 'transition-all duration-300 hover:ring-brand-coral/40'
    }
  };

  /**
   * Animation Presets
   */
  const animations = {
    fadeIn: 'animate-in fade-in duration-500',
    slideUp: 'animate-in slide-in-from-bottom duration-500',
    slideDown: 'animate-in slide-in-from-top duration-500',
    scaleIn: 'animate-in zoom-in duration-300',
    hover: {
      scale: 'transition-transform duration-300 hover:scale-105',
      lift: 'transition-all duration-300 hover:-translate-y-1',
      shadow: 'transition-shadow duration-300 hover:shadow-xl'
    }
  };

  return {
    button,
    card,
    animations
  };
};
```

</design_system_composable>

### 5. Generate Component Files

<thinking>
Create the actual files in the filesystem with proper naming and structure.
</thinking>

#### File Creation:

<file_creation_steps>

1. **Determine output path**:
   - Default: `components/<ComponentName>.vue`
   - Custom: User-specified `--output` path

2. **Generate component file**:
   - Use template for component type
   - Replace placeholders with actual names
   - Include TypeScript types
   - Include JSDoc comments
   - Include usage examples in comments

3. **Update or create design system composable** (if needed):
   - Path: `composables/useDesignSystem.ts`
   - Add new variants if applicable

4. **Generate Storybook story** (optional, if Storybook detected):
   - Path: `components/<ComponentName>.stories.ts`

5. **Generate test file** (optional):
   - Path: `components/<ComponentName>.spec.ts`

</file_creation_steps>

### 6. Validate Generated Component

<thinking>
Run validation to ensure generated component follows best practices.
</thinking>

#### Validation Checks:

<validation_checklist>

- [ ] Uses custom fonts (not Inter/Roboto)
- [ ] Uses brand colors (not default purple)
- [ ] Includes animations/transitions
- [ ] Has hover states on interactive elements
- [ ] Has focus states (focus-visible rings)
- [ ] Respects reduced motion (motion-safe/motion-reduce)
- [ ] Includes ARIA labels where needed
- [ ] Uses Nuxt UI components (not reinventing)
- [ ] Deep customization with `ui` prop
- [ ] TypeScript props interface
- [ ] JSDoc comments
- [ ] Accessible (keyboard navigation, screen readers)
- [ ] Responsive design
- [ ] Dark mode support

</validation_checklist>

## Output Format

<output_format>

```
✅ Component Generated: <ComponentName>

📁 Files Created:
- components/<ComponentName>.vue (primary component)
- composables/useDesignSystem.ts (updated/created)

🎨 Design Features:
✅ Custom typography (font-heading)
✅ Brand colors (brand-coral, brand-ocean)
✅ Rich animations (hover:scale-105, transitions)
✅ Deep Nuxt UI customization (ui prop)
✅ Accessibility features (ARIA, focus states)
✅ Reduced motion support (motion-safe)
✅ Responsive design
✅ Dark mode support

📖 Usage Example:

```vue
<script setup>
import { <ComponentName> } from '#components';

// Your component logic
</script>

<template>
  <<ComponentName>
    prop1="value1"
    prop2="value2"
    @event="handleEvent"
  />
</template>
```

🔍 Next Steps:
1. Review generated component in `components/<ComponentName>.vue`
2. Customize props/styles as needed
3. Test accessibility with keyboard navigation
4. Test animations with reduced motion preference
5. Run `/es-design-review` to validate design patterns
```

</output_format>

## Success Criteria

✅ Component generated successfully when:
- File created at correct path
- Uses distinctive design patterns (not generic)
- Includes all accessibility features
- Includes rich animations
- TypeScript types included
- Usage examples in comments
- Follows project conventions

## Post-Generation Actions

After generating component:
1. **Review code**: Open generated file and review
2. **Test component**: Add to a page and test interactions
3. **Validate design**: Run `/es-design-review` if needed
4. **Document**: Add to component library docs/Storybook

## Notes

- This command generates **starting templates** with best practices built-in
- Components are **fully customizable** after generation
- **Design system composable** ensures consistency across all generated components
- Use **Nuxt UI MCP** (if available) to prevent prop hallucination
- All generated components follow **WCAG 2.1 AA** accessibility standards
- Generated components respect **user's reduced motion preference**
