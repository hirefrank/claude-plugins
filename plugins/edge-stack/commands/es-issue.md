---
description: Create well-structured GitHub issues following project conventions
---

# Create GitHub Issue

## Introduction

Transform feature descriptions, bug reports, or improvement ideas into well-structured markdown files issues that follow project conventions and best practices. This command provides flexible detail levels to match your needs.

## Feature Description

<feature_description> #$ARGUMENTS </feature_description>

## Main Tasks

### 1. Cloudflare Context & Binding Analysis

<thinking>
First, I need to understand the Cloudflare Workers project structure, available bindings, and existing patterns. This informs architectural decisions and implementation approaches.
</thinking>

**CRITICAL FIRST STEP**: Verify this is a Cloudflare Workers project:
- Check for `wrangler.toml` file
- If not found, warn user and ask if they want to create a new Workers project

Run these agents in parallel:

**Phase 1: Cloudflare-Specific Context (Priority)**

- Task binding-context-analyzer(feature_description)
  - Parse wrangler.toml for existing bindings (KV, R2, D1, DO)
  - Generate current Env interface
  - Identify available resources for reuse
  - Provide context to other agents

- Task cloudflare-architecture-strategist(feature_description)
  - Analyze Workers/DO/KV/R2 architecture patterns
  - Recommend storage choices based on feature requirements
  - Consider edge-first design principles

**Phase 2: General Research (Parallel)**

- Task repo-research-analyst(feature_description)
  - Research existing Workers patterns in codebase
  - Identify Cloudflare-specific conventions
  - Document Workers entry points and routing patterns

**Reference Collection:**

- [ ] Document all research findings with specific file paths (e.g., `src/index.ts:42`)
- [ ] List existing bindings from wrangler.toml with IDs and types
- [ ] Include URLs to Cloudflare documentation and best practices
- [ ] Create a reference list of similar Workers implementations or PRs
- [ ] Note any Cloudflare-specific conventions discovered in documentation
- [ ] Document user preferences from PREFERENCES.md (Tanstack Start, Hono, Vercel AI SDK)

### 2. Issue Planning & Structure

<thinking>
Think like a product manager - what would make this issue clear and actionable? Consider multiple perspectives
</thinking>

**Title & Categorization:**

- [ ] Draft clear, searchable issue title using conventional format (e.g., `feat:`, `fix:`, `docs:`)
- [ ] Identify appropriate labels from repository's label set (`gh label list`)
- [ ] Determine issue type: enhancement, bug, refactor

**Stakeholder Analysis:**

- [ ] Identify who will be affected by this issue (end users, developers, operations)
- [ ] Consider implementation complexity and required expertise

**Content Planning:**

- [ ] Choose appropriate detail level based on issue complexity and audience
- [ ] List all necessary sections for the chosen template
- [ ] Gather supporting materials (error logs, screenshots, design mockups)
- [ ] Prepare code examples or reproduction steps if applicable, name the mock filenames in the lists

### 3. Choose Implementation Detail Level

Select how comprehensive you want the issue to be:

#### 📄 MINIMAL (Quick Issue)

**Best for:** Simple bugs, small improvements, clear features

**Includes:**

- Problem statement or feature description
- Basic acceptance criteria
- Essential context only

**Structure:**

````markdown
[Brief problem/feature description]

## Acceptance Criteria

- [ ] Core requirement 1
- [ ] Core requirement 2

## Context

[Any critical information]

## MVP

### src/worker.ts

```typescript
export default {
  async fetch(request: Request, env: Env, ctx: ExecutionContext): Promise<Response> {
    // Minimal implementation
    return new Response('Hello World');
  }
};
```

### wrangler.toml

```toml
name = "feature-name"
main = "src/index.ts"
compatibility_date = "2025-09-15"  # Always use 2025-09-15 or later

# Example: KV namespace with remote binding
[[kv_namespaces]]
binding = "CACHE"
id = "your-kv-namespace-id"
remote = true  # Connect to real KV during development
```

## References

- Related issue: #[issue_number]
- Cloudflare Docs: [relevant_docs_url]
- Existing bindings: [from binding-context-analyzer]
````

#### 📋 MORE (Standard Issue)

**Best for:** Most features, complex bugs, team collaboration

**Includes everything from MINIMAL plus:**

- Detailed background and motivation
- Technical considerations
- Success metrics
- Dependencies and risks
- Basic implementation suggestions

**Structure:**

```markdown
## Overview

[Comprehensive description]

## Problem Statement / Motivation

[Why this matters]

## Proposed Solution

[High-level approach]

## Technical Considerations

- Architecture impacts
- Performance implications
- Security considerations

## Acceptance Criteria

- [ ] Detailed requirement 1
- [ ] Detailed requirement 2
- [ ] Testing requirements

## Success Metrics

[How we measure success]

## Dependencies & Risks

[What could block or complicate this]

## References & Research

- Similar implementations: [file_path:line_number]
- Best practices: [documentation_url]
- Related PRs: #[pr_number]
```

#### 📚 A LOT (Comprehensive Issue)

**Best for:** Major features, architectural changes, complex integrations

**Includes everything from MORE plus:**

- Detailed implementation plan with phases
- Alternative approaches considered
- Extensive technical specifications
- Resource requirements and timeline
- Future considerations and extensibility
- Risk mitigation strategies
- Documentation requirements

**Structure:**

```markdown
## Overview

[Executive summary]

## Problem Statement

[Detailed problem analysis]

## Proposed Solution

[Comprehensive solution design]

## Technical Approach

### Architecture

[Detailed technical design]

### Implementation Phases

#### Phase 1: [Foundation]

- Tasks and deliverables
- Success criteria
- Estimated effort

#### Phase 2: [Core Implementation]

- Tasks and deliverables
- Success criteria
- Estimated effort

#### Phase 3: [Polish & Optimization]

- Tasks and deliverables
- Success criteria
- Estimated effort

## Alternative Approaches Considered

[Other solutions evaluated and why rejected]

## Acceptance Criteria

### Functional Requirements

- [ ] Detailed functional criteria

### Non-Functional Requirements

- [ ] Performance targets
- [ ] Security requirements
- [ ] Accessibility standards

### Quality Gates

- [ ] Test coverage requirements
- [ ] Documentation completeness
- [ ] Code review approval

## Success Metrics

[Detailed KPIs and measurement methods]

## Dependencies & Prerequisites

[Detailed dependency analysis]

## Risk Analysis & Mitigation

[Comprehensive risk assessment]

## Resource Requirements

[Team, time, infrastructure needs]

## Future Considerations

[Extensibility and long-term vision]

## Documentation Plan

[What docs need updating]

## References & Research

### Internal References

- Architecture decisions: [file_path:line_number]
- Similar features: [file_path:line_number]
- Configuration: [file_path:line_number]

### External References

- Framework documentation: [url]
- Best practices guide: [url]
- Industry standards: [url]

### Related Work

- Previous PRs: #[pr_numbers]
- Related issues: #[issue_numbers]
- Design documents: [links]
```

### 4. Issue Creation & Formatting

<thinking>
Apply best practices for clarity and actionability, making the issue easy to scan and understand
</thinking>

**Content Formatting:**

- [ ] Use clear, descriptive headings with proper hierarchy (##, ###)
- [ ] Include code examples in triple backticks with language syntax highlighting
- [ ] Add screenshots/mockups if UI-related (drag & drop or use image hosting)
- [ ] Use task lists (- [ ]) for trackable items that can be checked off
- [ ] Add collapsible sections for lengthy logs or optional details using `<details>` tags
- [ ] Apply appropriate emoji for visual scanning (🐛 bug, ✨ feature, 📚 docs, ♻️ refactor)

**Cross-Referencing:**

- [ ] Link to related issues/PRs using #number format
- [ ] Reference specific commits with SHA hashes when relevant
- [ ] Link to code using GitHub's permalink feature (press 'y' for permanent link)
- [ ] Mention relevant team members with @username if needed
- [ ] Add links to external resources with descriptive text

**Code & Examples:**

```markdown
# Good example with syntax highlighting and line references

\`\`\`ruby

# app/services/user_service.rb:42

def process_user(user)

# Implementation here

end \`\`\`

# Collapsible error logs

<details>
<summary>Full error stacktrace</summary>

\`\`\` Error details here... \`\`\`

</details>
```

**AI-Era Considerations:**

- [ ] Account for accelerated development with AI pair programming
- [ ] Include prompts or instructions that worked well during research
- [ ] Note which AI tools were used for initial exploration (Claude, Copilot, etc.)
- [ ] Emphasize comprehensive testing given rapid implementation
- [ ] Document any AI-generated code that needs human review

### 5. Final Review & Submission

**Pre-submission Checklist:**

- [ ] Title is searchable and descriptive
- [ ] Labels accurately categorize the issue
- [ ] All template sections are complete
- [ ] Links and references are working
- [ ] Acceptance criteria are measurable
- [ ] Add names of files in pseudo code examples and todo lists
- [ ] Add an ERD mermaid diagram if applicable for new model changes

## Output Format

Present the complete issue content within `<github_issue>` tags, ready for GitHub CLI:

```bash
gh issue create --title "[TITLE]" --body "[CONTENT]" --label "[LABELS]"
```

## Thinking Approaches

- **Analytical:** Break down complex features into manageable components
- **User-Centric:** Consider end-user impact and experience
- **Technical:** Evaluate implementation complexity and architecture fit
- **Strategic:** Align with project goals and roadmap
