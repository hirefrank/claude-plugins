---
description: Scaffold shadcn/ui components for Tanstack Start with distinctive design, accessibility, and animation best practices built-in. Prevents generic aesthetics from the start.
---

# Tanstack Component Generator Command

<command_purpose> Generate shadcn/ui components for Tanstack Start projects with distinctive design patterns, deep customization, accessibility features, and engaging animations built-in. Prevents generic "AI aesthetic" by providing branded templates from the start. </command_purpose>

## Introduction

<role>Senior Component Architect with expertise in shadcn/ui, Radix UI, React 19, Tailwind CSS, accessibility, and distinctive design patterns</role>

**Design Philosophy**: Start with distinctive, accessible, engaging components rather than fixing generic patterns later.

## Prerequisites

<requirements>
- Tanstack Start project with React 19
- shadcn/ui components installed
- Tailwind 4 CSS configured with custom theme
- (Optional) shadcn/ui MCP server for component API validation
</requirements>

## Command Usage

```bash
/es-tanstack-component <type> <name> [options]
```

### Arguments:

- `<type>`: Component type (button, card, form, dialog, dashboard, hero, etc.)
- `<name>`: Component name in PascalCase (e.g., `PrimaryButton`, `FeatureCard`)
- `[options]`: Optional flags:
  - `--theme <dark|light|custom>`: Theme variant
  - `--animations <minimal|standard|rich>`: Animation complexity
  - `--accessible`: Include enhanced accessibility features (default: true)
  - `--output <path>`: Custom output path (default: `src/components/`)

### Examples:

```bash
# Generate primary button component
/es-tanstack-component button PrimaryButton

# Generate feature card with rich animations
/es-tanstack-component card FeatureCard --animations rich

# Generate dashboard layout
/es-tanstack-component dashboard AdminDashboard --theme dark
```

## Main Tasks

### 1. Detect Project Framework

<thinking>
Verify this is a Tanstack Start project before generating components.
</thinking>

```bash
# Check for Tanstack Start
if ! grep -q "@tanstack/start" package.json; then
  echo "❌ Not a Tanstack Start project"
  echo "This command requires Tanstack Start."
  echo "Run /es-init to set up a new Tanstack Start project."
  exit 1
fi
```

### 2. Verify shadcn/ui Setup

```bash
# Check if shadcn/ui is initialized
if [ ! -f "components.json" ]; then
  echo "shadcn/ui not initialized. Running setup..."
  pnpx shadcn@latest init
fi
```

### 3. Install Required shadcn/ui Components

Use MCP to verify components and install:

```typescript
// Check if component exists via MCP
const components = await shadcn-ui.list_components()
const required = ['button', 'card', 'dialog'] // Based on type

for (const comp of required) {
  if (await componentInstalled(comp)) continue

  // Install via CLI
  await exec(`pnpx shadcn@latest add ${comp}`)
}
```

### 4. Generate Component with Distinctive Design

**Anti-Generic Aesthetics** (CRITICAL):

```tsx
// ❌ GENERIC (FORBIDDEN)
export function Button() {
  return (
    <button className="bg-purple-600 hover:bg-purple-700 font-inter">
      Click me
    </button>
  )
}

// ✅ DISTINCTIVE (REQUIRED)
export function PrimaryButton() {
  return (
    <Button
      className="bg-gradient-to-br from-amber-500 via-orange-500 to-rose-500
                 hover:scale-105 transition-all duration-300
                 shadow-lg shadow-orange-500/50
                 font-['Fraunces'] font-semibold"
    >
      Click me
    </Button>
  )
}
```

### 5. Component Templates

#### Button Component

```tsx
// src/components/PrimaryButton.tsx
import { Button } from "@/components/ui/button"
import type { ButtonProps } from "@/components/ui/button"

interface PrimaryButtonProps extends ButtonProps {
  loading?: boolean
}

export function PrimaryButton({
  children,
  loading,
  ...props
}: PrimaryButtonProps) {
  return (
    <Button
      disabled={loading}
      className="bg-amber-600 hover:bg-amber-700
                 hover:scale-105 transition-all duration-300
                 shadow-lg shadow-amber-500/30"
      {...props}
    >
      {loading && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
      {children}
    </Button>
  )
}
```

#### Card Component

```tsx
// src/components/FeatureCard.tsx
import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card"

interface FeatureCardProps {
  title: string
  description: string
  icon?: React.ReactNode
}

export function FeatureCard({ title, description, icon }: FeatureCardProps) {
  return (
    <Card className="hover:shadow-xl transition-shadow duration-300 border-amber-200">
      <CardHeader>
        {icon && <div className="mb-4">{icon}</div>}
        <CardTitle className="text-2xl font-['Fraunces'] text-amber-900">
          {title}
        </CardTitle>
      </CardHeader>
      <CardContent>
        <p className="text-gray-700">{description}</p>
      </CardContent>
    </Card>
  )
}
```

### 6. Generate Component File

**Task tanstack-ui-architect(component type and requirements)**:
- Verify component props via MCP
- Generate TypeScript interfaces
- Implement accessibility features
- Add distinctive styling (NOT generic)
- Include animation patterns
- Add JSDoc documentation
- Export component

### 7. Generate Storybook/Example (Optional)

Create example usage:

```tsx
// src/examples/PrimaryButtonExample.tsx
import { PrimaryButton } from "@/components/PrimaryButton"

export function PrimaryButtonExample() {
  return (
    <div className="flex gap-4">
      <PrimaryButton>Default</PrimaryButton>
      <PrimaryButton loading>Loading...</PrimaryButton>
      <PrimaryButton disabled>Disabled</PrimaryButton>
    </div>
  )
}
```

## Design System Guidelines

### Required Customizations

✅ **Custom Fonts** (NOT Inter/Roboto):
- Heading: Fraunces, Playfair Display, Merriweather
- Body: Source Sans, Open Sans, Lato

✅ **Custom Colors** (NOT purple gradients):
- Warm: Amber, Orange, Rose
- Cool: Teal, Sky, Indigo
- Earthy: Stone, Slate, Zinc

✅ **Thoughtful Animations**:
- Hover: scale-105, shadow transitions
- Focus: ring-offset with brand colors
- Loading: custom spinners

❌ **Forbidden**:
- Inter or Roboto fonts
- Purple gradients (#8B5CF6)
- Default shadcn/ui colors without customization
- Glass-morphism effects
- Generic spacing (always 1rem, 2rem)

## Validation

Before completing:

- [ ] Component props verified via MCP
- [ ] TypeScript types defined
- [ ] Accessibility features implemented (ARIA attributes)
- [ ] Keyboard navigation supported
- [ ] Distinctive design (NOT generic)
- [ ] Animations included
- [ ] Dark mode supported (if applicable)
- [ ] Example usage provided

## Resources

- **shadcn/ui**: https://ui.shadcn.com
- **Radix UI**: https://www.radix-ui.com
- **Tailwind CSS**: https://tailwindcss.com/docs
- **Google Fonts**: https://fonts.google.com

## Success Criteria

✅ Component generated with distinctive design
✅ No prop hallucination (MCP verified)
✅ Accessibility validated
✅ TypeScript types included
✅ Example usage provided
