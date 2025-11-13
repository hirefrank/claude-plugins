---
name: animation-interaction-validator
description: Ensures engaging user experience through validation of animations, transitions, micro-interactions, and feedback states, preventing flat/static interfaces that lack polish and engagement
triggers: ["interactive element creation", "event handler addition", "state changes", "async actions", "form submissions"]
---

# Animation Interaction Validator SKILL

## Activation Patterns

This SKILL automatically activates when:
- Interactive elements are created (buttons, links, forms, inputs)
- Click, hover, or focus event handlers are added
- Component state changes (loading, success, error)
- Async operations are initiated (API calls, form submissions)
- Navigation or routing transitions occur
- Modal/dialog components are opened/closed
- Lists or data are updated dynamically

## Expertise Provided

### Animation & Interaction Validation
- **Transition Detection**: Ensures smooth state changes with CSS transitions
- **Hover State Validation**: Checks for hover feedback on interactive elements
- **Loading State Validation**: Ensures async actions have visual feedback
- **Micro-interaction Analysis**: Validates small, delightful animations
- **Focus State Validation**: Ensures keyboard navigation has visual feedback
- **Animation Performance**: Checks for performant animation patterns

### Specific Checks Performed

#### ❌ Critical Issues (Missing Feedback)
```vue
<!-- These patterns trigger alerts: -->

<!-- No hover state -->
<UButton @click="submit">Submit</UButton>

<!-- No loading state during async action -->
<UButton @click="async () => await submitForm()">Save</UButton>

<!-- Jarring state change (no transition) -->
<div v-if="showContent">Content</div>

<!-- No focus state -->
<a href="/page" class="text-blue-500">Link</a>

<!-- Form without feedback -->
<form @submit="handleSubmit">
  <UInput v-model="value" />
  <button type="submit">Submit</button>
</form>
```

#### ✅ Correct Interactive Patterns
```vue
<!-- These patterns are validated as correct: -->

<!-- Hover state with smooth transition -->
<UButton
  class="transition-all duration-300 hover:scale-105 hover:shadow-xl active:scale-95"
  @click="submit"
>
  Submit
</UButton>

<!-- Loading state with visual feedback -->
<UButton
  :loading="isSubmitting"
  :disabled="isSubmitting"
  class="transition-all duration-200"
  @click="handleSubmit"
>
  <span class="flex items-center gap-2">
    <UIcon
      v-if="!isSubmitting"
      name="i-heroicons-paper-airplane"
      class="transition-transform duration-300 group-hover:translate-x-1"
    />
    {{ isSubmitting ? 'Submitting...' : 'Submit' }}
  </span>
</UButton>

<!-- Smooth state transition -->
<Transition
  enter-active-class="transition-all duration-300 ease-out"
  enter-from-class="opacity-0 translate-y-4"
  enter-to-class="opacity-100 translate-y-0"
  leave-active-class="transition-all duration-200 ease-in"
  leave-from-class="opacity-100 translate-y-0"
  leave-to-class="opacity-0 translate-y-4"
>
  <div v-if="showContent">Content</div>
</Transition>

<!-- Focus state with ring -->
<a
  href="/page"
  class="text-blue-500 transition-colors duration-200 hover:text-blue-700 focus:outline-none focus-visible:ring-2 focus-visible:ring-blue-500 focus-visible:ring-offset-2"
>
  Link
</a>

<!-- Form with success/error feedback -->
<form @submit.prevent="handleSubmit" class="space-y-4">
  <UInput
    v-model="value"
    :error="errors.value"
    class="transition-all duration-200"
  />

  <UButton
    type="submit"
    :loading="isSubmitting"
    :disabled="isSubmitting"
    class="transition-all duration-300 hover:scale-105"
  >
    Submit
  </UButton>

  <!-- Success message with animation -->
  <Transition name="fade">
    <UAlert
      v-if="showSuccess"
      color="green"
      icon="i-heroicons-check-circle"
      title="Success!"
      class="animate-in slide-in-from-top"
    />
  </Transition>
</form>
```

## Integration Points

### Complementary to Existing Components
- **frontend-design-specialist agent**: Provides design direction, SKILL validates implementation
- **component-aesthetic-checker**: Validates component customization, SKILL validates interactions
- **nuxt-ui-design-validator**: Catches generic patterns, SKILL ensures engagement
- **accessibility-guardian agent**: Validates a11y, SKILL validates visual feedback

### Escalation Triggers
- Complex animation sequences → `frontend-design-specialist` agent
- Component interaction patterns → `nuxt-ui-architect` agent
- Performance concerns → `edge-performance-oracle` agent
- Accessibility issues → `accessibility-guardian` agent

## Validation Rules

### P1 - Critical (Missing User Feedback)
- **No Hover States**: Buttons/links without hover effects
- **No Loading States**: Async actions without loading indicators
- **Jarring State Changes**: Content appearing/disappearing without transitions
- **No Focus States**: Interactive elements without keyboard focus indicators
- **Silent Errors**: Form errors without visual feedback

### P2 - Important (Enhanced Engagement)
- **No Micro-interactions**: Icons/elements without subtle animations
- **Static Navigation**: Page transitions without animations
- **Abrupt Modals**: Dialogs opening without enter/exit transitions
- **Instant Updates**: List changes without transition animations
- **No Disabled States**: Buttons during processing without visual change

### P3 - Polish (Delightful UX)
- **Limited Animation Variety**: Using only scale/opacity (no rotate, translate)
- **Generic Durations**: Not tuning animation speed for context
- **No Stagger**: List items appearing simultaneously (no stagger effect)
- **Missing Success States**: Completed actions without celebration animation
- **No Hover Anticipation**: No visual hint before interaction is possible

## Remediation Examples

### Fixing Missing Hover States
```vue
<!-- ❌ Critical: No hover feedback -->
<template>
  <UButton @click="handleClick">
    Click me
  </UButton>
</template>

<!-- ✅ Correct: Multi-dimensional hover effects -->
<template>
  <UButton
    class="
      transition-all duration-300 ease-out
      hover:scale-105 hover:shadow-xl hover:-rotate-1
      active:scale-95 active:rotate-0
      focus-visible:ring-2 focus-visible:ring-offset-2 focus-visible:ring-primary-500
    "
    @click="handleClick"
  >
    <span class="inline-flex items-center gap-2">
      Click me
      <UIcon
        name="i-heroicons-arrow-right"
        class="transition-transform duration-300 group-hover:translate-x-1"
      />
    </span>
  </UButton>
</template>
```

### Fixing Missing Loading States
```vue
<!-- ❌ Critical: No loading feedback during async action -->
<script setup>
const submitForm = async () => {
  await api.submit(formData);
};
</script>

<template>
  <UButton @click="submitForm">
    Submit
  </UButton>
</template>

<!-- ✅ Correct: Complete loading state with animations -->
<script setup>
const isSubmitting = ref(false);
const showSuccess = ref(false);

const submitForm = async () => {
  isSubmitting.value = true;
  try {
    await api.submit(formData);
    showSuccess.value = true;
    setTimeout(() => showSuccess.value = false, 3000);
  } catch (error) {
    // Error handling
  } finally {
    isSubmitting.value = false;
  }
};
</script>

<template>
  <div class="space-y-4">
    <UButton
      :loading="isSubmitting"
      :disabled="isSubmitting"
      class="
        transition-all duration-300
        hover:scale-105 hover:shadow-xl
        disabled:opacity-50 disabled:cursor-not-allowed
      "
      @click="submitForm"
    >
      <span class="flex items-center gap-2">
        <UIcon
          v-if="!isSubmitting"
          name="i-heroicons-paper-airplane"
          class="transition-all duration-300 group-hover:translate-x-1 group-hover:-translate-y-1"
        />
        {{ isSubmitting ? 'Submitting...' : 'Submit' }}
      </span>
    </UButton>

    <!-- Success feedback with animation -->
    <Transition
      enter-active-class="transition-all duration-500 ease-out"
      enter-from-class="opacity-0 scale-50"
      enter-to-class="opacity-100 scale-100"
      leave-active-class="transition-all duration-300 ease-in"
      leave-from-class="opacity-100 scale-100"
      leave-to-class="opacity-0 scale-50"
    >
      <UAlert
        v-if="showSuccess"
        color="green"
        icon="i-heroicons-check-circle"
        title="Success!"
        description="Your form has been submitted."
      />
    </Transition>
  </div>
</template>
```

### Fixing Jarring State Changes
```vue
<!-- ❌ Critical: Content appears/disappears abruptly -->
<template>
  <div>
    <UButton @click="showContent = !showContent">
      Toggle
    </UButton>

    <div v-if="showContent">
      <p>This content appears instantly (jarring)</p>
    </div>
  </div>
</template>

<!-- ✅ Correct: Smooth transitions -->
<template>
  <div class="space-y-4">
    <UButton
      class="transition-all duration-300 hover:scale-105"
      @click="showContent = !showContent"
    >
      {{ showContent ? 'Hide' : 'Show' }} Content
    </UButton>

    <Transition
      enter-active-class="transition-all duration-300 ease-out"
      enter-from-class="opacity-0 translate-y-4 scale-95"
      enter-to-class="opacity-100 translate-y-0 scale-100"
      leave-active-class="transition-all duration-200 ease-in"
      leave-from-class="opacity-100 translate-y-0 scale-100"
      leave-to-class="opacity-0 translate-y-4 scale-95"
    >
      <div v-if="showContent" class="p-6 bg-gray-50 dark:bg-gray-800 rounded-lg">
        <p>This content transitions smoothly</p>
      </div>
    </Transition>
  </div>
</template>
```

### Fixing Missing Focus States
```vue
<!-- ❌ Critical: No visible focus state -->
<template>
  <nav>
    <a href="/" class="text-gray-700">Home</a>
    <a href="/about" class="text-gray-700">About</a>
    <a href="/contact" class="text-gray-700">Contact</a>
  </nav>
</template>

<!-- ✅ Correct: Clear focus states for keyboard navigation -->
<template>
  <nav class="flex gap-4">
    <a
      href="/"
      class="
        text-gray-700 dark:text-gray-300
        transition-all duration-200
        hover:text-primary-600 hover:translate-y-[-2px]
        focus:outline-none
        focus-visible:ring-2 focus-visible:ring-primary-500 focus-visible:ring-offset-2
        rounded px-3 py-2
      "
    >
      Home
    </a>
    <a
      href="/about"
      class="
        text-gray-700 dark:text-gray-300
        transition-all duration-200
        hover:text-primary-600 hover:translate-y-[-2px]
        focus:outline-none
        focus-visible:ring-2 focus-visible:ring-primary-500 focus-visible:ring-offset-2
        rounded px-3 py-2
      "
    >
      About
    </a>
    <a
      href="/contact"
      class="
        text-gray-700 dark:text-gray-300
        transition-all duration-200
        hover:text-primary-600 hover:translate-y-[-2px]
        focus:outline-none
        focus-visible:ring-2 focus-visible:ring-primary-500 focus-visible:ring-offset-2
        rounded px-3 py-2
      "
    >
      Contact
    </a>
  </nav>
</template>
```

### Adding Micro-interactions
```vue
<!-- ❌ P2: Static icons without micro-interactions -->
<template>
  <UButton icon="i-heroicons-heart">
    Like
  </UButton>
</template>

<!-- ✅ Correct: Animated icon micro-interaction -->
<script setup>
const isLiked = ref(false);
const heartScale = ref(1);

const toggleLike = () => {
  isLiked.value = !isLiked.value;

  // Bounce animation
  heartScale.value = 1.3;
  setTimeout(() => heartScale.value = 1, 200);
};
</script>

<template>
  <UButton
    :color="isLiked ? 'red' : 'gray'"
    class="transition-all duration-300 hover:scale-105"
    @click="toggleLike"
  >
    <span class="inline-flex items-center gap-2">
      <UIcon
        :name="isLiked ? 'i-heroicons-heart-solid' : 'i-heroicons-heart'"
        :style="{ transform: `scale(${heartScale})` }"
        :class="[
          'transition-all duration-200',
          isLiked ? 'text-red-500 animate-pulse' : 'text-gray-500'
        ]"
      />
      {{ isLiked ? 'Liked' : 'Like' }}
    </span>
  </UButton>
</template>
```

## Animation Best Practices

### Performance-First Animations

✅ **Performant Properties** (GPU-accelerated):
- `transform` (translate, scale, rotate)
- `opacity`
- `filter` (backdrop-blur, etc.)

❌ **Avoid Animating** (causes reflow/repaint):
- `width`, `height`
- `top`, `left`, `right`, `bottom`
- `margin`, `padding`
- `border-width`

```vue
<!-- ❌ P2: Animating width (causes reflow) -->
<div class="transition-all hover:w-64">Content</div>

<!-- ✅ Correct: Using transform (GPU-accelerated) -->
<div class="transition-transform hover:scale-110">Content</div>
```

### Animation Duration Guidelines

- **Fast** (100-200ms): Hover states, small movements
- **Medium** (300-400ms): State changes, content transitions
- **Slow** (500-800ms): Page transitions, major UI changes
- **Very Slow** (1000ms+): Celebration animations, complex sequences

```vue
<!-- Context-appropriate durations -->
<UButton class="transition-all duration-200 hover:scale-105">
  <!-- Fast hover: 200ms -->
</UButton>

<Transition
  enter-active-class="transition-all duration-300"
  leave-active-class="transition-all duration-300"
>
  <!-- Content change: 300ms -->
  <div v-if="show">Content</div>
</Transition>

<div class="animate-in slide-in-from-bottom duration-500">
  <!-- Page load: 500ms -->
  Main content
</div>
```

### Easing Functions

- `ease-out`: Starting animations (entering content)
- `ease-in`: Ending animations (exiting content)
- `ease-in-out`: Bidirectional animations
- `linear`: Loading spinners, continuous animations

```vue
<!-- Appropriate easing -->
<Transition
  enter-active-class="transition-all duration-300 ease-out"
  leave-active-class="transition-all duration-200 ease-in"
>
  <div v-if="show">Content</div>
</Transition>
```

## Advanced Interaction Patterns

### Staggered List Animations
```vue
<script setup>
const items = ref([1, 2, 3, 4, 5]);
</script>

<template>
  <TransitionGroup
    name="list"
    tag="div"
    class="space-y-2"
  >
    <div
      v-for="(item, index) in items"
      :key="item"
      :style="{ transitionDelay: `${index * 50}ms` }"
      class="
        transition-all duration-300 ease-out
        hover:scale-105 hover:shadow-lg
      "
    >
      Item {{ item }}
    </div>
  </TransitionGroup>
</template>

<style scoped>
.list-enter-active,
.list-leave-active {
  transition: all 0.3s ease;
}

.list-enter-from {
  opacity: 0;
  transform: translateX(-20px);
}

.list-leave-to {
  opacity: 0;
  transform: translateX(20px);
}

.list-move {
  transition: transform 0.3s ease;
}
</style>
```

### Success Celebration Animation
```vue
<script setup>
const showSuccess = ref(false);

const celebrate = () => {
  showSuccess.value = true;
  // Confetti or celebration animation here
  setTimeout(() => showSuccess.value = false, 3000);
};
</script>

<template>
  <div>
    <UButton
      @click="celebrate"
      class="transition-all duration-300 hover:scale-110 hover:rotate-3"
    >
      Complete Task
    </UButton>

    <Transition
      enter-active-class="transition-all duration-500 ease-out"
      enter-from-class="opacity-0 scale-0 rotate-180"
      enter-to-class="opacity-100 scale-100 rotate-0"
    >
      <div
        v-if="showSuccess"
        class="fixed inset-0 flex items-center justify-center bg-black/20 backdrop-blur-sm"
      >
        <div class="bg-white dark:bg-gray-800 p-8 rounded-2xl shadow-2xl">
          <UIcon
            name="i-heroicons-check-circle"
            class="w-16 h-16 text-green-500 animate-bounce"
          />
          <p class="mt-4 text-xl font-heading">Success!</p>
        </div>
      </div>
    </Transition>
  </div>
</template>
```

### Loading Skeleton with Pulse
```vue
<template>
  <div v-if="loading" class="space-y-4">
    <div class="animate-pulse">
      <div class="h-4 bg-gray-200 dark:bg-gray-700 rounded w-3/4"></div>
      <div class="h-4 bg-gray-200 dark:bg-gray-700 rounded w-1/2 mt-2"></div>
      <div class="h-32 bg-gray-200 dark:bg-gray-700 rounded mt-4"></div>
    </div>
  </div>

  <Transition
    enter-active-class="transition-all duration-500 ease-out"
    enter-from-class="opacity-0 translate-y-4"
    enter-to-class="opacity-100 translate-y-0"
  >
    <div v-if="!loading">
      <!-- Actual content -->
    </div>
  </Transition>
</template>
```

## MCP Server Integration

While this SKILL doesn't directly use MCP servers, it complements MCP-enhanced agents:

- **Nuxt UI MCP**: Validates that suggested animations work with Nuxt UI components
- **Cloudflare MCP**: Ensures animations don't bloat bundle size (performance check)

## Benefits

### Immediate Impact
- **Prevents Flat UI**: Ensures engaging, polished interactions
- **Improves Perceived Performance**: Loading states make waits feel shorter
- **Better Accessibility**: Focus states improve keyboard navigation
- **Professional Polish**: Micro-interactions signal quality

### Long-term Value
- **Higher User Engagement**: Delightful animations encourage interaction
- **Reduced Bounce Rate**: Polished UI keeps users engaged
- **Better Brand Perception**: Professional animations signal quality
- **Consistent UX**: All interactions follow same animation patterns

## Usage Examples

### During Button Creation
```vue
// Developer adds: <UButton @click="submit">Submit</UButton>
// SKILL immediately activates: "⚠️ P1: Button lacks hover state. Add transition utilities: class='transition-all duration-300 hover:scale-105'"
```

### During Async Action
```vue
// Developer creates: const submitForm = async () => { await api.call(); }
// SKILL immediately activates: "⚠️ P1: Async action without loading state. Add :loading and :disabled props to button."
```

### During State Toggle
```vue
// Developer adds: <div v-if="show">Content</div>
// SKILL immediately activates: "⚠️ P1: Content appears abruptly. Wrap with <Transition> for smooth state changes."
```

### Before Deployment
```vue
// SKILL runs comprehensive check: "✅ Animation validation passed. 45 interactive elements with hover states, 12 async actions with loading feedback, 8 smooth transitions detected."
```

This SKILL ensures every interactive element provides engaging visual feedback, preventing the flat, static appearance that makes interfaces feel unpolished and reduces user engagement.
