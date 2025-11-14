---
description: Syncs documentation with code changes, bumps plugin versions, and creates a release commit
---

# Release Plugin Command

## Purpose

Automates the plugin release workflow:
1. Analyzes code changes since last release
2. Updates all documentation (README.md, PREFERENCES.md, etc.)
3. Bumps plugin versions appropriately
4. Creates semantic release commit
5. Pushes to remote repository

## Usage

```bash
/release-plugin [plugin-name] [--major|--minor|--patch]
```

### Arguments

- `[plugin-name]` - Optional. Specific plugin to release (`edge-stack` or `claude-skills-analyzer`). If omitted, analyzes all plugins.
- `[--major|--minor|--patch]` - Optional. Force version bump type. If omitted, auto-detects based on changes.

### Examples

```bash
# Auto-detect changes and release all modified plugins
/release-plugin

# Release specific plugin with auto-detected version
/release-plugin edge-stack

# Force major version bump
/release-plugin edge-stack --major

# Force minor version bump
/release-plugin claude-skills-analyzer --minor

# Force patch version bump
/release-plugin edge-stack --patch
```

---

## Workflow

### Phase 1: Change Detection

**Analyze git changes since last release**:

```bash
# Get last release tag or commit
LAST_RELEASE=$(git describe --tags --abbrev=0 2>/dev/null || git rev-parse HEAD~10)

# Show changes
git diff ${LAST_RELEASE}..HEAD --stat

# Identify which plugins changed
EDGE_STACK_CHANGED=$(git diff ${LAST_RELEASE}..HEAD --name-only | grep -q "plugins/edge-stack" && echo "yes" || echo "no")
SKILLS_ANALYZER_CHANGED=$(git diff ${LAST_RELEASE}..HEAD --name-only | grep -q "plugins/claude-skills-analyzer" && echo "yes" || echo "no")
```

**Change categories**:
```typescript
interface ChangeDetection {
  agentsAdded: string[];
  agentsRemoved: string[];
  commandsAdded: string[];
  commandsRemoved: string[];
  mcpServersAdded: string[];
  mcpServersRemoved: string[];
  skillsAdded: string[];
  skillsRemoved: string[];
  preferencesModified: boolean;
  readmeModified: boolean;
  breakingChanges: string[];
}
```

### Phase 2: Documentation Sync

**Task: doc-sync-specialist**

Call the `doc-sync-specialist` agent to analyze changes and update documentation:

```markdown
**Task for doc-sync-specialist**:

Analyze git changes since ${LAST_RELEASE} and update all documentation files to reflect current state.

**Changes to analyze**:
- Agents: [list added/removed]
- Commands: [list added/removed]
- MCP Servers: [list added/removed]
- SKILLs: [list added/removed]
- Breaking changes: [list]

**Files to review**:
- README.md (project root)
- plugins/edge-stack/README.md
- plugins/edge-stack/PREFERENCES.md
- plugins/edge-stack/.claude-plugin/plugin.json
- plugins/claude-skills-analyzer/README.md
- plugins/claude-skills-analyzer/.claude-plugin/plugin.json

**Deliverable**:
1. List of all documentation updates needed
2. Recommended version bump (major/minor/patch) with rationale
3. Execute all updates using Edit tool
4. Verify all counts are accurate
```

### Phase 3: Version Bump

**Determine version bump**:

```typescript
function determineVersionBump(changes: ChangeDetection): 'major' | 'minor' | 'patch' {
  // MAJOR: Breaking changes
  if (changes.breakingChanges.length > 0) return 'major';
  if (changes.agentsRemoved.length > 0) return 'major';
  if (changes.commandsRemoved.length > 0) return 'major';
  if (changes.mcpServersRemoved.length > 0) return 'major';

  // MINOR: New features
  if (changes.agentsAdded.length > 0) return 'minor';
  if (changes.commandsAdded.length > 0) return 'minor';
  if (changes.mcpServersAdded.length > 0) return 'minor';
  if (changes.skillsAdded.length > 0) return 'minor';

  // PATCH: Docs, bug fixes
  return 'patch';
}
```

**Bump version in plugin.json**:

```typescript
// Read current version
const currentVersion = JSON.parse(fs.readFileSync('.claude-plugin/plugin.json')).version;

// Calculate new version
const [major, minor, patch] = currentVersion.split('.').map(Number);

let newVersion: string;
if (bumpType === 'major') {
  newVersion = `${major + 1}.0.0`;
} else if (bumpType === 'minor') {
  newVersion = `${major}.${minor + 1}.0`;
} else {
  newVersion = `${major}.${minor}.${patch + 1}`;
}

// Update plugin.json
edit('.claude-plugin/plugin.json', {
  old: `"version": "${currentVersion}"`,
  new: `"version": "${newVersion}"`
});
```

### Phase 4: Stage Untracked Files

```bash
# Add any new/untracked files
git add -A

# Show what will be committed
git status
```

### Phase 5: Create Release Commit

**Generate semantic commit message**:

```typescript
interface CommitMessage {
  type: 'feat' | 'fix' | 'docs' | 'chore' | 'refactor' | 'test';
  scope?: string;
  subject: string;
  body: string[];
  footer: string[];
  breaking: boolean;
}

function generateCommitMessage(changes: ChangeDetection, version: string): string {
  const type = changes.agentsAdded.length > 0 || changes.commandsAdded.length > 0 ? 'feat' : 'docs';
  const breaking = changes.breakingChanges.length > 0;

  let message = `${type}`;
  if (breaking) message += '!';
  message += `: Release v${version}\n\n`;

  // Body
  const body = [];

  if (changes.agentsAdded.length > 0) {
    body.push(`New agents:\n${changes.agentsAdded.map(a => `- ${a}`).join('\n')}`);
  }

  if (changes.commandsAdded.length > 0) {
    body.push(`New commands:\n${changes.commandsAdded.map(c => `- ${c}`).join('\n')}`);
  }

  if (changes.mcpServersAdded.length > 0) {
    body.push(`New MCP servers:\n${changes.mcpServersAdded.map(m => `- ${m}`).join('\n')}`);
  }

  if (changes.breakingChanges.length > 0) {
    body.push(`\nBREAKING CHANGES:\n${changes.breakingChanges.map(bc => `- ${bc}`).join('\n')}`);
  }

  message += body.join('\n\n');
  message += '\n\n🤖 Generated with [Claude Code](https://claude.com/claude-code)\n\nCo-Authored-By: Claude <noreply@anthropic.com>';

  return message;
}
```

**Example commit message**:

```
feat: Release v2.1.0

New agents:
- resend-email-specialist

New commands:
- /es-email-setup

New MCP servers:
- Resend MCP

Documentation updates:
- Updated agent count (23 → 24)
- Updated command count (20 → 21)
- Added email integration features
- Updated usage examples

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

### Phase 6: Commit and Push

```bash
# Create commit with generated message
git commit -m "${COMMIT_MESSAGE}"

# Show commit
git log -1 --stat

# Push to remote
git push origin main

# Optionally create git tag
git tag -a "v${NEW_VERSION}" -m "Release v${NEW_VERSION}"
git push origin "v${NEW_VERSION}"
```

---

## Complete Workflow Example

### Scenario: New Playwright Testing Added

**Step 1: Detect Changes**

```bash
$ /release-plugin edge-stack

Analyzing changes since last release (v1.2.0)...

Changes detected in plugins/edge-stack:
✅ 1 agent added: playwright-testing-specialist.md
✅ 2 commands added: es-test-setup.md, es-test-gen.md
✅ 1 MCP server added: Playwright
✅ PREFERENCES.md modified (Testing section added)
⚠️  No breaking changes
```

**Step 2: Sync Documentation**

```bash
Calling doc-sync-specialist agent...

Documentation sync report:
✅ README.md (project root)
  - Line 32: Updated agent count 22 → 23
  - Line 34: Updated command count 18 → 20
  - Line 35: Updated MCP count 7 → 8
  - Line 36: Added "E2E testing with Playwright"

✅ plugins/edge-stack/.claude-plugin/plugin.json
  - Line 3: Version will be bumped 1.2.0 → 1.3.0

All documentation updated successfully.
```

**Step 3: Version Bump**

```bash
Version bump recommendation: MINOR (new features added)
Current version: 1.2.0
New version: 1.3.0

Updating version in .claude-plugin/plugin.json...
✅ Version bumped successfully
```

**Step 4: Stage Files**

```bash
Staging all changes...

Changes to be committed:
  modified:   README.md
  modified:   plugins/edge-stack/.claude-plugin/plugin.json
  modified:   plugins/edge-stack/README.md
  modified:   plugins/edge-stack/PREFERENCES.md
  new file:   plugins/edge-stack/agents/playwright-testing-specialist.md
  new file:   plugins/edge-stack/commands/es-test-setup.md
  new file:   plugins/edge-stack/commands/es-test-gen.md
```

**Step 5: Create Commit**

```bash
Creating release commit...

Commit message:
─────────────────────────────────────────
feat: Release v1.3.0

New agents:
- playwright-testing-specialist

New commands:
- /es-test-setup
- /es-test-gen

New MCP servers:
- Playwright MCP

Documentation updates:
- Updated agent count (22 → 23)
- Updated command count (18 → 20)
- Updated MCP count (7 → 8)
- Added E2E testing features

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
─────────────────────────────────────────

Proceed with commit? (yes/no)
```

**Step 6: Push**

```bash
> yes

✅ Commit created: a1b2c3d
✅ Pushed to origin/main
✅ Created tag: v1.3.0
✅ Pushed tag to remote

Release v1.3.0 complete! 🎉
```

---

## Safety Checks

**Before committing, verify**:

```bash
# 1. All tests pass (if tests exist)
pnpm test 2>/dev/null || true

# 2. No uncommitted changes remain
git status --porcelain

# 3. Version is unique (not already tagged)
git tag | grep -q "v${NEW_VERSION}" && echo "⚠️  Version already exists" || echo "✅ Version is unique"

# 4. Remote is reachable
git ls-remote --exit-code origin >/dev/null 2>&1 && echo "✅ Remote accessible" || echo "❌ Cannot reach remote"
```

---

## Documentation Consistency Rules

### CRITICAL: Before release, verify README consistency

#### Rule 1: Never List Partial Commands/Agents/Skills

**Problem**: Listing SOME but not ALL items creates confusion.

**Solution**: Use link-based approach with directory counts:
```markdown
## Commands (24)

**Quick Start**: `/es-auth-setup` • `/es-billing-setup` • `/es-test-setup`

**Browse all**: [See all 24 commands →](commands/)

<details>
<summary>View complete command list</summary>
[Categorized list here]
</details>
```

**Why**: When you add a new command, you don't have to update the README. Counts stay accurate automatically.

#### Rule 2: Keep Counts Synchronized

**Check these locations**:
1. Marketplace README: `plugins/edge-stack/README.md`
2. Plugin README: `README.md`
3. `.claude-plugin/plugin.json`: `description` field

**Actual counts** (verify before release):
```bash
# Commands
ls -1 commands/*.md | wc -l

# Agents
ls -1 agents/*.md | wc -l

# Skills
find skills -name "SKILL.md" | wc -l
```

Update ALL locations with accurate counts.

#### Rule 3: Command Prefix Consistency

**Marketplace plugins require namespace prefixes**:
- Generic commands: `/edge-stack:review`, `/edge-stack:work`, `/edge-stack:plan`
- Edge-specific commands: Keep `es-` prefix (e.g., `/es-validate`, `/es-commit`)

**Never show** commands without prefixes in documentation (confuses users).

#### Rule 4: Cross-Reference Between READMEs

**Marketplace README** should link to plugin README for details:
```markdown
[📖 Full Documentation](./plugins/edge-stack/README.md)
```

**Plugin README** should link to marketplace README for installation:
```markdown
[⬅️ Back to Marketplace](../../README.md) • [Installation Guide](../../README.md#installation)
```

### Pre-Release Documentation Checklist

Run these checks before every release:

```bash
# 1. Verify counts match reality
COMMANDS=$(ls -1 commands/*.md | wc -l)
AGENTS=$(ls -1 agents/*.md | wc -l)
SKILLS=$(find skills -name "SKILL.md" | wc -l)

echo "Commands: $COMMANDS (should be in READMEs)"
echo "Agents: $AGENTS (should be in READMEs)"
echo "Skills: $SKILLS (should be in READMEs)"

# 2. Check for command prefix errors
grep -n "^/review\|^/work\|^/plan\|^/triage" README.md ../../README.md
# Should return ZERO matches (all should have /edge-stack: or es- prefix)

# 3. Verify cross-references exist
grep -q "Full Documentation.*plugins/edge-stack/README" ../../README.md && echo "✅ Marketplace → Plugin link exists"
grep -q "Back to Marketplace\|Installation Guide" README.md && echo "✅ Plugin → Marketplace link exists"
```

If any check fails, fix before releasing.

---

## Error Handling

**If documentation sync fails**:
```bash
❌ Documentation sync failed: [error]

Options:
1. Review changes manually and re-run
2. Skip documentation updates (--skip-docs)
3. Abort release
```

**If version bump conflicts**:
```bash
⚠️  Version v2.0.0 already exists in git tags

Options:
1. Force patch bump to v2.0.1
2. Manual version override: --version 2.1.0
3. Abort release
```

**If push fails**:
```bash
❌ Failed to push to remote: [error]

Commit created locally but not pushed.

Options:
1. Retry push: git push origin main
2. Force push: git push --force-with-lease origin main
3. Investigate error and push manually
```

---

## Command Flags

```bash
/release-plugin [plugin] [options]

Options:
  --major              Force major version bump (breaking changes)
  --minor              Force minor version bump (new features)
  --patch              Force patch version bump (bug fixes)
  --version X.Y.Z      Override version (use with caution)
  --skip-docs          Skip documentation sync (not recommended)
  --skip-push          Create commit but don't push
  --tag                Create git tag for release
  --dry-run            Preview changes without committing
  --help               Show this help message

Examples:
  /release-plugin                        # Auto-detect all changes
  /release-plugin edge-stack            # Release specific plugin
  /release-plugin --major               # Force breaking change version
  /release-plugin --dry-run             # Preview without committing
  /release-plugin edge-stack --tag      # Create git tag
```

---

## Success Criteria

✅ All code changes analyzed
✅ Documentation synchronized with code
✅ Version bumped appropriately (semver)
✅ Semantic commit message generated
✅ All files staged (no untracked files remain)
✅ Commit created successfully
✅ Pushed to remote repository
✅ Git tag created (if requested)
✅ Clean working directory after release

---

## Post-Release Checklist

After running `/release-plugin`:

- [ ] Verify commit on GitHub
- [ ] Check that documentation is accurate
- [ ] Test plugin installation from marketplace
- [ ] Monitor for any issues
- [ ] Announce release (if major/minor)
