# MCP Usage Examples

Complete reference for using MCP servers in Cloudflare toolkit agents, commands, and SKILLs.

## Overview

The Cloudflare toolkit integrates with 4 MCP servers for real-time data and configuration:
- **cloudflare-docs**: Documentation, bindings, observability
- **nuxt-ui**: Component documentation
- **better-auth**: Authentication setup
- **polar**: Billing and subscriptions

## Polar MCP

### List Products

**Query**: `mcp.polar.listProducts()`

**Returns**:
```json
[
  {
    "id": "polar_prod_abc123",
    "name": "Pro Plan",
    "description": "Professional features",
    "prices": [
      {
        "id": "polar_price_xyz789",
        "amount": 2900,
        "currency": "USD",
        "interval": "month"
      }
    ]
  }
]
```

**Use Case**: Before implementing billing, check what products exist in user's Polar account

**Example**:
```typescript
// In polar-billing-specialist agent
const products = await mcp.polar.listProducts();

if (products.length === 0) {
  return "No products found. Create products at https://polar.sh/dashboard";
}

// Use real product IDs in generated code
const productId = products[0].id; // polar_prod_abc123
```

---

### Get Webhook Events

**Query**: `mcp.polar.getWebhookEvents()`

**Returns**:
```json
[
  "checkout.completed",
  "subscription.created",
  "subscription.updated",
  "subscription.canceled",
  "subscription.past_due",
  "customer.created",
  "customer.updated"
]
```

**Use Case**: Ensure webhook handler covers all critical events

**Example**:
```typescript
// In /cf-billing-setup command
const events = await mcp.polar.getWebhookEvents();

// Generate switch statement with all events
const webhookHandler = generateWebhookHandler(events);
```

---

### Verify Setup

**Query**: `mcp.polar.verifySetup()`

**Returns**:
```json
{
  "status": "valid",
  "account": {
    "email": "user@example.com",
    "productsCount": 3
  },
  "issues": []
}
```

**Use Case**: Pre-deployment validation

**Example**:
```typescript
// In /validate command
const validation = await mcp.polar.verifySetup();

if (validation.status !== 'valid') {
  console.error('Polar setup invalid:', validation.issues);
}
```

---

## better-auth MCP

### List Providers

**Query**: `mcp.betterAuth.listProviders()`

**Returns**:
```json
[
  "google",
  "github",
  "apple",
  "facebook",
  "discord",
  "twitter"
]
```

**Use Case**: Show available OAuth providers before configuration

**Example**:
```typescript
// In /cf-auth-setup command
const providers = await mcp.betterAuth.listProviders();

console.log("Available OAuth providers:");
providers.forEach(p => console.log(`- ${p}`));
```

---

### Get Provider Setup

**Query**: `mcp.betterAuth.getProviderSetup('google')`

**Returns**:
```json
{
  "provider": "google",
  "requiredCredentials": ["clientId", "clientSecret"],
  "scopes": ["openid", "email", "profile"],
  "redirectUri": "http://localhost:3000/auth/callback/google",
  "setupInstructions": "1. Go to Google Cloud Console..."
}
```

**Use Case**: Get exact requirements for OAuth provider configuration

**Example**:
```typescript
// In better-auth-specialist agent
const googleSetup = await mcp.betterAuth.getProviderSetup('google');

// Use real scopes from MCP (not guessed)
const config = {
  google: {
    clientId: process.env.GOOGLE_CLIENT_ID,
    clientSecret: process.env.GOOGLE_CLIENT_SECRET,
    scopes: googleSetup.scopes // ['openid', 'email', 'profile']
  }
};
```

---

### Get Passkey Setup

**Query**: `mcp.betterAuth.getPasskeySetup()`

**Returns**:
```json
{
  "implementation": "...",
  "browserCompatibility": ["Chrome", "Safari", "Firefox"],
  "securityRequirements": ["HTTPS", "valid domain"],
  "exampleCode": "..."
}
```

**Use Case**: Get passkey implementation guide

---

### Verify Setup

**Query**: `mcp.betterAuth.verifySetup()`

**Returns**:
```json
{
  "status": "valid",
  "providers": ["google", "github"],
  "issues": []
}
```

**Use Case**: Pre-deployment auth validation

---

## Nuxt UI MCP

### List Components

**Query**: `mcp.nuxtUI.listComponents()`

**Returns**:
```json
["UButton", "UCard", "UInput", "UModal", "UTable", ...]
```

**Use Case**: Show available components before scaffolding

**Example**:
```typescript
// In /cf-component command
const components = await mcp.nuxtUI.listComponents();

if (!components.includes(requestedComponent)) {
  return `Component ${requestedComponent} not found. Available: ${components.join(', ')}`;
}
```

---

### Get Component Props

**Query**: `mcp.nuxtUI.getComponent('UButton')`

**Returns**:
```json
{
  "name": "UButton",
  "props": {
    "color": ["primary", "secondary", "success", "error"],
    "size": ["xs", "sm", "md", "lg", "xl"],
    "variant": ["solid", "outline", "soft", "ghost", "link"],
    "icon": "string",
    "loading": "boolean",
    "disabled": "boolean",
    "ui": "object"
  },
  "slots": ["default", "leading", "trailing"]
}
```

**Use Case**: Prevent prop hallucination by validating against real API

**Example**:
```typescript
// In nuxt-ui-architect agent
const button = await mcp.nuxtUI.getComponent('UButton');

// Validate user's prop usage
if (userProps.includes('magic-prop')) {
  return `Invalid prop 'magic-prop'. Valid props: ${Object.keys(button.props).join(', ')}`;
}
```

---

## Cloudflare Docs MCP

### Search Documentation

**Query**: `mcp.cloudflare.searchDocs('KV namespace')`

**Returns**: Relevant documentation snippets

**Use Case**: Get latest Cloudflare API documentation

---

### Get Binding Info

**Query**: `mcp.cloudflare.getBinding('KV')`

**Returns**: KV binding configuration and usage examples

**Use Case**: Validate binding configuration in wrangler.toml

---

## Common Workflows

### Workflow 1: Setting Up Billing

```typescript
// Step 1: Check Polar products
const products = await mcp.polar.listProducts();

if (products.length === 0) {
  console.log("Create products at https://polar.sh/dashboard");
  return;
}

// Step 2: Get webhook events
const events = await mcp.polar.getWebhookEvents();

// Step 3: Generate webhook handler with real events
const handler = generateWebhookHandler(events);

// Step 4: Validate setup
const validation = await mcp.polar.verifySetup();
```

### Workflow 2: Configuring OAuth

```typescript
// Step 1: List available providers
const providers = await mcp.betterAuth.listProviders();

// Step 2: Get setup for selected provider
const googleSetup = await mcp.betterAuth.getProviderSetup('google');

// Step 3: Generate config with real scopes
const config = {
  google: {
    clientId: env.GOOGLE_CLIENT_ID,
    clientSecret: env.GOOGLE_CLIENT_SECRET,
    scopes: googleSetup.scopes // Real scopes from MCP
  }
};

// Step 4: Validate
const validation = await mcp.betterAuth.verifySetup();
```

### Workflow 3: Component Scaffolding

```typescript
// Step 1: List components
const components = await mcp.nuxtUI.listComponents();

// Step 2: Get component API
const button = await mcp.nuxtUI.getComponent('UButton');

// Step 3: Generate with valid props
const code = generateComponent({
  name: 'PrimaryButton',
  props: button.props,
  customization: { color: 'primary', size: 'lg' }
});
```

---

## Best Practices

1. **Always Query MCP First**: Don't guess product IDs, props, or scopes
2. **Validate Before Generation**: Use MCP to check configuration validity
3. **Use Real Data**: Generate code with actual product/component data
4. **Handle Errors**: MCP queries can fail, provide fallbacks
5. **Cache Appropriately**: Some queries (like listProducts) can be cached briefly

---

## Error Handling

```typescript
// Example: Graceful degradation
let products;
try {
  products = await mcp.polar.listProducts();
} catch (err) {
  console.warn('Polar MCP unavailable, using fallback');
  products = []; // Continue with empty array
}

if (products.length === 0) {
  // Guide user to create products manually
}
```

---

## Integration Points

- **Agents**: Use MCP for real-time data in recommendations
- **Commands**: Use MCP for validation and code generation
- **SKILLs**: Use MCP for autonomous validation checks
- **/validate**: Aggregate MCP validation results
- **/cf-deploy**: Pre-flight MCP checks

---

## Notes

- MCP servers are optional but highly recommended
- Provide graceful fallbacks when MCP unavailable
- MCP data is always current (not cached)
- Use MCP to prevent hallucination of APIs, props, or IDs
