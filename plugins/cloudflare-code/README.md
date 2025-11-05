# Cloudflare Code Plugin

AI-tuned assistant for Cloudflare Workers development with specialized personas and guardrails. Inspired by the vibesdk's AI-tuning techniques.

## Overview

This plugin transforms Claude Code into a Cloudflare Workers expert by applying AI-native constraints: specific personas, environmental awareness, and proactive guardrails. It helps you plan, build, and maintain Cloudflare Workers applications with confidence.

**Key Principle**: Instead of generic AI assistance, this plugin constrains Claude to think and respond like a Cloudflare engineer, ensuring all suggestions are Workers-compatible and follow best practices.

## Features

### AI Tuning Techniques

This plugin implements four core AI-tuning strategies inspired by vibesdk:

1. **Persona Tuning**: Claude acts as a "Senior Software Architect at Cloudflare"
2. **Environmental Constraints**: All code must be Workers-compatible (no Node.js APIs)
3. **Configuration Guardrails**: Protects critical files like wrangler.toml
4. **Contextual Awareness**: Understands and respects existing project bindings

### What's Included

- **Slash Commands**: Quick access to tuned workflows
- **Smart Context**: Automatic detection of wrangler.toml bindings
- **Runtime Safety**: Prevents Node.js API usage in Workers code
- **Best Practices**: Enforces Cloudflare Workers patterns

## Prerequisites

- **Claude Code** - [Installation instructions](https://docs.anthropic.com/en/docs/claude-code)
- **Cloudflare Account** - For deploying Workers (optional for planning)
- **Wrangler CLI** - [Installation guide](https://developers.cloudflare.com/workers/wrangler/install-and-update/)

## Installation

```shell
# Add the marketplace (if not already added)
/plugin marketplace add hirefrank/hirefrank-marketplace

# Install this plugin
/plugin install cloudflare-code

# Restart Claude Code to activate
```

## Commands

### `/cf-plan` - Architecture Planning

Plan Cloudflare Workers projects with expert architectural guidance.

**Purpose**: Get a comprehensive project plan without writing any code. Perfect for:
- Starting new projects
- Adding features to existing apps
- Architectural reviews
- Understanding what Cloudflare services you need

**Example Usage:**
```
/cf-plan build a URL shortener with analytics
/cf-plan add real-time collaboration to my document editor
/cf-plan design a serverless API for user authentication
```

**What You Get:**
- Project architecture overview
- Required Cloudflare services (Workers, KV, R2, Durable Objects, etc.)
- File structure recommendations
- Bindings configuration guide
- Step-by-step implementation roadmap
- Testing strategy

**Guardrails:**
- ✅ Provides architectural guidance
- ✅ Suggests Cloudflare services
- ✅ Defines file structure
- ❌ Does NOT write implementation code
- ❌ Does NOT modify wrangler.toml

### `/cf-worker` - Code Generation

Generate production-ready Workers code that uses your existing bindings.

**Purpose**: Create Workers code that:
- Automatically detects your wrangler.toml bindings
- Uses only Workers-compatible APIs
- Follows TypeScript best practices
- Includes proper error handling

**Example Usage:**
```
/cf-worker create an API endpoint for user authentication
/cf-worker build a file upload handler using R2
/cf-worker implement a rate limiter with Durable Objects
```

**What You Get:**
- Complete Worker implementation
- TypeScript type definitions
- Binding usage examples
- Local testing instructions
- Deployment guidance

**Guardrails:**
- ✅ Uses existing wrangler.toml bindings
- ✅ Workers runtime APIs only
- ✅ Proper TypeScript types
- ✅ Error handling included
- ❌ NO Node.js APIs (fs, path, etc.)
- ❌ NO wrangler.toml modifications suggested

## How It Works

### 1. Context Detection

When you use `/cf-worker`, the plugin automatically:
1. Searches for `wrangler.toml` in your workspace
2. Parses all configured bindings (KV, R2, D1, Durable Objects, etc.)
3. Provides this context to Claude for code generation

**Example Context:**
```
Available Bindings:
- KV Namespaces: USER_DATA, CACHE
- R2 Buckets: UPLOADS
- Durable Objects: Counter
- D1 Databases: DB
```

### 2. Persona-Driven Responses

Both commands apply specific personas:

**`/cf-plan`**: Senior Software Architect
- Thinks about system design
- Considers scalability and edge optimization
- Recommends appropriate Cloudflare services
- Provides implementation roadmaps

**`/cf-worker`**: Cloudflare Workers Expert
- Generates runtime-compatible code
- Uses proper binding patterns
- Includes error handling
- Follows TypeScript best practices

### 3. Built-in Guardrails

**Configuration Protection:**
- Never suggests direct edits to wrangler.toml
- Shows what bindings are needed instead
- Lets you make configuration changes manually

**Runtime Safety:**
- Only suggests Workers-compatible APIs
- No Node.js-specific code (`fs`, `path`, `process`, etc.)
- No synchronous I/O operations
- Edge-optimized patterns

## Quick Start Guide

### Planning a New Project

```shell
# Start with planning
/cf-plan build a markdown-to-HTML converter API

# Review the architecture
# Follow the implementation roadmap
# Configure bindings in wrangler.toml as suggested

# Generate the Worker code
/cf-worker implement the markdown converter API
```

### Adding to an Existing Project

```shell
# Navigate to your Workers project
cd my-workers-project

# Generate new functionality
/cf-worker add rate limiting to the API using Durable Objects

# The plugin automatically detects your existing wrangler.toml bindings
# and generates code that uses them
```

## Example Workflows

### Building a URL Shortener

```shell
# 1. Plan the architecture
/cf-plan build a URL shortener with click tracking

# 2. Set up bindings in wrangler.toml based on the plan
# (e.g., KV for URL mappings, D1 for analytics)

# 3. Generate the Worker code
/cf-worker create the URL shortener API

# 4. Test locally
npx wrangler dev

# 5. Deploy
npx wrangler deploy
```

### Adding Real-time Features

```shell
# 1. Plan the feature
/cf-plan add real-time presence tracking to my app

# 2. Generate the Durable Object
/cf-worker create a presence tracking Durable Object

# 3. Integrate with your existing Worker
/cf-worker update the main Worker to use the presence tracker
```

## Best Practices

### When to Use `/cf-plan`

Use for:
- Starting new projects from scratch
- Major architectural decisions
- Understanding what services you need
- Planning before coding

### When to Use `/cf-worker`

Use for:
- Generating new Worker files
- Creating Durable Objects
- Implementing specific features
- Learning Workers patterns

### Working with Bindings

1. **Let the plugin detect them**: The plugin reads wrangler.toml automatically
2. **Configure manually**: Always update wrangler.toml yourself
3. **Use the suggestions**: The plugin shows what bindings are needed
4. **Test locally**: Use `wrangler dev` to test before deploying

## Supported Cloudflare Services

The plugin provides guidance for:

- **Workers**: Serverless JavaScript/TypeScript execution
- **Durable Objects**: Stateful serverless objects
- **KV**: Key-value storage
- **R2**: Object storage (S3-compatible)
- **D1**: SQLite database at the edge
- **Queues**: Message queues
- **Vectorize**: Vector database
- **AI**: Inference API
- **Cron Triggers**: Scheduled jobs
- **Service Bindings**: Worker-to-Worker communication

## Troubleshooting

### Plugin Not Detecting wrangler.toml

Ensure:
- The file is named exactly `wrangler.toml`
- It's in your project root or a subdirectory
- The file is valid TOML format

### Generated Code Uses Wrong APIs

The plugin enforces Workers runtime APIs. If you need specific functionality:
- Ask for Workers-compatible alternatives
- Check [Cloudflare Workers documentation](https://developers.cloudflare.com/workers/)
- Use the `/cf-plan` command for architectural guidance

### Bindings Not Working

1. Verify bindings are configured in wrangler.toml
2. Check binding names match the code
3. Run `wrangler dev` to test locally
4. Use `wrangler types` to generate TypeScript definitions

## Technical Details

### AI Tuning Implementation

This plugin uses the vibesdk-inspired approach:

| Technique | Implementation | Benefit |
|-----------|----------------|---------|
| Persona Tuning | Specialized system prompts | Role-specific expertise |
| Environmental Constraints | Runtime API enforcement | Prevents incompatible code |
| Configuration Guardrails | Protected file patterns | Maintains config integrity |
| Contextual Awareness | wrangler.toml parsing | Uses actual project setup |

### Command Architecture

Both commands use:
- **Markdown-based prompts**: Easy to read and modify
- **YAML frontmatter**: Metadata for Claude Code
- **Template variables**: `{{PROMPT}}` for user input
- **Structured instructions**: Step-by-step guidance

### File Structure

```
cloudflare-code/
├── .claude-plugin/
│   └── plugin.json          # Plugin metadata
├── commands/
│   ├── cf-plan.md          # Planning command
│   └── cf-worker.md        # Code generation command
└── README.md               # This file
```

## Comparison to vibesdk

This plugin adapts vibesdk's AI-tuning concepts to Claude Code:

**vibesdk Approach:**
- Embeds prompts in SDK code (TypeScript)
- Used programmatically via API
- Focused on Cloudflare ecosystem

**This Plugin:**
- Uses Claude Code's native features (slash commands)
- Interactive CLI experience
- Same core principles (personas, guardrails, context)

See [docs/cloudflare-plugin-plan.md](../../docs/cloudflare-plugin-plan.md) for the full design rationale.

## Examples

### Simple Worker

```typescript
/cf-worker create a Hello World worker

// Generates:
export default {
  async fetch(request: Request, env: Env, ctx: ExecutionContext): Promise<Response> {
    return new Response('Hello World!', {
      headers: { 'Content-Type': 'text/plain' }
    });
  }
}
```

### KV-backed API

```typescript
/cf-worker create a key-value storage API

// Automatically detects KV binding from wrangler.toml
// Generates CRUD operations using env.YOUR_KV_NAMESPACE
```

### Durable Object

```typescript
/cf-worker create a counter Durable Object

// Generates both:
// 1. Durable Object class with state
// 2. Worker that communicates with it
```

## Resources

- [Cloudflare Workers Docs](https://developers.cloudflare.com/workers/)
- [Wrangler CLI](https://developers.cloudflare.com/workers/wrangler/)
- [Workers Runtime APIs](https://developers.cloudflare.com/workers/runtime-apis/)
- [vibesdk Project](https://github.com/partykit/vibesdk)

## Contributing

Issues and suggestions for this plugin:
- [Plugin Issues](https://github.com/hirefrank/hirefrank-marketplace/issues?q=label:cloudflare-code)
- [Feature Requests](https://github.com/hirefrank/hirefrank-marketplace/discussions)

## Version History

- **v1.0.0**: Initial release with `/cf-plan` and `/cf-worker` commands

## License

MIT License - see [LICENSE](../../LICENSE) for details.
