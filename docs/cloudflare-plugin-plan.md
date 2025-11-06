# Claude Code Plugin Inspired by vibesdk's AI Tuning

This plan outlines the creation of a Claude Code plugin based on the AI-tuning techniques (prompts, personas, and guardrails) found in the vibesdk.

## 1. Core Principle: Persona and Constraints

The vibesdk's primary technique is to constrain the LLM's problem-space by setting a specific persona, environment, and set of "do-nots." Our plugin will adopt this strategy.

| vibesdk Technique (Inspiration) | Claude Plugin Feature (Implementation) |
|--------------------------------|----------------------------------------|
| Persona: "Senior Software Architect... at Cloudflare" (blueprint.ts) | Subagent: @cloudflare-architect |
| Environment: "built on serverless Cloudflare workers..." (blueprint.ts) | Hook: wrangler.toml Context Injection |
| Guardrail: "DO NOT Propose changes to wrangler.toml..." | Hook: Config File Protection |
| Constraint: "Respect and work with existing worker bindings" (prompts.ts) | MCP Server: Binding Context Provider |
| Task-Specific Prompting: (e.g., planning, code generation) | Slash Commands: /cf-plan, /cf-worker |

## 2. Detailed Feature Implementation Plan

### Subagents: For Task-Specific Personas

#### @cloudflare-architect (Planning Subagent)

**Inspiration**: The "Senior Software Architect and Product Manager at Cloudflare" persona from blueprint.ts.

**Purpose**: To help users plan new features or entire applications on the Cloudflare stack without writing code.

**System Prompt**:
```
You are a Senior Software Architect at Cloudflare. Your task is to help the user plan a new feature.

Your Environment: The project MUST be built on serverless Cloudflare Workers, Durable Objects, and supporting technologies (like KV, R2, Queues, D1).

Your Task:
- Ask clarifying questions to understand the user's goals.
- Provide a high-level plan, identifying the necessary Cloudflare resources (e.g., "You will need one Worker, a KV namespace for caching, and an R2 bucket for storage.").
- Define the main worker/Durable Object files needed and their core responsibilities.

Guardrail: You MUST NOT write implementation code. Your deliverable is a plan, not a codebase.
```

### Hooks: For Proactive Guardrails and Context

#### Hook 1: Config File Protection (Post-Generation Guardrail)

**Inspiration**: "Absolutely DO NOT Propose changes to wrangler.toml..."

**Trigger**: Runs after Claude generates any response.

**Logic**:
- The hook scans the generated response text.
- It checks for diffs, code blocks, or explicit text suggesting modifications to wrangler.toml or package.json (specifically, adding/changing [kv_namespaces], [r2_buckets], or other core bindings).

**Action**: If a modification is detected, the plugin will block the change from being automatically applied and inject a warning into the chat:
```
Warning: The AI suggested changes to wrangler.toml. This is a protected configuration file. Please review and apply these changes manually if you are sure they are correct.
```

#### Hook 2: wrangler.toml Context Injection (Pre-Generation Context)

**Inspiration**: "This is a Cloudflare Workers & Durable Objects project."

**Trigger**: Runs before any user prompt is sent to Claude, if a wrangler.toml file is present in the workspace.

**Logic**:
- This hook silently prepends a short system message to the user's prompt.

**Injected Text**:
```
Context: This is a Cloudflare Workers project. All code you generate must be compatible with the Workers runtime (e.g., use fetch, not Node.js APIs like fs). The user's configuration is in wrangler.toml.
```

### MCP Servers: For Dynamic, Real-time Context

#### MCP Server: Binding Context Provider

**Inspiration**: "Respect and work with existing worker bindings."

**Purpose**: To make Claude "aware" of the user's actual configured bindings.

**Logic**:
- The MCP server is given read-access to the wrangler.toml file in the user's workspace.
- When triggered (e.g., by the @cloudflare-architect subagent or the /cf-worker command), it reads and parses the wrangler.toml file.
- It extracts a list of all defined bindings (e.g., kv_namespaces, r2_buckets, durable_objects, services).

**Action**: This list is passed to Claude as part of the prompt context.

**Example Context**:
```
The user has the following bindings available. Ensure your code uses these exact names in the env object:
- KV Namespaces: USER_DATA, CACHE
- R2 Buckets: UPLOADS
- Durable Objects: Counter
```

### Slash Commands: For Frequent, Tuned Operations

#### /cf-plan (Scaffolding Command)

**Purpose**: A shortcut to invoke the @cloudflare-architect subagent.

**Action**: Simply an alias that triggers the @cloudflare-architect with the user's prompt. (e.g., /cf-plan build a URL shortener).

#### /cf-worker (Code Generation Command)

**Purpose**: To generate a new, compliant Worker script that uses existing bindings.

**Action**:
- The command triggers the MCP Server to fetch all available bindings.
- It then prompts Claude with a highly specific, tuned prompt:

```
You are a Cloudflare Workers expert. The user wants to create a new Worker.

Task: Generate the index.ts (or index.js) for a Worker that accomplishes the user's goal: [User's prompt text here].

Environment: You MUST use the following available bindings from the env object.
[List of bindings from MCP Server]

Guardrails:
- Your code must be a single, complete file with a default export containing a fetch handler.
- Do not use any Node.js-specific APIs.
- Do not suggest any changes to wrangler.toml.
```

## 3. Improved Prompt for This Request

Here is a revised version of your original prompt, which you can use to request this kind of analysis in the future.

```
I want to create a Claude Code plugin inspired by the AI-tuning techniques used in the AI-agent vibesdk (e.g., partykit/vibesdk).

Please analyze the prompting strategies and guardrails this SDK uses internally (e.g., in files like blueprint.ts and prompts.ts) to tune its LLM for the Cloudflare ecosystem.

Pay particular attention to:
- Persona Tuning: (e.g., "act as a Senior Software Architect at Cloudflare")
- Environmental Constraints: (e.g., "built on serverless Cloudflare workers")
- Configuration Guardrails: (e.g., "Absolutely DO NOT Propose changes to wrangler.toml")
- Contextual Awareness: (e.g., "Respect and work with existing worker bindings")

Then, create a detailed plan that maps these AI-native techniques to the following Claude Code plugin features:
- Slash commands
- Subagents
- MCP servers
- Hooks

Save this output as a md file.
```
