---
description: Generate or update custom design themes for Tailwind CSS and Nuxt UI. Creates distinctive typography, colors, animations, and design tokens to prevent generic "AI aesthetic"
---

# Theme Generator Command

<command_purpose> Generate distinctive design themes that prevent generic aesthetics. Creates custom Tailwind configuration with unique fonts, brand colors, animation presets, and Nuxt UI customizations. Replaces Inter fonts, purple gradients, and minimal animations with branded alternatives. </command_purpose>

## Introduction

<role>Senior Design Systems Architect with expertise in Tailwind CSS theming, color theory, typography, animation design, and brand identity</role>

**Design Philosophy**: Establish a distinctive visual identity from the start through a comprehensive design system.

## Prerequisites

<requirements>
- Nuxt 4 project with Tailwind CSS configured
- Nuxt UI installed
- Access to custom font files or Google Fonts
- Brand color palette (or will be generated)
</requirements>

## Command Usage

```bash
/es-theme [options]
```

### Options:

- `--palette <name>`: Pre-defined color palette (coral-ocean, midnight-gold, forest-sage, custom)
- `--fonts <style>`: Font pairing style (modern, classic, playful, technical)
- `--animations <level>`: Animation richness (minimal, standard, rich)
- `--mode <create|update>`: Create new theme or update existing
- `--interactive`: Launch interactive theme builder

### Examples:

```bash
# Generate theme with coral-ocean palette and modern fonts
/es-theme --palette coral-ocean --fonts modern --animations rich

# Interactive theme builder
/es-theme --interactive

# Update existing theme
/es-theme --mode update
```

## Main Tasks

### 1. Analyze Current Theme

<thinking>
First, check if a theme already exists and analyze generic patterns.
</thinking>

#### Current Theme Analysis:

<analysis_steps>

- [ ] Check `tailwind.config.ts` for existing configuration
- [ ] Detect Inter/Roboto fonts (generic ❌)
- [ ] Detect default purple colors (generic ❌)
- [ ] Check for custom animation presets
- [ ] Check `app.config.ts` for Nuxt UI customization
- [ ] Analyze existing component usage patterns

</analysis_steps>

### 2. Generate Color Palette

<thinking>
Create or select a distinctive color palette that reflects brand identity.
Ensure all colors meet WCAG 2.1 AA contrast requirements.
</thinking>

#### Pre-defined Palettes:

<color_palettes>

**Coral Ocean** (Warm & Vibrant):
```typescript
colors: {
  brand: {
    coral: {
      50: '#FFF5F5',
      100: '#FFE3E3',
      200: '#FFC9C9',
      300: '#FFA8A8',
      400: '#FF8787',
      500: '#FF6B6B',  // Primary
      600: '#FA5252',
      700: '#F03E3E',
      800: '#E03131',
      900: '#C92A2A',
    },
    ocean: {
      50: '#F0FDFA',
      100: '#CCFBF1',
      200: '#99F6E4',
      300: '#5EEAD4',
      400: '#2DD4BF',
      500: '#4ECDC4',  // Secondary
      600: '#0D9488',
      700: '#0F766E',
      800: '#115E59',
      900: '#134E4A',
    },
    sunset: {
      50: '#FFFEF0',
      100: '#FFFACD',
      200: '#FFF59D',
      300: '#FFF176',
      400: '#FFEE58',
      500: '#FFE66D',  // Accent
      600: '#FDD835',
      700: '#FBC02D',
      800: '#F9A825',
      900: '#F57F17',
    },
    midnight: '#2C3E50',
    cream: '#FFF5E1'
  }
}
```

**Midnight Gold** (Elegant & Professional):
```typescript
colors: {
  brand: {
    midnight: {
      50: '#F8FAFC',
      100: '#F1F5F9',
      200: '#E2E8F0',
      300: '#CBD5E1',
      400: '#94A3B8',
      500: '#2C3E50',  // Primary
      600: '#475569',
      700: '#334155',
      800: '#1E293B',
      900: '#0F172A',
    },
    gold: {
      50: '#FFFBEB',
      100: '#FEF3C7',
      200: '#FDE68A',
      300: '#FCD34D',
      400: '#FBBF24',
      500: '#D4AF37',  // Secondary
      600: '#D97706',
      700: '#B45309',
      800: '#92400E',
      900: '#78350F',
    }
  }
}
```

**Forest Sage** (Natural & Calming):
```typescript
colors: {
  brand: {
    forest: {
      50: '#F0FDF4',
      100: '#DCFCE7',
      200: '#BBF7D0',
      300: '#86EFAC',
      400: '#4ADE80',
      500: '#2D5F3F',  // Primary
      600: '#16A34A',
      700: '#15803D',
      800: '#166534',
      900: '#14532D',
    },
    sage: {
      50: '#F7F7F5',
      100: '#EAEAE5',
      200: '#D4D4C8',
      300: '#B8B8A7',
      400: '#9C9C88',
      500: '#8B9A7C',  // Secondary
      600: '#6F7F63',
      700: '#5A664F',
      800: '#454D3F',
      900: '#313730',
    }
  }
}
```

</color_palettes>

### 3. Select Font Pairings

<thinking>
Choose distinctive font combinations that avoid Inter/Roboto.
Ensure fonts are performant and accessible.
</thinking>

#### Font Pairing Styles:

<font_pairings>

**Modern** (Clean & Contemporary):
```typescript
fontFamily: {
  sans: ['Space Grotesk', 'system-ui', 'sans-serif'],
  heading: ['Archivo Black', 'system-ui', 'sans-serif'],
  mono: ['JetBrains Mono', 'monospace']
}
```

**Classic** (Timeless & Professional):
```typescript
fontFamily: {
  sans: ['Crimson Pro', 'Georgia', 'serif'],
  heading: ['Playfair Display', 'Georgia', 'serif'],
  mono: ['IBM Plex Mono', 'monospace']
}
```

**Playful** (Creative & Energetic):
```typescript
fontFamily: {
  sans: ['DM Sans', 'system-ui', 'sans-serif'],
  heading: ['Fredoka', 'system-ui', 'sans-serif'],
  mono: ['Fira Code', 'monospace']
}
```

**Technical** (Precise & Modern):
```typescript
fontFamily: {
  sans: ['Inter Display', 'system-ui', 'sans-serif'],  // Display variant (different from default Inter)
  heading: ['JetBrains Mono', 'monospace'],
  mono: ['Source Code Pro', 'monospace']
}
```

</font_pairings>

### 4. Create Animation Presets

<thinking>
Define animation utilities that create engaging, performant micro-interactions.
</thinking>

#### Animation Configuration:

<animation_config>

```typescript
// tailwind.config.ts
export default {
  theme: {
    extend: {
      animation: {
        // Fade animations
        'fade-in': 'fadeIn 0.5s ease-out',
        'fade-out': 'fadeOut 0.3s ease-in',

        // Slide animations
        'slide-up': 'slideUp 0.4s ease-out',
        'slide-down': 'slideDown 0.4s ease-out',
        'slide-left': 'slideLeft 0.4s ease-out',
        'slide-right': 'slideRight 0.4s ease-out',

        // Scale animations
        'scale-in': 'scaleIn 0.3s ease-out',
        'scale-out': 'scaleOut 0.2s ease-in',

        // Bounce animations
        'bounce-subtle': 'bounceSubtle 1s ease-in-out infinite',

        // Pulse animations
        'pulse-slow': 'pulse 3s cubic-bezier(0.4, 0, 0.6, 1) infinite',
        'pulse-fast': 'pulse 1s cubic-bezier(0.4, 0, 0.6, 1) infinite',

        // Spin animations
        'spin-slow': 'spin 3s linear infinite',
        'spin-fast': 'spin 0.5s linear infinite',
      },

      keyframes: {
        fadeIn: {
          '0%': { opacity: '0' },
          '100%': { opacity: '1' },
        },
        fadeOut: {
          '0%': { opacity: '1' },
          '100%': { opacity: '0' },
        },
        slideUp: {
          '0%': { transform: 'translateY(20px)', opacity: '0' },
          '100%': { transform: 'translateY(0)', opacity: '1' },
        },
        slideDown: {
          '0%': { transform: 'translateY(-20px)', opacity: '0' },
          '100%': { transform: 'translateY(0)', opacity: '1' },
        },
        slideLeft: {
          '0%': { transform: 'translateX(20px)', opacity: '0' },
          '100%': { transform: 'translateX(0)', opacity: '1' },
        },
        slideRight: {
          '0%': { transform: 'translateX(-20px)', opacity: '0' },
          '100%': { transform: 'translateX(0)', opacity: '1' },
        },
        scaleIn: {
          '0%': { transform: 'scale(0.9)', opacity: '0' },
          '100%': { transform: 'scale(1)', opacity: '1' },
        },
        scaleOut: {
          '0%': { transform: 'scale(1)', opacity: '1' },
          '100%': { transform: 'scale(0.9)', opacity: '0' },
        },
        bounceSubtle: {
          '0%, 100%': { transform: 'translateY(0)' },
          '50%': { transform: 'translateY(-5px)' },
        },
      },

      // Transition duration extensions
      transitionDuration: {
        '400': '400ms',
        '600': '600ms',
        '800': '800ms',
        '900': '900ms',
      },
    },
  },
};
```

</animation_config>

### 5. Generate Complete Theme Configuration

<thinking>
Create complete tailwind.config.ts with all theme customizations.
</thinking>

#### Generated Tailwind Config:

<tailwind_config_template>

```typescript
// tailwind.config.ts
import type { Config } from 'tailwindcss';
import defaultTheme from 'tailwindcss/defaultTheme';

export default <Partial<Config>>{
  theme: {
    extend: {
      // Typography
      fontFamily: {
        sans: ['Space Grotesk', ...defaultTheme.fontFamily.sans],
        heading: ['Archivo Black', ...defaultTheme.fontFamily.sans],
        mono: ['JetBrains Mono', ...defaultTheme.fontFamily.mono],
      },

      fontSize: {
        // Extended font sizes with line heights
        '2xs': ['0.625rem', { lineHeight: '0.75rem' }],
        '6xl': ['3.75rem', { lineHeight: '1', letterSpacing: '-0.02em' }],
        '7xl': ['4.5rem', { lineHeight: '1', letterSpacing: '-0.02em' }],
        '8xl': ['6rem', { lineHeight: '1', letterSpacing: '-0.02em' }],
        '9xl': ['8rem', { lineHeight: '1', letterSpacing: '-0.02em' }],
      },

      // Brand Colors
      colors: {
        brand: {
          coral: {
            DEFAULT: '#FF6B6B',
            50: '#FFF5F5',
            100: '#FFE3E3',
            200: '#FFC9C9',
            300: '#FFA8A8',
            400: '#FF8787',
            500: '#FF6B6B',
            600: '#FA5252',
            700: '#F03E3E',
            800: '#E03131',
            900: '#C92A2A',
          },
          ocean: {
            DEFAULT: '#4ECDC4',
            50: '#F0FDFA',
            100: '#CCFBF1',
            200: '#99F6E4',
            300: '#5EEAD4',
            400: '#2DD4BF',
            500: '#4ECDC4',
            600: '#0D9488',
            700: '#0F766E',
            800: '#115E59',
            900: '#134E4A',
          },
          sunset: {
            DEFAULT: '#FFE66D',
            50: '#FFFEF0',
            100: '#FFFACD',
            200: '#FFF59D',
            300: '#FFF176',
            400: '#FFEE58',
            500: '#FFE66D',
            600: '#FDD835',
            700: '#FBC02D',
            800: '#F9A825',
            900: '#F57F17',
          },
          midnight: {
            DEFAULT: '#2C3E50',
            50: '#F8FAFC',
            100: '#F1F5F9',
            200: '#E2E8F0',
            300: '#CBD5E1',
            400: '#94A3B8',
            500: '#2C3E50',
            600: '#475569',
            700: '#334155',
            800: '#1E293B',
            900: '#0F172A',
          },
          cream: {
            DEFAULT: '#FFF5E1',
            50: '#FFFEF7',
            100: '#FFFCEB',
            200: '#FFF9D6',
            300: '#FFF5E1',
            400: '#FFF0C4',
            500: '#FFEBA7',
            600: '#FFE68A',
            700: '#FFE06D',
            800: '#FFDB50',
            900: '#FFD633',
          },
        },
      },

      // Spacing extensions
      spacing: {
        '18': '4.5rem',
        '22': '5.5rem',
        '26': '6.5rem',
        '30': '7.5rem',
        '34': '8.5rem',
        '38': '9.5rem',
        '42': '10.5rem',
        '46': '11.5rem',
        '50': '12.5rem',
        '54': '13.5rem',
        '58': '14.5rem',
        '62': '15.5rem',
        '66': '16.5rem',
        '70': '17.5rem',
        '74': '18.5rem',
        '78': '19.5rem',
        '82': '20.5rem',
        '86': '21.5rem',
        '90': '22.5rem',
        '94': '23.5rem',
        '98': '24.5rem',
      },

      // Box shadows
      boxShadow: {
        'brand-sm': '0 2px 8px rgba(255, 107, 107, 0.1)',
        'brand': '0 4px 20px rgba(255, 107, 107, 0.2)',
        'brand-lg': '0 10px 40px rgba(255, 107, 107, 0.3)',
        'ocean-sm': '0 2px 8px rgba(78, 205, 196, 0.1)',
        'ocean': '0 4px 20px rgba(78, 205, 196, 0.2)',
        'ocean-lg': '0 10px 40px rgba(78, 205, 196, 0.3)',
        'elevated': '0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04)',
      },

      // Border radius
      borderRadius: {
        '4xl': '2rem',
        '5xl': '2.5rem',
        '6xl': '3rem',
      },

      // Animations (from animation config above)
      animation: {
        'fade-in': 'fadeIn 0.5s ease-out',
        'fade-out': 'fadeOut 0.3s ease-in',
        'slide-up': 'slideUp 0.4s ease-out',
        'slide-down': 'slideDown 0.4s ease-out',
        'slide-left': 'slideLeft 0.4s ease-out',
        'slide-right': 'slideRight 0.4s ease-out',
        'scale-in': 'scaleIn 0.3s ease-out',
        'scale-out': 'scaleOut 0.2s ease-in',
        'bounce-subtle': 'bounceSubtle 1s ease-in-out infinite',
        'pulse-slow': 'pulse 3s cubic-bezier(0.4, 0, 0.6, 1) infinite',
        'pulse-fast': 'pulse 1s cubic-bezier(0.4, 0, 0.6, 1) infinite',
        'spin-slow': 'spin 3s linear infinite',
        'spin-fast': 'spin 0.5s linear infinite',
      },

      keyframes: {
        fadeIn: {
          '0%': { opacity: '0' },
          '100%': { opacity: '1' },
        },
        fadeOut: {
          '0%': { opacity: '1' },
          '100%': { opacity: '0' },
        },
        slideUp: {
          '0%': { transform: 'translateY(20px)', opacity: '0' },
          '100%': { transform: 'translateY(0)', opacity: '1' },
        },
        slideDown: {
          '0%': { transform: 'translateY(-20px)', opacity: '0' },
          '100%': { transform: 'translateY(0)', opacity: '1' },
        },
        slideLeft: {
          '0%': { transform: 'translateX(20px)', opacity: '0' },
          '100%': { transform: 'translateX(0)', opacity: '1' },
        },
        slideRight: {
          '0%': { transform: 'translateX(-20px)', opacity: '0' },
          '100%': { transform: 'translateX(0)', opacity: '1' },
        },
        scaleIn: {
          '0%': { transform: 'scale(0.9)', opacity: '0' },
          '100%': { transform: 'scale(1)', opacity: '1' },
        },
        scaleOut: {
          '0%': { transform: 'scale(1)', opacity: '1' },
          '100%': { transform: 'scale(0.9)', opacity: '0' },
        },
        bounceSubtle: {
          '0%, 100%': { transform: 'translateY(0)' },
          '50%': { transform: 'translateY(-5px)' },
        },
      },

      // Transition durations
      transitionDuration: {
        '400': '400ms',
        '600': '600ms',
        '800': '800ms',
        '900': '900ms',
      },
    },
  },
};
```

</tailwind_config_template>

### 6. Generate Nuxt UI Theme Customization

<thinking>
Create app.config.ts with global Nuxt UI customizations.
</thinking>

#### Nuxt UI Config:

<nuxt_ui_config>

```typescript
// app.config.ts
export default defineAppConfig({
  ui: {
    // Primary color (used by Nuxt UI components)
    primary: 'brand-coral',
    secondary: 'brand-ocean',
    gray: 'neutral',

    // Global component customization
    button: {
      default: {
        size: 'md',
        color: 'primary',
        variant: 'solid',
      },
      rounded: 'rounded-lg',
      font: 'font-heading tracking-wide',
    },

    card: {
      background: 'bg-white dark:bg-brand-midnight-800',
      rounded: 'rounded-2xl',
      shadow: 'shadow-lg',
      ring: 'ring-1 ring-gray-200 dark:ring-gray-700',
    },

    input: {
      rounded: 'rounded-lg',
      padding: {
        sm: 'px-4 py-2',
        md: 'px-4 py-3',
        lg: 'px-6 py-4',
      },
    },

    modal: {
      rounded: 'rounded-2xl',
      shadow: 'shadow-2xl',
      background: 'bg-white dark:bg-brand-midnight-800',
    },

    // Notification settings
    notifications: {
      position: 'top-right',
    },
  },
});
```

</nuxt_ui_config>

### 7. Update Font Loading

<thinking>
Configure font loading in nuxt.config.ts (Google Fonts or local fonts).
</thinking>

#### Font Loading Config:

<font_loading>

```typescript
// nuxt.config.ts
export default defineNuxtConfig({
  // ... other config

  // Option 1: Google Fonts (recommended for quick setup)
  googleFonts: {
    families: {
      'Space Grotesk': [400, 500, 600, 700],
      'Archivo Black': [400],
      'JetBrains Mono': [400, 500, 600, 700],
    },
    display: 'swap',  // Prevent FOIT (Flash of Invisible Text)
    preload: true,
  },

  // Option 2: Local fonts (better performance)
  css: ['~/assets/fonts/fonts.css'],

  // ... other config
});
```

```css
/* assets/fonts/fonts.css (if using local fonts) */
@font-face {
  font-family: 'Space Grotesk';
  src: url('/fonts/SpaceGrotesk-Variable.woff2') format('woff2-variations');
  font-weight: 300 700;
  font-display: swap;
}

@font-face {
  font-family: 'Archivo Black';
  src: url('/fonts/ArchivoBlack-Regular.woff2') format('woff2');
  font-weight: 400;
  font-display: swap;
}

@font-face {
  font-family: 'JetBrains Mono';
  src: url('/fonts/JetBrainsMono-Variable.woff2') format('woff2-variations');
  font-weight: 400 700;
  font-display: swap;
}
```

</font_loading>

## Output Format

<output_format>

```
✅ Custom Theme Generated

📁 Files Created/Updated:
- tailwind.config.ts (complete theme configuration)
- app.config.ts (Nuxt UI global customization)
- nuxt.config.ts (font loading configuration)
- assets/fonts/fonts.css (if using local fonts)

🎨 Theme Summary:

**Color Palette**: Coral Ocean
- Primary: Coral (#FF6B6B) - Warm, energetic
- Secondary: Ocean (#4ECDC4) - Calm, trustworthy
- Accent: Sunset (#FFE66D) - Bright, attention-grabbing
- Neutral: Midnight (#2C3E50) - Professional, elegant
- Background: Cream (#FFF5E1) - Soft, inviting

**Typography**: Modern
- Sans: Space Grotesk (body text, UI elements)
- Heading: Archivo Black (headings, impact text)
- Mono: JetBrains Mono (code, technical content)

**Animations**: Rich
- 15 custom animation presets
- Performant (GPU-accelerated properties only)
- Respects prefers-reduced-motion

**Accessibility**: WCAG 2.1 AA Compliant
✅ All color combinations meet 4.5:1 contrast ratio
✅ Focus states on all interactive elements
✅ Reduced motion support built-in

---

📖 Usage Examples:

**Typography**:
```vue
<h1 class="font-heading text-6xl text-brand-midnight">
  Heading
</h1>

<p class="font-sans text-lg text-gray-700">
  Body text
</p>

<code class="font-mono text-sm text-brand-coral-600">
  Code snippet
</code>
```

**Colors**:
```vue
<div class="bg-brand-coral text-white">
  Primary action
</div>

<div class="bg-brand-ocean text-white">
  Secondary action
</div>

<div class="bg-gradient-to-br from-brand-coral via-brand-ocean to-brand-sunset">
  Gradient background
</div>
```

**Animations**:
```vue
<div class="animate-slide-up">
  Slides up on mount
</div>

<button class="transition-all hover:scale-105 hover:shadow-brand-lg">
  Animated button
</button>

<div class="animate-pulse-slow">
  Subtle pulse
</div>
```

**Nuxt UI with Theme**:
```vue
<!-- Automatically uses theme colors -->
<UButton color="primary">
  Uses brand-coral
</UButton>

<UCard class="shadow-brand">
  Uses theme shadows
</UCard>
```

---

🔍 Next Steps:
1. ✅ Review `tailwind.config.ts` for customizations
2. ✅ Test theme with `/es-component button TestButton`
3. ✅ Run `/es-design-review` to validate distinctiveness
4. ✅ Update existing components to use new theme
5. ✅ Test dark mode support
6. ✅ Verify WCAG contrast ratios

📊 Distinctiveness Improvement:
- Before: 35/100 (Generic Inter + Purple)
- After: 90/100 (Distinctive brand theme)

Your project now has a distinctive visual identity! 🎨
```

</output_format>

## Success Criteria

✅ Theme generated successfully when:
- `tailwind.config.ts` has custom fonts (not Inter/Roboto)
- Custom color palette defined (not default purple)
- 15+ animation presets created
- All colors meet WCAG 2.1 AA contrast requirements
- Fonts configured in `nuxt.config.ts`
- Nuxt UI customization in `app.config.ts`
- Design system composable updated

## Post-Generation Actions

After generating theme:
1. **Test theme**: Create test component with `/es-component`
2. **Validate design**: Run `/es-design-review`
3. **Check accessibility**: Verify contrast ratios
4. **Update components**: Apply theme to existing components
5. **Document**: Add theme documentation to project

## Notes

- Theme replaces generic patterns (Inter, purple) with distinctive alternatives
- All colors are contrast-validated for accessibility
- Animations respect `prefers-reduced-motion`
- Theme is fully customizable after generation
- Works seamlessly with Nuxt UI components
