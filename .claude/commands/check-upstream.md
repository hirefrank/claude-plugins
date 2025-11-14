---
description: Operationalizes UPSTREAM.md tracking by fetching Every Inc template changes, analyzing them, and determining adoption strategy
---

# Check Upstream Command

## Purpose

Automates upstream template monitoring from Every Inc's Compounding Engineering plugin:

1. Fetches latest commits from upstream repository
2. Analyzes changes for relevance to hirefrank marketplace
3. Determines adoption strategy (adopt/adapt/ignore)
4. Updates UPSTREAM.md with analysis
5. Creates GitHub issues for changes to implement

**Upstream Repository**: https://github.com/EveryInc/every-marketplace
**State File**: plugins/edge-stack/.logs/upstream-check.json (machine-readable)
**Tracking File**: plugins/edge-stack/UPSTREAM.md (human-readable, legacy)
**License**: MIT (requires attribution)

---

## Usage

```bash
/check-upstream [--since YYYY-MM-DD] [--create-issues]
```

### Arguments

- `[--since YYYY-MM-DD]` - Optional. Check commits since this date. Default: last review date from UPSTREAM.md.
- `[--create-issues]` - Optional. Automatically create GitHub issues for changes to adopt.

### Examples

```bash
# Check since last review
/check-upstream

# Check since specific date
/check-upstream --since 2025-01-01

# Check and create GitHub issues
/check-upstream --create-issues

# Full review of last 90 days with issues
/check-upstream --since 2024-10-01 --create-issues
```

---

## Workflow

### Phase 0: Load State

**Load previous run state to prevent duplicate analysis**:

```bash
STATE_FILE="plugins/edge-stack/.logs/upstream-check.json"

echo "Loading state from previous runs..."

# Read state file
if [ -f "$STATE_FILE" ]; then
  LAST_REVIEW_DATE=$(jq -r '.lastReviewDate' "$STATE_FILE" 2>/dev/null || echo "")
  TOTAL_RUNS=$(jq -r '.totalRuns' "$STATE_FILE" 2>/dev/null || echo "0")

  echo "✅ Found state file"
  echo "   Last review: $LAST_REVIEW_DATE"
  echo "   Total runs: $TOTAL_RUNS"
else
  # First run - check UPSTREAM.md fallback
  if grep -q "Last Review:" plugins/edge-stack/UPSTREAM.md 2>/dev/null; then
    LAST_REVIEW_DATE=$(grep "Last Review:" plugins/edge-stack/UPSTREAM.md | cut -d: -f2 | xargs)
    echo "📋 Using date from UPSTREAM.md: $LAST_REVIEW_DATE"
  else
    # Default to 30 days ago
    LAST_REVIEW_DATE=$(date -d '30 days ago' +%Y-%m-%d)
    echo "🆕 First run - analyzing last 30 days"
  fi
fi

# Use --since flag if provided, otherwise use state
SINCE_DATE=${FLAG_SINCE:-$LAST_REVIEW_DATE}

echo ""
echo "Review period: $SINCE_DATE → $(date +%Y-%m-%d)"
echo ""
```

### Phase 1: Setup Upstream Remote

**Check if upstream remote exists**:

```bash
# Add upstream remote if not exists
if ! git remote | grep -q "every-upstream"; then
  git remote add every-upstream https://github.com/EveryInc/every-marketplace.git
  echo "✅ Added every-upstream remote"
else
  echo "✅ every-upstream remote already exists"
fi

# Fetch latest
git fetch every-upstream
echo "✅ Fetched latest upstream changes"
```

### Phase 2: Determine Review Period

**Review period determined in Phase 0**:

```bash
# SINCE_DATE already set in Phase 0
echo "Using review date: $SINCE_DATE"
```

### Phase 3: Fetch Upstream Commits

**Get commits since review date**:

```bash
# Fetch all commits in date range
git log every-upstream/main \
  --since="$SINCE_DATE" \
  --pretty=format:"%H|%an|%ad|%s" \
  --date=short \
  > /tmp/all-upstream-commits.txt

TOTAL_COMMITS=$(wc -l < /tmp/all-upstream-commits.txt)

echo "Found $TOTAL_COMMITS upstream commits in date range"
```

### Phase 3.5: Filter Already-Processed Commits

**Skip commits already analyzed in previous runs**:

```bash
# Load already-processed commit hashes from state
if [ -f "$STATE_FILE" ]; then
  jq -r '.lastProcessedCommits[]' "$STATE_FILE" 2>/dev/null > /tmp/processed-commits.txt || touch /tmp/processed-commits.txt
else
  touch /tmp/processed-commits.txt
fi

# Filter out already-processed commits
grep -v -F -f /tmp/processed-commits.txt /tmp/all-upstream-commits.txt > /tmp/new-commits.txt || true

NEW_COMMITS=$(wc -l < /tmp/new-commits.txt)
SKIPPED_COMMITS=$((TOTAL_COMMITS - NEW_COMMITS))

echo ""
echo "📊 Commit Statistics:"
echo "   Total commits found: $TOTAL_COMMITS"
echo "   New commits to analyze: $NEW_COMMITS"
echo "   Already analyzed (skipped): $SKIPPED_COMMITS"
echo ""

if [ "$NEW_COMMITS" -eq 0 ]; then
  echo "✅ No new commits to analyze. All caught up!"
  exit 0
fi
```

### Phase 4: Analyze Each Commit

**Task: upstream-tracker**

For each commit, call the `upstream-tracker` agent:

```markdown
**Task for upstream-tracker**:

Analyze these upstream commits and determine adoption strategy:

**Commits to analyze**:
[list of NEW commits from /tmp/new-commits.txt with hash, date, subject]

**Our current architecture**:
- edge-stack plugin: Tanstack Start (React), Cloudflare Workers, 8 MCPs
- claude-skills-analyzer plugin: Conversation analysis
- Focus: Cloudflare Workers, React/Tanstack, not Rails/Python

**For each commit, provide**:
1. Change category (architecture/triage/feedback/language-specific/etc.)
2. Relevance (adopt/adapt/ignore)
3. Priority (critical/high/medium/low)
4. Rationale (why relevant or not)
5. Implementation plan (if adopt/adapt)
6. Effort estimate (trivial/small/medium/large)
7. Files to modify

**Deliverable**:
Complete analysis report with:
- Summary statistics
- Adoption recommendations (grouped by priority)
- Adaptation plans (with Cloudflare/React context)
- Ignored changes (with rationale)
- UPSTREAM.md update text
```

### Phase 5: Generate Report

**Output format**:

```markdown
## Upstream Review Report

**Generated**: [date]
**Review Period**: [since] → [today]
**Upstream Branch**: every-upstream/main
**Commits Analyzed**: [count]

---

### Executive Summary

📊 **Statistics**:
- Total commits: [count]
- To adopt: [count]
- To adapt: [count]
- To ignore: [count]

⚡ **Effort Estimate**:
- Critical: [count] ([effort])
- High priority: [count] ([effort])
- Medium priority: [count] ([effort])
- Low priority: [count] ([effort])
- **Total**: [hours/days]

⚠️ **Breaking Changes**: [count]

---

### 🚨 Critical Changes (Adopt Immediately)

#### Commit: abc123
**Date**: 2025-01-10
**Subject**: Fix critical triage bug causing duplicate work
**Author**: Kieran Klaassen
**Category**: Bug Fix (Critical)

**What Changed**:
Fixed race condition in triage phase selection causing agents to analyze same file multiple times.

**Files Modified**:
- agents/architecture-strategist.md
- commands/triage.md

**Why Relevant**:
We use the same triage system. This bug affects our workflow.

**Implementation**:
```bash
# Cherry-pick the commit
git cherry-pick abc123

# Or manually apply:
# 1. Update .claude/agents/cloudflare-architecture-strategist.md
# 2. Add mutex check before phase selection
```

**Effort**: TRIVIAL (15 minutes)
**Priority**: CRITICAL
**Impact**: Prevents duplicate work, improves performance

**Files to Update**:
- .claude/agents/doc-sync-specialist.md (if we have similar pattern)

---

### ⭐ High Priority (Adopt This Week)

[Same format for each change]

---

### 📋 Medium Priority (Adopt This Month)

[Same format for each change]

---

### 🔄 Changes to Adapt

#### Commit: def456
**Date**: 2025-01-12
**Subject**: Improve performance monitoring in agents
**Category**: Generic Agent Enhancement

**Original Change**:
Added performance tracking for Rails controller response times and database query performance.

**Our Adaptation Needed**:
We need Cloudflare Workers-specific metrics instead:
- Cold start time
- CPU time
- Edge location
- Cache hit rates
- D1 query performance

**Implementation Plan**:

1. **Extract generic pattern**:
   - Performance tracking structure
   - Metrics collection approach
   - Reporting format

2. **Adapt for Workers**:
   - Replace Rails metrics with Workers metrics
   - Use `performance.now()` for timing
   - Track Cloudflare-specific data

3. **Apply to**:
   - plugins/edge-stack/agents/edge-performance-oracle.md
   - Add Workers-specific performance tracking

**Effort**: MEDIUM (2-3 hours)
**Priority**: MEDIUM
**Impact**: Better performance insights

**Files to Create/Modify**:
- plugins/edge-stack/agents/edge-performance-oracle.md

---

### ❌ Ignored Changes

#### Commit: ghi789
**Subject**: Update Rails 7.1 migration patterns
**Reason**: Rails-specific, not applicable to our JavaScript/React/Cloudflare stack
**Category**: Language-Specific

#### Commit: jkl012
**Subject**: Add Python type hints to code analysis agent
**Reason**: Python-specific, we use TypeScript
**Category**: Language-Specific

---

### UPSTREAM.md Update

Add this to `plugins/edge-stack/UPSTREAM.md`:

```markdown
## Adopted Changes

### 2025-01-14: Critical Triage Bug Fix
- **Upstream commit**: abc123
- **Description**: Fixed race condition in triage phase selection
- **Applied to**: .claude/agents/doc-sync-specialist.md
- **Changes**: Added mutex check before phase selection
- **Reason**: Prevents duplicate work in our triage workflow

### 2025-01-14: Enhanced Git Worktree Isolation
- **Upstream commit**: abc456
- **Description**: Better worktree cleanup and error handling
- **Applied to**: N/A (we don't use git worktrees yet)
- **Changes**: Documented pattern for future use
- **Reason**: Valuable for parallel agent execution

---

## Ignored Changes

### 2025-01-14: Rails 7.1 Migration Patterns
- **Upstream commit**: ghi789
- **Description**: Updated Rails-specific migration patterns
- **Reason**: Rails-specific, not applicable to our stack

### 2025-01-14: Python Type Hints Enhancement
- **Upstream commit**: jkl012
- **Description**: Added Python type checking to code analysis
- **Reason**: Python-specific, we use TypeScript
```

**Update review metrics**:
```markdown
## Adoption Metrics

- Changes reviewed: 15
- Changes adopted: 3
- Changes adapted: 2
- Changes ignored: 10
- Time investment: 4 hours
- Value assessment: High (critical bug fix, 2 workflow improvements)

## Current Status

**Last Review**: 2025-01-14
**Next Review**: 2025-02-14
**Tracking Active**: Yes
**Value Assessment**: High value - upstream continues to provide valuable improvements
```

---

### GitHub Issues to Create

#### Issue #1: Adopt Upstream Triage Bug Fix

```markdown
**Title**: Adopt upstream triage bug fix (commit abc123)

**Labels**: upstream, bug-fix, priority-critical

**Description**:

Upstream (Every Inc) fixed a critical race condition in the triage system that can cause duplicate work.

**Upstream Commit**: https://github.com/EveryInc/every-marketplace/commit/abc123

**What Changed**:
Fixed race condition in phase selection causing agents to analyze same file multiple times.

**Why We Need This**:
We use similar triage patterns. This bug affects our workflow efficiency.

**Implementation**:
- [ ] Review upstream commit
- [ ] Apply fix to .claude/agents/doc-sync-specialist.md
- [ ] Test triage workflow
- [ ] Update UPSTREAM.md

**Effort**: 15 minutes
**Priority**: Critical
**Impact**: Prevents wasted work, improves performance
```

#### Issue #2: Adapt Performance Monitoring for Cloudflare Workers

```markdown
**Title**: Adapt upstream performance monitoring for Workers

**Labels**: upstream, enhancement, cloudflare

**Description**:

Upstream added performance monitoring to agents (commit def456). We should adapt this for Cloudflare Workers-specific metrics.

**Upstream Commit**: https://github.com/EveryInc/every-marketplace/commit/def456

**What Changed**:
Added performance tracking for Rails applications (controller timing, DB queries).

**Our Adaptation**:
Replace Rails metrics with Workers metrics:
- Cold start time
- CPU time
- Edge location
- Cache hit rates
- D1 query performance

**Implementation**:
- [ ] Extract generic performance tracking pattern
- [ ] Adapt for Cloudflare Workers context
- [ ] Apply to plugins/edge-stack/agents/edge-performance-oracle.md
- [ ] Add examples for D1, KV, R2 performance tracking
- [ ] Update UPSTREAM.md

**Effort**: 2-3 hours
**Priority**: Medium
**Impact**: Better performance insights for Workers applications
```

---

### Next Steps

1. Review critical changes and apply immediately
2. Create GitHub issues for high/medium priority changes (if --create-issues flag used)
3. Schedule implementation based on effort estimates
4. Update UPSTREAM.md with review results
5. Set next review date (1 month from now)
```

---

## Phase 6: Update State Files

**Update both state file and UPSTREAM.md**:

```bash
# Update state file
TODAY=$(date +%Y-%m-%d)
NOW=$(date -Iseconds)
NEXT_MONTH=$(date -d '+1 month' +%Y-%m-%d)

# Extract new commit hashes
NEW_COMMIT_HASHES=$(cut -d'|' -f1 /tmp/new-commits.txt)

# Read existing state or initialize
if [ -f "$STATE_FILE" ]; then
  EXISTING_STATE=$(cat "$STATE_FILE")
  OLD_TOTAL_RUNS=$(echo "$EXISTING_STATE" | jq -r '.totalRuns // 0')
  OLD_COMMITS=$(echo "$EXISTING_STATE" | jq -r '.lastProcessedCommits // []')
else
  OLD_TOTAL_RUNS=0
  OLD_COMMITS="[]"
fi

# Create updated state
cat > "$STATE_FILE" << EOF
{
  "lastRun": "$NOW",
  "lastReviewDate": "$TODAY",
  "nextScheduledRun": "$NEXT_MONTH",
  "totalRuns": $((OLD_TOTAL_RUNS + 1)),
  "commitsAnalyzed": {
$([ -f "$STATE_FILE" ] && jq -r '.commitsAnalyzed | to_entries | map("    \"" + .key + "\": " + (.value | tostring)) | join(",\n")' "$STATE_FILE" || echo "")$([ -f "$STATE_FILE" ] && echo "," || echo "")
    "$TODAY": $NEW_COMMITS
  },
  "lastProcessedCommits": $(echo "$NEW_COMMIT_HASHES" | jq -R -s 'split("\n") | map(select(length > 0))' | jq ". + $OLD_COMMITS | unique | .[0:200]")
}
EOF

echo "✅ Updated state file: $STATE_FILE"
echo "   Last run: $NOW"
echo "   Next scheduled: $NEXT_MONTH"
echo "   Total runs: $((OLD_TOTAL_RUNS + 1))"
echo "   Commits tracked: $(jq -r '.lastProcessedCommits | length' "$STATE_FILE")"
echo ""

# Also update UPSTREAM.md for backwards compatibility
sed -i "s/Last Review: .*/Last Review: $TODAY/" plugins/edge-stack/UPSTREAM.md
sed -i "s/Next Review: .*/Next Review: $NEXT_MONTH/" plugins/edge-stack/UPSTREAM.md

# Update metrics
if grep -q "Changes reviewed:" plugins/edge-stack/UPSTREAM.md; then
  OLD_REVIEWED=$(grep "Changes reviewed:" plugins/edge-stack/UPSTREAM.md | grep -oP '\d+')
  NEW_REVIEWED=$((OLD_REVIEWED + NEW_COMMITS))
  sed -i "s/Changes reviewed: .*/Changes reviewed: $NEW_REVIEWED/" plugins/edge-stack/UPSTREAM.md
fi

# Append new entries (from agent output)
cat >> plugins/edge-stack/UPSTREAM.md << EOF

### $TODAY: [Upstream changes from analysis]
[Entries generated by upstream-tracker agent]
EOF

echo "✅ Updated UPSTREAM.md (backwards compatibility)"
```

### Phase 7: Create GitHub Issues (Optional)

**If --create-issues flag is set**:

```bash
# For each high/critical priority change
gh issue create \
  --title "Adopt upstream: [subject]" \
  --body "[detailed description from analysis]" \
  --label "upstream,priority-[level]"
```

---

## Example Run

```bash
$ /check-upstream --create-issues

Loading state from previous runs...
✅ Found state file
   Last review: 2024-12-14
   Total runs: 2

Review period: 2024-12-14 → 2025-01-14

Setting up upstream remote...
✅ every-upstream remote exists
✅ Fetched latest changes

Fetching upstream commits...
Found 15 upstream commits in date range

📊 Commit Statistics:
   Total commits found: 15
   New commits to analyze: 8
   Already analyzed (skipped): 7

Analyzing commits with upstream-tracker agent...
[Analysis in progress...]

✅ Analysis complete

──────────────────────────────────────
Upstream Review Summary
──────────────────────────────────────

Total commits analyzed: 8 (7 previously analyzed, skipped)
- To adopt: 2 (critical: 1, high: 1)
- To adapt: 1 (medium priority)
- To ignore: 5 (language-specific)

Estimated effort: 3 hours
Breaking changes: 0

──────────────────────────────────────

Critical changes found! Recommended immediate action:
1. Fix triage race condition (commit abc123) - 15 min

High priority changes:
1. Enhanced git worktree handling (commit abc456) - 1 hour

Creating GitHub issues...
✅ Created issue #10: Adopt upstream triage bug fix
✅ Created issue #11: Enhanced git worktree handling
✅ Created issue #12: Adapt performance monitoring for Workers

Updating state files...
✅ Updated state file: plugins/edge-stack/.logs/upstream-check.json
   Last run: 2025-01-14T10:30:00-05:00
   Next scheduled: 2025-02-14
   Total runs: 3
   Commits tracked: 23

✅ Updated UPSTREAM.md (backwards compatibility)

──────────────────────────────────────

Next review: 2025-02-14
Run: /check-upstream

Complete! 🎉
```

---

## Automation

**Monthly check** (recommended):

```bash
# Add to cron or GitHub Actions
# Run first Monday of each month at 9 AM:
# 0 9 1 * * /check-upstream --create-issues
```

**GitHub Actions workflow**:

```yaml
name: Upstream Template Monitor

on:
  schedule:
    # First day of month at 9 AM
    - cron: '0 9 1 * *'
  workflow_dispatch:

jobs:
  check-upstream:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Check upstream changes
        run: |
          /check-upstream --create-issues > upstream-report.md

      - name: Commit UPSTREAM.md updates
        run: |
          git config user.name "GitHub Actions"
          git config user.email "actions@github.com"
          git add plugins/edge-stack/UPSTREAM.md
          git commit -m "chore: Update UPSTREAM.md with monthly review" || true
          git push
```

---

## Safety Checks

**Before applying upstream changes**:

```bash
# 1. Verify upstream commit exists
git show every-upstream/main:[commit-hash]

# 2. Check for conflicts
git cherry-pick --no-commit [commit-hash] && git reset --hard || echo "⚠️  Conflicts detected"

# 3. Review diff before applying
git show [commit-hash]

# 4. Test changes in isolation
# Create test branch, apply change, verify it works
```

---

## Success Criteria

✅ Upstream remote configured correctly
✅ All commits since last review fetched
✅ Each commit analyzed for relevance
✅ Adoption strategy determined (adopt/adapt/ignore)
✅ Priority and effort estimates provided
✅ Implementation plans detailed
✅ UPSTREAM.md updated with analysis
✅ GitHub issues created for changes to implement
✅ Attribution maintained (MIT license compliance)
✅ Next review date set
