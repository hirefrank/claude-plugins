# Upstream Tracking Strategy
## How to Capture and Apply Changes from compounding-engineering

**Context**: We're using Every's `compounding-engineering` as a template (not a maintained fork), but we still want to benefit from their improvements.

**Challenge**: How do we track what they're doing without merge conflict hell?

## The Philosophy: Manual Cherry-Picking

**Not a fork** = No automatic merging
**But we care** = Manual review of their changes
**Selective adoption** = Only take what's relevant

## Setup: Tracking Their Repository

### Step 1: Add as Remote (For Reference Only)

```bash
cd hirefrank-marketplace

# Add Every's repo as a remote (read-only reference)
git remote add every-upstream https://github.com/EveryInc/every-marketplace.git

# Fetch their branches (doesn't merge anything)
git fetch every-upstream

# Verify remote added
git remote -v
```

**Result**: You can see their commits without merging them.

### Step 2: Star and Watch on GitHub

```bash
# On GitHub:
1. Navigate to: https://github.com/EveryInc/every-marketplace
2. Click "Star" (show support)
3. Click "Watch" → "Custom"
4. Select: "Releases" and "Issues" (not all activity)
```

**Why**: Get notified of significant changes without noise.

### Step 3: Subscribe to Their Repository

**RSS Feed** (if you use an RSS reader):
```
https://github.com/EveryInc/every-marketplace/commits/main.atom
```

**GitHub CLI** (automated tracking):
```bash
# Install gh if not already
brew install gh  # or appropriate for your system

# Watch specific path
gh repo view EveryInc/every-marketplace --web
```

## Tracking Process: Monthly Review

### Every Month: Review Their Changes

```bash
# See what changed in compounding-engineering plugin
git fetch every-upstream

# View commits since last review
git log every-upstream/main --since="1 month ago" -- plugins/compounding-engineering/

# View actual changes
git diff HEAD..every-upstream/main -- plugins/compounding-engineering/
```

**Output**: List of commits and diffs you can review.

### Decision Tree: What to Adopt?

For each change, ask:

#### 1. Is it in a language-specific agent?
```bash
# Example: Update to kieran-rails-reviewer.md
```
**Decision**: ❌ Ignore - You deleted these agents

#### 2. Is it in a generic agent you kept?
```bash
# Example: Improvement to feedback-codifier.md
```
**Decision**: ✅ Review and potentially adopt

**Process**:
```bash
# See the specific change
git show every-upstream/main:plugins/compounding-engineering/agents/feedback-codifier.md > /tmp/their-version.md

# Compare with yours
diff plugins/cloudflare-engineering/agents/feedback-codifier.md /tmp/their-version.md

# If valuable, manually apply to your version
```

#### 3. Is it in a command?
```bash
# Example: New phase added to /review command
```
**Decision**: ✅ Review and potentially adapt

**Process**:
```bash
# See their change
git diff every-upstream/main^..every-upstream/main -- plugins/compounding-engineering/commands/review.md

# Apply similar change to your command
# (but with Cloudflare agent references)
```

#### 4. Is it new functionality?
```bash
# Example: New /generate_command command
```
**Decision**: ✅ Adopt if generally useful

**Process**:
```bash
# Copy the new file
git show every-upstream/main:plugins/compounding-engineering/commands/generate_command.md > plugins/cloudflare-engineering/commands/generate_command.md

# Adapt agent references for Cloudflare
```

#### 5. Is it a bug fix?
```bash
# Example: Fix in triage system logic
```
**Decision**: ✅ Definitely adopt

**Process**: Apply the same fix to your equivalent code.

## Tracking Log: What You've Adopted

### Create UPSTREAM.md in Your Plugin

```bash
touch plugins/cloudflare-engineering/UPSTREAM.md
```

**Content**:
```markdown
# Upstream Tracking Log

## Original Template
- Source: https://github.com/EveryInc/every-marketplace/tree/main/plugins/compounding-engineering
- Date Copied: 2025-11-05
- Commit: [commit-hash]
- License: MIT

## Adopted Changes

### 2025-12-01: Improved feedback-codifier Pattern Recognition
- Upstream commit: abc123
- Description: Better extraction of recurring themes
- Applied to: agents/cloudflare-feedback-codifier.md
- Changes: Adopted pattern matching logic, adapted examples to Cloudflare

### 2025-12-15: New Phase in /review Command
- Upstream commit: def456
- Description: Added "Impact Assessment" phase
- Applied to: commands/review.md
- Changes: Added phase with Cloudflare-specific impact criteria

### 2026-01-10: Bug Fix in Triage System
- Upstream commit: ghi789
- Description: Fixed priority sorting logic
- Applied to: commands/triage.md
- Changes: Applied identical fix

## Ignored Changes

### 2025-11-20: Enhanced Rails Reviewer
- Upstream commit: jkl012
- Reason: Rails-specific, not applicable to Cloudflare-only development

### 2025-12-08: New Python Agent
- Upstream commit: mno345
- Reason: Python-specific, not applicable to Cloudflare-only development
```

**Benefit**: Track what you've adopted and why you've ignored certain changes.

## Automation: Monthly Check Script

### Create a Helper Script

```bash
touch scripts/check-upstream.sh
chmod +x scripts/check-upstream.sh
```

**Content**:
```bash
#!/bin/bash
# Check for upstream changes in compounding-engineering

echo "🔍 Checking for upstream changes..."

# Fetch latest
git fetch every-upstream --quiet

# Get last check date from log
LAST_CHECK=$(git log -1 --format=%cd --date=short)
echo "📅 Last check: $LAST_CHECK"

# Count new commits
NEW_COMMITS=$(git log every-upstream/main --since="$LAST_CHECK" --oneline -- plugins/compounding-engineering/ | wc -l)
echo "📝 New commits: $NEW_COMMITS"

if [ "$NEW_COMMITS" -gt 0 ]; then
    echo ""
    echo "Recent changes:"
    git log every-upstream/main --since="$LAST_CHECK" --oneline -- plugins/compounding-engineering/

    echo ""
    echo "💡 Review changes with:"
    echo "   git log every-upstream/main --since=\"$LAST_CHECK\" -p -- plugins/compounding-engineering/"
else
    echo "✅ No new changes"
fi
```

**Usage**:
```bash
# Run monthly
./scripts/check-upstream.sh
```

## What Changes to Prioritize

### High Priority: Always Review

1. **Bug Fixes**: Any fix in commands or generic agents
2. **New Generic Agents**: If they add truly generic agents (like feedback-codifier)
3. **Command Architecture Changes**: Improvements to orchestration patterns
4. **Security Fixes**: Anything security-related

### Medium Priority: Review If Time

1. **Performance Improvements**: Optimization to parallel execution
2. **New Commands**: Additional workflow commands
3. **Triage System Updates**: Improvements to finding management
4. **Documentation**: Better explanations of patterns

### Low Priority: Usually Skip

1. **Language-Specific Agents**: Rails/Python/TypeScript reviewers
2. **Framework-Specific Logic**: ActiveRecord, Django patterns
3. **Every-Specific Content**: Their company style guides

## Quarterly Deep Dive

**Every 3 months**: Do a comprehensive review

```bash
# See all changes in last quarter
git log every-upstream/main --since="3 months ago" -- plugins/compounding-engineering/

# Generate a summary
git log every-upstream/main --since="3 months ago" --oneline -- plugins/compounding-engineering/ > quarterly-review.txt

# Review each commit
git log every-upstream/main --since="3 months ago" -p -- plugins/compounding-engineering/ | less
```

**Outcome**: Identify any major architectural shifts or valuable patterns.

## When to NOT Track Upstream

**Stop tracking if**:

1. ✅ **They pivot to a different domain**
   - Example: Focus entirely on Rails AI assistance
   - Your divergence becomes too great

2. ✅ **No valuable changes in 6+ months**
   - They've stopped maintaining
   - Not worth the overhead

3. ✅ **Your architecture diverges significantly**
   - You've added major features they don't have
   - Tracking becomes comparing apples to oranges

4. ✅ **Maintenance overhead > value**
   - Spending hours reviewing changes
   - Adopting nothing valuable

**Decision Point**: Re-evaluate every 6 months.

## Contributing Back Upstream

**If you create genuinely generic improvements**, consider contributing back:

### Examples of Contributable Changes

✅ **Generic**:
- Improved triage UI patterns
- Better TodoWrite integration
- Git worktree helper functions
- Parallel execution optimizations

❌ **Not Generic** (keep in your plugin):
- Cloudflare-specific agents
- Workers runtime checks
- Binding context analysis
- Edge optimization patterns

### How to Contribute Back

```bash
# Fork their repo on GitHub
gh repo fork EveryInc/every-marketplace

# Create a branch for your improvement
git checkout -b improve-triage-system

# Make changes to compounding-engineering
# (only generic improvements, not Cloudflare stuff)

# Commit and push
git commit -m "Improve triage priority sorting"
git push origin improve-triage-system

# Create PR
gh pr create --base main --head improve-triage-system
```

**Benefits**:
- Good open source citizenship
- Potential collaboration
- They improve, you benefit from their future improvements
- Community building

## Example Workflow: Adopting a Change

**Scenario**: Every adds a new "Risk Assessment" phase to `/review` command

### Step 1: Discover the Change
```bash
./scripts/check-upstream.sh
# Output: "1 new commit: Add risk assessment to review command"
```

### Step 2: Review the Diff
```bash
git show every-upstream/main:plugins/compounding-engineering/commands/review.md > /tmp/their-review.md
diff plugins/cloudflare-engineering/commands/review.md /tmp/their-review.md
```

**Diff shows**:
```diff
+ **Phase 5: Risk Assessment**
+ Evaluate deployment risks:
+ - Database migration impact
+ - API contract changes
+ - Dependency updates
```

### Step 3: Adapt to Cloudflare Context
```bash
# Edit your review.md
vim plugins/cloudflare-engineering/commands/review.md
```

**Add**:
```markdown
**Phase 5: Risk Assessment**
Evaluate deployment risks:
- wrangler.toml binding changes
- Workers runtime compatibility
- Durable Object migration needs
- KV schema changes
- Edge cache invalidation impact
```

### Step 4: Log the Adoption
```bash
# Update UPSTREAM.md
echo "### $(date +%Y-%m-%d): Risk Assessment Phase" >> plugins/cloudflare-engineering/UPSTREAM.md
echo "- Upstream commit: [hash]" >> plugins/cloudflare-engineering/UPSTREAM.md
echo "- Applied to: commands/review.md" >> plugins/cloudflare-engineering/UPSTREAM.md
echo "- Changes: Adapted risk criteria for Cloudflare deployments" >> plugins/cloudflare-engineering/UPSTREAM.md
```

### Step 5: Test
```bash
# Test the updated command
/review
# Verify the new phase works with Cloudflare context
```

### Step 6: Commit
```bash
git add plugins/cloudflare-engineering/
git commit -m "Adopt risk assessment phase from upstream

Adapted Every's risk assessment phase for Cloudflare context:
- Focus on binding changes vs database migrations
- Workers runtime compatibility vs API contracts
- Edge-specific deployment considerations

Upstream commit: [hash]
"
```

## Metrics: Track Value

**Keep metrics on upstream adoption**:

```markdown
# UPSTREAM.md

## Adoption Metrics

- Changes reviewed: 47
- Changes adopted: 12 (26%)
- Changes ignored: 35 (74% - mostly language-specific)
- Bug fixes adopted: 3
- New features adopted: 4
- Architecture improvements: 5

## Time Investment

- Q4 2025: 2 hours review, adopted 4 changes
- Q1 2026: 1.5 hours review, adopted 2 changes
- Q2 2026: 3 hours review, adopted 6 changes

## Value Assessment

- High value: 8 changes (worth the tracking)
- Medium value: 3 changes (nice to have)
- Low value: 1 change (could have skipped)

**Verdict**: Tracking continues to provide value
```

**Decision aid**: If "Low value" dominates, stop tracking.

## Summary: Practical Upstream Tracking

**Setup** (one-time):
1. Add their repo as git remote
2. Star and watch on GitHub
3. Create UPSTREAM.md log
4. Create check script

**Monthly** (15-30 minutes):
1. Run check script
2. Review changes
3. Cherry-pick valuable improvements
4. Log what you adopted/ignored

**Quarterly** (1-2 hours):
1. Deep dive on all changes
2. Identify architectural shifts
3. Evaluate if tracking still provides value
4. Consider contributing improvements back

**When to Stop**:
- No valuable changes in 6 months
- Architecture diverged too much
- Overhead exceeds value

**This approach gives you**:
- ✅ Awareness of their improvements
- ✅ Ability to adopt valuable changes
- ✅ No merge conflict hell
- ✅ Full control over your codebase
- ✅ Measurable value tracking

**You get the best of both worlds**: Their ongoing innovation + Your focused independence.
