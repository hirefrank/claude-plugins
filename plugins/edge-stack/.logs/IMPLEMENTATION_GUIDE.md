# Command State Tracking - Implementation Guide

## Overview

This guide shows how to implement state tracking in `/research-blog-updates` and `/check-upstream` commands to prevent duplicate analysis.

## Architecture

```
plugins/edge-stack/
├── .logs/
│   ├── README.md                    # Documentation
│   ├── .gitignore                   # Ignore *.report.md
│   ├── blog-updates.json            # State file (COMMITTED)
│   ├── upstream-check.json          # State file (COMMITTED)
│   ├── blog-updates-2025-01-14.report.md  # Detailed report (GITIGNORED)
│   └── upstream-check-2025-01-14.report.md # Detailed report (GITIGNORED)
```

## State File Schema

### blog-updates.json

```json
{
  "lastRun": "2025-01-14T10:30:00Z",
  "lastReviewDate": "2025-01-14",
  "nextScheduledRun": "2025-02-14",
  "totalRuns": 3,
  "postsAnalyzed": {
    "2025-01-14": 12,
    "2024-12-14": 8,
    "2024-11-14": 5
  },
  "lastProcessedPosts": [
    "https://www.claude.com/blog/mcp-server-announcement",
    "https://www.anthropic.com/engineering/react-19-patterns",
    "https://www.claude.com/blog/playwright-testing-guide"
  ]
}
```

### upstream-check.json

```json
{
  "lastRun": "2025-01-14T09:00:00Z",
  "lastReviewDate": "2025-01-14",
  "nextScheduledRun": "2025-02-14",
  "totalRuns": 5,
  "commitsAnalyzed": {
    "2025-01-14": 15,
    "2024-12-14": 22,
    "2024-11-14": 18
  },
  "lastProcessedCommits": [
    "abc123def456",
    "789012345678",
    "def789abc012"
  ]
}
```

---

## Implementation: /research-blog-updates

### Phase 0: Load State (NEW)

Add this at the beginning of the workflow:

```bash
STATE_FILE="plugins/edge-stack/.logs/blog-updates.json"

# Read state
if [ -f "$STATE_FILE" ]; then
  LAST_RUN=$(jq -r '.lastRun' "$STATE_FILE")
  LAST_REVIEW_DATE=$(jq -r '.lastReviewDate' "$STATE_FILE")
  LAST_PROCESSED=$(jq -r '.lastProcessedPosts[]' "$STATE_FILE")

  echo "📊 Last run: $LAST_RUN"
  echo "📅 Last review date: $LAST_REVIEW_DATE"
  echo "📝 Last processed: $(echo "$LAST_PROCESSED" | wc -l) posts"
else
  # First run
  LAST_REVIEW_DATE=$(date -d '30 days ago' +%Y-%m-%d)
  LAST_PROCESSED=""

  echo "🆕 First run - analyzing last 30 days"
fi

# Use --since flag if provided, otherwise use state
SINCE_DATE=${FLAG_SINCE:-$LAST_REVIEW_DATE}
echo "Analyzing posts since: $SINCE_DATE"
```

### Phase 2.5: Filter Already-Processed Posts (NEW)

After fetching posts, filter out already-processed ones:

```typescript
interface BlogPost {
  title: string;
  url: string;
  date: string;
  summary: string;
}

// Load state
const state = JSON.parse(
  readFileSync('plugins/edge-stack/.logs/blog-updates.json', 'utf-8')
);

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

console.log(`📊 Found ${allPosts.length} total posts`);
console.log(`🆕 ${newPosts.length} new posts to analyze`);
console.log(`⏭️  ${allPosts.length - newPosts.length} already analyzed (skipped)`);
```

### Phase 5: Update State (NEW)

Add this at the end, after generating the report:

```typescript
// Update state file
const now = new Date().toISOString();
const today = new Date().toISOString().split('T')[0];
const nextMonth = new Date();
nextMonth.setMonth(nextMonth.getMonth() + 1);

const updatedState = {
  lastRun: now,
  lastReviewDate: today,
  nextScheduledRun: nextMonth.toISOString().split('T')[0],
  totalRuns: (state.totalRuns || 0) + 1,
  postsAnalyzed: {
    ...state.postsAnalyzed,
    [today]: newPosts.length
  },
  lastProcessedPosts: [
    ...newPosts.map(p => p.url),
    ...state.lastProcessedPosts.slice(0, 50) // Keep last 50
  ].slice(0, 100) // Max 100 URLs
};

// Write state
writeFileSync(
  'plugins/edge-stack/.logs/blog-updates.json',
  JSON.stringify(updatedState, null, 2)
);

console.log('✅ Updated state file: .logs/blog-updates.json');
```

### Phase 6: Generate Detailed Report (NEW)

```bash
# Generate detailed report (gitignored)
REPORT_FILE="plugins/edge-stack/.logs/blog-updates-$(date +%Y-%m-%d).report.md"

cat > "$REPORT_FILE" << EOF
# Blog Updates Analysis Report

**Generated**: $(date -Iseconds)
**Period**: $SINCE_DATE → $(date +%Y-%m-%d)
**Posts Reviewed**: ${#allPosts[@]}
**New Posts**: ${#newPosts[@]}
**Skipped (already analyzed)**: $((${#allPosts[@]} - ${#newPosts[@]}))

---

[Full analysis output from Phase 4]
EOF

echo "📝 Detailed report: $REPORT_FILE"
echo "   (This file is gitignored - won't be committed)"
```

---

## Implementation: /check-upstream

### Phase 0: Load State (NEW)

```bash
STATE_FILE="plugins/edge-stack/.logs/upstream-check.json"

# Read state
if [ -f "$STATE_FILE" ]; then
  LAST_REVIEW_DATE=$(jq -r '.lastReviewDate' "$STATE_FILE")
  LAST_PROCESSED=$(jq -r '.lastProcessedCommits[]' "$STATE_FILE")

  echo "📊 Last review: $LAST_REVIEW_DATE"
  echo "📝 Last processed: $(echo "$LAST_PROCESSED" | wc -l) commits"
else
  # First run - check UPSTREAM.md fallback
  if grep -q "Last Review:" plugins/edge-stack/UPSTREAM.md; then
    LAST_REVIEW_DATE=$(grep "Last Review:" plugins/edge-stack/UPSTREAM.md | cut -d: -f2 | xargs)
    echo "📋 Using date from UPSTREAM.md: $LAST_REVIEW_DATE"
  else
    LAST_REVIEW_DATE=$(date -d '30 days ago' +%Y-%m-%d)
    echo "🆕 First run - analyzing last 30 days"
  fi

  LAST_PROCESSED=""
fi

# Use --since flag if provided
SINCE_DATE=${FLAG_SINCE:-$LAST_REVIEW_DATE}
```

### Phase 3.5: Filter Already-Processed Commits (NEW)

```bash
# Fetch commits
git log every-upstream/main \
  --since="$SINCE_DATE" \
  --pretty=format:"%H|%an|%ad|%s" \
  --date=short \
  > /tmp/all-commits.txt

# Load already-processed commits
if [ -f "$STATE_FILE" ]; then
  jq -r '.lastProcessedCommits[]' "$STATE_FILE" > /tmp/processed-commits.txt
else
  touch /tmp/processed-commits.txt
fi

# Filter new commits
grep -v -F -f /tmp/processed-commits.txt /tmp/all-commits.txt > /tmp/new-commits.txt || true

TOTAL_COMMITS=$(wc -l < /tmp/all-commits.txt)
NEW_COMMITS=$(wc -l < /tmp/new-commits.txt)
SKIPPED_COMMITS=$((TOTAL_COMMITS - NEW_COMMITS))

echo "📊 Found $TOTAL_COMMITS total commits"
echo "🆕 $NEW_COMMITS new commits to analyze"
echo "⏭️  $SKIPPED_COMMITS already analyzed (skipped)"
```

### Phase 7: Update State (NEW)

```typescript
// Update state file
const state = JSON.parse(
  readFileSync('plugins/edge-stack/.logs/upstream-check.json', 'utf-8')
);

const now = new Date().toISOString();
const today = new Date().toISOString().split('T')[0];
const nextMonth = new Date();
nextMonth.setMonth(nextMonth.getMonth() + 1);

const newCommitHashes = newCommits.map(c => c.hash);

const updatedState = {
  lastRun: now,
  lastReviewDate: today,
  nextScheduledRun: nextMonth.toISOString().split('T')[0],
  totalRuns: (state.totalRuns || 0) + 1,
  commitsAnalyzed: {
    ...state.commitsAnalyzed,
    [today]: newCommits.length
  },
  lastProcessedCommits: [
    ...newCommitHashes,
    ...state.lastProcessedCommits.slice(0, 50)
  ].slice(0, 200) // Keep last 200 commits
};

writeFileSync(
  'plugins/edge-stack/.logs/upstream-check.json',
  JSON.stringify(updatedState, null, 2)
);

// Also update UPSTREAM.md for backwards compatibility
updateUpstreamMd(today, nextMonth);
```

---

## Benefits

### 1. Deduplication
- **Problem**: Re-analyzing same blog posts/commits wastes time
- **Solution**: Track processed items by URL/hash
- **Result**: Only analyze new items

### 2. Incremental Analysis
- **Problem**: Monthly runs analyze overlapping periods
- **Solution**: Start from `lastReviewDate`
- **Result**: No gaps, no overlap

### 3. Progress Tracking
- **Problem**: Can't see command history
- **Solution**: Track total runs and items analyzed per date
- **Result**: Clear metrics over time

### 4. State in Git
- **Problem**: State gets lost, CI/CD can't access
- **Solution**: Commit small JSON state files
- **Result**: Portable, versioned state

### 5. Detailed Reports (Optional)
- **Problem**: Verbose output clutters git
- **Solution**: Generate `.report.md` files (gitignored)
- **Result**: Full details available locally, not in repo

---

## Usage Examples

### First Run

```bash
$ /research-blog-updates

🆕 First run - analyzing last 30 days
Analyzing posts since: 2024-12-14

📊 Found 25 total posts
🆕 25 new posts to analyze
⏭️  0 already analyzed (skipped)

[Analysis runs...]

✅ Updated state file: .logs/blog-updates.json
📝 Detailed report: .logs/blog-updates-2025-01-14.report.md
```

### Second Run (Next Month)

```bash
$ /research-blog-updates

📊 Last run: 2025-01-14T10:30:00Z
📅 Last review date: 2025-01-14
📝 Last processed: 25 posts
Analyzing posts since: 2025-01-14

📊 Found 30 total posts
🆕 8 new posts to analyze
⏭️  22 already analyzed (skipped)

[Only analyzes 8 new posts - much faster!]

✅ Updated state file: .logs/blog-updates.json
📝 Detailed report: .logs/blog-updates-2025-02-14.report.md
```

### Force Full Re-Analysis

```bash
$ /research-blog-updates --since 2024-01-01

Analyzing posts since: 2024-01-01 (overriding state)

📊 Found 150 total posts
🆕 125 new posts to analyze
⏭️  25 already analyzed (skipped)

[Analyzes all posts since Jan 1st, but still skips 25 duplicates]
```

---

## Migration Path

### For /check-upstream

Already has `UPSTREAM.md` tracking - enhance it:

1. ✅ Keep `UPSTREAM.md` for human-readable history
2. ✅ Add `.logs/upstream-check.json` for machine state
3. ✅ Migrate `Last Review` date from UPSTREAM.md on first run
4. ✅ Update both files going forward

### For /research-blog-updates

Currently has NO state tracking:

1. ✅ Create `.logs/blog-updates.json`
2. ✅ Set `lastReviewDate` to 30 days ago on first run
3. ✅ Track all future runs

---

## File Size Considerations

### State Files (Committed)

```json
// blog-updates.json - ~2KB
{
  "lastRun": "...",
  "lastReviewDate": "...",
  "nextScheduledRun": "...",
  "totalRuns": 10,
  "postsAnalyzed": { /* ~10 entries */ },
  "lastProcessedPosts": [ /* max 100 URLs */ ]
}

// upstream-check.json - ~5KB
{
  "lastRun": "...",
  "lastReviewDate": "...",
  "nextScheduledRun": "...",
  "totalRuns": 10,
  "commitsAnalyzed": { /* ~10 entries */ },
  "lastProcessedCommits": [ /* max 200 hashes */ ]
}
```

**Total committed**: ~7KB (negligible)

### Report Files (Gitignored)

```
blog-updates-2025-01-14.report.md    ~50KB (detailed analysis)
upstream-check-2025-01-14.report.md  ~100KB (detailed analysis)
```

**Total gitignored**: ~150KB per run (only kept locally)

---

## Conclusion

This approach provides:

✅ **Deduplication** - Never analyze same item twice
✅ **Incremental** - Only process new items
✅ **Portable** - State committed to git
✅ **Lightweight** - ~7KB committed state
✅ **Detailed** - Full reports available locally
✅ **Backwards Compatible** - Works with existing UPSTREAM.md

Recommended next steps:

1. Add Phase 0 (load state) to both commands
2. Add filtering logic to skip processed items
3. Add state update at end of workflow
4. Test with `--since` flag override
5. Document in command files
