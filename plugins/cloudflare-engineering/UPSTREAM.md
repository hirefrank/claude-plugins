# Upstream Tracking Log

## Original Template

- **Source**: https://github.com/EveryInc/every-marketplace/tree/main/plugins/compounding-engineering
- **Date Copied**: 2025-11-05
- **License**: MIT
- **Original Author**: Kieran Klaassen (kieran@every.to)

## Architecture Attribution

This plugin's architecture and workflow orchestration is derived from Every's Compounding Engineering Plugin. We gratefully acknowledge their pioneering work in self-improving AI development tools.

**What we adopted**:
- Multi-agent orchestration system
- Parallel execution patterns
- Multi-phase workflow structure
- Triage system
- Feedback codification approach
- Git worktree isolation
- Command structure (6 commands)

**What we modified**:
- All agents specialized for Cloudflare ecosystem
- Removed language-specific agents (Rails, Python, TypeScript)
- Added Cloudflare-specific agents (Workers, Durable Objects, KV, R2)
- Adapted generic agents with Cloudflare context

## Tracking Setup

```bash
# Add upstream remote
git remote add every-upstream https://github.com/EveryInc/every-marketplace.git
git fetch every-upstream

# Monthly check script
./scripts/check-upstream.sh
```

## Agent Migration

### Removed (Language-Specific)
- ❌ `dhh-rails-reviewer.md` - Rails-specific
- ❌ `kieran-rails-reviewer.md` - Rails-specific
- ❌ `kieran-python-reviewer.md` - Python-specific
- ❌ `kieran-typescript-reviewer.md` - Generic TypeScript (not Workers-specific)
- ❌ `best-practices-researcher.md` - Rails/Python/TS docs
- ❌ `framework-docs-researcher.md` - Rails/Django/Express
- ❌ `every-style-editor.md` - Writing style (not code)
- ❌ `pr-comment-resolver.md` - GitHub-specific (may add back later)

### Kept (Generic)
- ✅ `feedback-codifier.md` - Learning engine (unchanged)
- ✅ `git-history-analyzer.md` - Generic (unchanged)
- ✅ `repo-research-analyst.md` - Generic (unchanged)
- ✅ `code-simplicity-reviewer.md` - Generic (unchanged)

### Adapted (Cloudflare Context)
- 🔄 `architecture-strategist.md` → `cloudflare-architecture-strategist.md`
- 🔄 `security-sentinel.md` → `cloudflare-security-sentinel.md`
- 🔄 `performance-oracle.md` → `edge-performance-oracle.md`
- 🔄 `pattern-recognition-specialist.md` → `cloudflare-pattern-specialist.md`
- 🔄 `data-integrity-guardian.md` → `cloudflare-data-guardian.md`

### Added (Cloudflare-Specific)
- ➕ `workers-runtime-guardian.md` - Workers runtime compatibility
- ➕ `binding-context-analyzer.md` - wrangler.toml parsing
- ➕ `durable-objects-architect.md` - Durable Objects patterns
- ➕ (More to be added: KV, R2, Workers AI specialists)

## Adopted Changes

_This section will track upstream changes we adopt over time._

### Example Entry Format:
```markdown
### YYYY-MM-DD: [Change Description]
- Upstream commit: [hash]
- Description: [what changed]
- Applied to: [which file(s)]
- Changes: [what we adapted]
- Reason: [why we adopted it]
```

## Ignored Changes

_This section will track upstream changes we intentionally ignore._

### Example Entry Format:
```markdown
### YYYY-MM-DD: [Change Description]
- Upstream commit: [hash]
- Description: [what changed]
- Reason: [why we ignored it]
```

## Review Schedule

- **Monthly**: Quick review of new commits
- **Quarterly**: Deep dive on all changes
- **As Needed**: Critical bug fixes or security updates

## Adoption Metrics

_To be tracked over time:_

- Changes reviewed: 0
- Changes adopted: 0
- Changes ignored: 0
- Time investment: 0 hours
- Value assessment: TBD

## Current Status

**Last Review**: 2025-11-05 (initial template copy)
**Next Review**: 2025-12-05
**Tracking Active**: Yes
**Value Assessment**: Too early (just started)

## Contributing Back

If we create genuinely generic improvements (not Cloudflare-specific), we may contribute back to Every's repository:

**Potential contributions**:
- Triage UI improvements
- Git worktree helpers
- Parallel execution optimizations
- TodoWrite integration enhancements

**Not contributing** (Cloudflare-specific):
- All Cloudflare agents
- Workers runtime checks
- Binding analysis tools
- Edge optimization patterns
