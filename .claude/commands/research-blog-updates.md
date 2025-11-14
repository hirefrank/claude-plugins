---
description: Fetches latest Claude and Anthropic Engineering blog posts, analyzes them for relevant learnings, and creates implementation plans for plugin updates
---

# Research Blog Updates Command

## Purpose

Monitors Anthropic's official blogs for relevant updates and determines how they should influence the hirefrank marketplace plugins.

**Blogs Monitored**:
- https://www.claude.com/blog
- https://www.anthropic.com/engineering

**Focus Areas**:
- MCP (Model Context Protocol) updates
- Claude Code features and best practices
- Cloudflare Workers integration improvements
- React/Tanstack Start patterns
- Testing strategies (Playwright, E2E)
- Authentication/authorization patterns
- Email/notification best practices

---

## Usage

```bash
/research-blog-updates [--since YYYY-MM-DD] [--topics topic1,topic2]
```

### Arguments

- `[--since YYYY-MM-DD]` - Optional. Only analyze posts since this date. Default: last 30 days.
- `[--topics topic1,topic2]` - Optional. Filter for specific topics (mcp, cloudflare, react, testing, auth, email).

### Examples

```bash
# Analyze all posts from last 30 days
/research-blog-updates

# Analyze posts since specific date
/research-blog-updates --since 2025-01-01

# Filter for MCP and Cloudflare topics
/research-blog-updates --topics mcp,cloudflare

# Analyze last 90 days for testing updates
/research-blog-updates --since 2024-10-01 --topics testing
```

---

## Workflow

### Phase 0: Load State

**Load previous run state to prevent duplicate analysis**:

```typescript
import { readFileSync, existsSync } from 'fs';

const STATE_FILE = 'plugins/edge-stack/.logs/blog-updates.json';

interface BlogUpdateState {
  lastRun: string | null;
  lastReviewDate: string | null;
  nextScheduledRun: string | null;
  totalRuns: number;
  postsAnalyzed: Record<string, number>;
  lastProcessedPosts: string[];
}

let state: BlogUpdateState;
let sinceDate: string;

// Read state
if (existsSync(STATE_FILE)) {
  state = JSON.parse(readFileSync(STATE_FILE, 'utf-8'));

  console.log(`📊 Last run: ${state.lastRun}`);
  console.log(`📅 Last review date: ${state.lastReviewDate}`);
  console.log(`📝 Last processed: ${state.lastProcessedPosts.length} posts`);

  sinceDate = state.lastReviewDate || getDateDaysAgo(30);
} else {
  // First run - initialize empty state
  state = {
    lastRun: null,
    lastReviewDate: null,
    nextScheduledRun: null,
    totalRuns: 0,
    postsAnalyzed: {},
    lastProcessedPosts: []
  };

  sinceDate = getDateDaysAgo(30);
  console.log('🆕 First run - analyzing last 30 days');
}

// Allow --since flag to override state
if (args['--since']) {
  sinceDate = args['--since'];
  console.log(`Analyzing posts since: ${sinceDate} (overriding state)`);
} else {
  console.log(`Analyzing posts since: ${sinceDate}`);
}

function getDateDaysAgo(days: number): string {
  const date = new Date();
  date.setDate(date.getDate() - days);
  return date.toISOString().split('T')[0];
}
```

### Phase 1: Fetch Blog Posts

**Fetch from Claude blog**:

```typescript
const claudeBlog = await WebFetch({
  url: 'https://www.claude.com/blog',
  prompt: `
    Extract all blog post titles, URLs, publication dates, and summaries from this page.
    Focus on posts from the last 30 days.

    Return in this format:
    Title: [title]
    URL: [url]
    Date: [YYYY-MM-DD]
    Summary: [brief summary]
  `
});
```

**Fetch from Anthropic Engineering blog**:

```typescript
const anthropicBlog = await WebFetch({
  url: 'https://www.anthropic.com/engineering',
  prompt: `
    Extract all blog post titles, URLs, publication dates, and summaries from this page.
    Focus on posts from the last 30 days.

    Return in this format:
    Title: [title]
    URL: [url]
    Date: [YYYY-MM-DD]
    Summary: [brief summary]
  `
});
```

### Phase 2: Filter Relevant Posts

**Relevance criteria**:

```typescript
interface BlogPost {
  title: string;
  url: string;
  date: string;
  summary: string;
  source: 'claude-blog' | 'anthropic-engineering';
}

function isRelevant(post: BlogPost): boolean {
  const relevantKeywords = [
    // MCP
    'mcp', 'model context protocol', 'mcp server', 'mcp client',

    // Claude Code
    'claude code', 'code editor', 'ide integration', 'coding assistant',

    // Cloudflare
    'cloudflare', 'workers', 'edge', 'durable objects', 'd1', 'kv', 'r2',

    // React/Tanstack
    'react', 'tanstack', 'router', 'query', 'server functions',

    // Testing
    'playwright', 'testing', 'e2e', 'end-to-end', 'test automation',

    // Auth
    'authentication', 'authorization', 'oauth', 'passkeys', 'webauthn',

    // Email
    'email', 'transactional email', 'notifications', 'resend',

    // General
    'best practices', 'patterns', 'architecture', 'performance'
  ];

  const content = `${post.title} ${post.summary}`.toLowerCase();
  return relevantKeywords.some(keyword => content.includes(keyword));
}
```

### Phase 2.5: Filter Already-Processed Posts

**Skip posts that were analyzed in previous runs**:

```typescript
interface BlogPost {
  title: string;
  url: string;
  date: string;
  summary: string;
  source: 'claude-blog' | 'anthropic-engineering';
}

// allPosts contains combined results from Phase 1
// state was loaded in Phase 0

// Filter new posts
const newPosts = allPosts.filter(post => {
  // Skip if already processed
  if (state.lastProcessedPosts.includes(post.url)) {
    console.log(`⏭️  Skipping already analyzed: ${post.title}`);
    return false;
  }

  // Skip if before review date
  if (post.date < sinceDate) {
    return false;
  }

  return true;
});

// Log statistics
console.log(`\n📊 Filtering Statistics:`);
console.log(`   Total posts found: ${allPosts.length}`);
console.log(`   🆕 New posts to analyze: ${newPosts.length}`);
console.log(`   ⏭️  Already analyzed (skipped): ${allPosts.length - newPosts.length}`);

// If no new posts, exit early
if (newPosts.length === 0) {
  console.log('\n✅ No new posts to analyze. All caught up!');
  console.log(`📅 Next scheduled run: ${state.nextScheduledRun}`);
  process.exit(0);
}

// Continue with relevance filtering from Phase 2
const relevantPosts = newPosts.filter(isRelevant);
console.log(`   🎯 Relevant posts: ${relevantPosts.length}`);
```

### Phase 3: Deep Analysis

**For each relevant post, use Task tool**:

```typescript
const analysis = await Task({
  subagent_type: 'Explore',
  description: `Analyze blog post for plugin updates`,
  prompt: `
    Analyze this blog post: ${post.url}

    Focus on:
    1. What new features or capabilities are announced?
    2. What best practices are recommended?
    3. What patterns or architectures are suggested?
    4. Are there any deprecations or breaking changes?
    5. How does this relate to our plugins (edge-stack, claude-skills-analyzer)?

    Current plugin architecture:
    - edge-stack: Tanstack Start (React), Cloudflare Workers, 8 MCP servers, Playwright testing, Resend email
    - claude-skills-analyzer: Conversation analysis, skill generation

    Provide:
    1. Summary of key learnings
    2. Relevance assessment (HIGH/MEDIUM/LOW)
    3. Recommended actions (adopt/adapt/ignore)
    4. Implementation complexity (trivial/small/medium/large)
    5. Specific files/features to update
  `
});
```

### Phase 4: Generate Recommendations

**Output format**:

```markdown
## Blog Update Analysis Report

**Generated**: [date]
**Period Analyzed**: [since] → [today]
**Posts Reviewed**: [total count]
**Relevant Posts**: [filtered count]

---

### Executive Summary

📊 **Statistics**:
- High relevance: [count]
- Medium relevance: [count]
- Low relevance: [count]

🎯 **Recommended Actions**:
- Immediate updates: [count]
- Future enhancements: [count]
- No action needed: [count]

⏱️ **Estimated Effort**: [total effort estimate]

---

### High-Impact Learnings

#### 1. [Post Title]

**Source**: Claude Blog
**Published**: [date]
**URL**: [url]

**Key Learnings**:
- [learning 1]
- [learning 2]
- [learning 3]

**Relevance**: HIGH
**Reason**: [why this matters to our plugins]

**Recommended Action**: ADOPT

**Implementation Plan**:

1. **Update**: plugins/edge-stack/[file]
   - Add: [feature]
   - Modify: [existing feature]
   - Reason: [explanation]

2. **Update**: plugins/edge-stack/PREFERENCES.md
   - Add: [new preference]
   - Reason: [explanation]

3. **Create**: plugins/edge-stack/agents/[new-agent].md
   - Purpose: [description]
   - Reason: [explanation]

**Effort**: MEDIUM (2-3 hours)
**Priority**: HIGH
**Impact**: Improves [specific aspect]

**Files to Update**:
- plugins/edge-stack/[file1]
- plugins/edge-stack/[file2]
- README.md

---

#### 2. [Post Title]

[Same format as above]

---

### Medium-Impact Learnings

[Same format, lower priority]

---

### Informational (No Action Required)

#### [Post Title]
**Reason**: [why no action needed]
**Summary**: [brief summary for awareness]

---

### Implementation Roadmap

#### Immediate (This Week)

✅ **[Update 1]** (from post: [title])
- Effort: SMALL
- Files: [list]
- Expected outcome: [description]

✅ **[Update 2]** (from post: [title])
- Effort: TRIVIAL
- Files: [list]
- Expected outcome: [description]

#### Short Term (This Month)

📋 **[Update 3]** (from post: [title])
- Effort: MEDIUM
- Files: [list]
- Expected outcome: [description]

#### Long Term (This Quarter)

🔮 **[Update 4]** (from post: [title])
- Effort: LARGE
- Files: [list]
- Expected outcome: [description]

---

### Declined Recommendations

❌ **[Post Title]**
**Reason**: Not applicable to our stack
**Summary**: [brief explanation]

---

### Next Steps

1. Review high-priority recommendations
2. Create GitHub issues for approved updates
3. Schedule implementation based on effort estimates
4. Re-run this command in 30 days
```

### Phase 5: Update State

**Update state file with current run information**:

```typescript
import { writeFileSync } from 'fs';

// Generate timestamps
const now = new Date();
const today = now.toISOString().split('T')[0];
const nextMonth = new Date(now);
nextMonth.setMonth(nextMonth.getMonth() + 1);

// Update state with current run data
const updatedState: BlogUpdateState = {
  lastRun: now.toISOString(),
  lastReviewDate: today,
  nextScheduledRun: nextMonth.toISOString().split('T')[0],
  totalRuns: state.totalRuns + 1,
  postsAnalyzed: {
    ...state.postsAnalyzed,
    [today]: relevantPosts.length
  },
  lastProcessedPosts: [
    // Add new post URLs
    ...relevantPosts.map(p => p.url),
    // Keep existing URLs (up to 50)
    ...state.lastProcessedPosts.slice(0, 50)
  ].slice(0, 100) // Max 100 URLs total
};

// Write updated state to file
writeFileSync(
  STATE_FILE,
  JSON.stringify(updatedState, null, 2),
  'utf-8'
);

// Show confirmation
console.log('\n✅ State Updated:');
console.log(`   File: ${STATE_FILE}`);
console.log(`   Total runs: ${updatedState.totalRuns}`);
console.log(`   Posts analyzed today: ${relevantPosts.length}`);
console.log(`   Tracked URLs: ${updatedState.lastProcessedPosts.length}`);
console.log(`   📅 Next scheduled run: ${updatedState.nextScheduledRun}`);

// Optional: Generate detailed report (gitignored)
const reportFile = `plugins/edge-stack/.logs/blog-updates-${today}.report.md`;
console.log(`\n📝 Detailed report: ${reportFile}`);
console.log('   (This file is gitignored - available locally only)');
```

**State file structure**:

```json
{
  "lastRun": "2025-11-14T10:30:00.000Z",
  "lastReviewDate": "2025-11-14",
  "nextScheduledRun": "2025-12-14",
  "totalRuns": 5,
  "postsAnalyzed": {
    "2025-11-14": 12,
    "2025-10-14": 8,
    "2025-09-14": 5,
    "2025-08-14": 10,
    "2025-07-14": 7
  },
  "lastProcessedPosts": [
    "https://www.claude.com/blog/recent-post-1",
    "https://www.anthropic.com/engineering/recent-post-2",
    "https://www.claude.com/blog/recent-post-3"
  ]
}
```

---

## Example Analysis

### Scenario: New MCP Server Announced

**Blog Post**:
```
Title: "Introducing TanStack Router MCP Server"
URL: https://www.claude.com/blog/tanstack-router-mcp
Date: 2025-01-15
Summary: Official MCP server for TanStack Router documentation and code generation
```

**Analysis**:

```markdown
### TanStack Router MCP Server Announcement

**Source**: Claude Blog
**Published**: 2025-01-15
**URL**: https://www.claude.com/blog/tanstack-router-mcp

**Key Learnings**:
- Official MCP server now available for TanStack Router
- Provides real-time documentation access
- Supports code generation for routes and loaders
- Prevents hallucination of route patterns

**Relevance**: HIGH
**Reason**: We use Tanstack Start as our primary framework. This MCP server will improve route generation accuracy and keep docs up-to-date.

**Recommended Action**: ADOPT

**Implementation Plan**:

1. **Add MCP Server**: plugins/edge-stack/.mcp.json
   ```json
   "tanstack-router": {
     "type": "sse",
     "command": "npx",
     "args": ["-y", "mcp-remote", "https://gitmcp.io/TanStack/router"],
     "enabled": true,
     "description": "TanStack Router documentation"
   }
   ```

2. **Update**: plugins/edge-stack/README.md
   - Update MCP count: 7 → 8
   - Add to MCP server list
   - Update "What MCP Provides" examples

3. **Update**: README.md (project root)
   - Update MCP count: 7 → 8
   - Add TanStack Router to MCP list

4. **Update**: plugins/edge-stack/agents/tanstack-routing-specialist.md
   - Add MCP usage instructions
   - Document how to query TanStack Router MCP
   - Add examples of MCP-validated route patterns

**Effort**: SMALL (30 minutes)
**Priority**: HIGH
**Impact**: Improves route generation accuracy, prevents documentation drift

**Files to Update**:
- plugins/edge-stack/.mcp.json
- plugins/edge-stack/README.md
- README.md
- plugins/edge-stack/agents/tanstack-routing-specialist.md
```

---

## Topic-Specific Filters

### MCP Updates

**Keywords**: `mcp`, `model context protocol`, `mcp server`, `context protocol`

**What to look for**:
- New MCP servers announced
- MCP protocol updates
- Best practices for MCP integration
- MCP security considerations

**Our MCP Stack**:
- Cloudflare MCP
- shadcn/ui MCP
- better-auth MCP
- Playwright MCP
- Package Registry MCP
- TanStack Router MCP
- Tailwind CSS MCP
- Polar MCP

### Cloudflare Updates

**Keywords**: `cloudflare`, `workers`, `edge`, `durable objects`, `d1`, `kv`, `r2`

**What to look for**:
- New Cloudflare features
- Workers runtime updates
- Binding improvements
- Edge optimization techniques
- Deployment best practices

### React/Tanstack Updates

**Keywords**: `react`, `tanstack`, `router`, `query`, `server functions`, `ssr`

**What to look for**:
- Tanstack Start updates
- React 19 patterns
- Server function best practices
- TanStack Router improvements
- State management patterns

### Testing Updates

**Keywords**: `playwright`, `testing`, `e2e`, `test automation`, `accessibility testing`

**What to look for**:
- Playwright updates
- Testing patterns
- Accessibility testing improvements
- Performance testing techniques

---

## Automation

**Run periodically**:

```bash
# Weekly check
# Add to cron or GitHub Actions:
# 0 9 * * 1 /research-blog-updates

# Monthly comprehensive review
# 0 9 1 * * /research-blog-updates --since $(date -d '60 days ago' +%Y-%m-%d)
```

**GitHub Actions workflow** (optional):

```yaml
name: Blog Update Monitor

on:
  schedule:
    # Run every Monday at 9 AM
    - cron: '0 9 * * 1'
  workflow_dispatch:

jobs:
  monitor:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Research blog updates
        run: |
          # Run command and capture output
          /research-blog-updates > blog-analysis.md

      - name: Create issue if updates found
        if: contains(steps.research.outputs.recommendations, 'HIGH')
        uses: actions/github-script@v6
        with:
          script: |
            github.rest.issues.create({
              owner: context.repo.owner,
              repo: context.repo.repo,
              title: 'Blog Update: New recommendations available',
              body: require('fs').readFileSync('blog-analysis.md', 'utf8')
            });
```

---

## Success Criteria

✅ All blog posts from specified period fetched
✅ Posts filtered for relevance to our plugins
✅ Each relevant post analyzed in depth
✅ Actionable recommendations provided
✅ Implementation plans detailed
✅ Effort estimates realistic
✅ Files to update clearly identified
✅ Priority and impact assessed
✅ Next review date suggested
