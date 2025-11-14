# Command Execution Logs

This directory tracks execution state for automated commands to prevent duplicate work.

## Files

- `blog-updates.json` - Tracks blog post analysis runs
- `upstream-check.json` - Tracks upstream repository reviews
- `*.report.md` - Detailed reports from each run (gitignored)

## Format

Each JSON file contains:

```json
{
  "lastRun": "2025-01-14T10:30:00Z",
  "lastReviewDate": "2025-01-14",
  "nextScheduledRun": "2025-02-14",
  "totalRuns": 15,
  "itemsProcessed": {
    "2025-01-14": 12,
    "2024-12-14": 8,
    "2024-11-14": 5
  },
  "lastProcessedItems": [
    "item-id-1",
    "item-id-2"
  ]
}
```

## Usage

Commands automatically:
1. Read state file before execution
2. Skip already-processed items
3. Update state file after completion
4. Generate detailed reports (optional)

## Git Tracking

- ✅ `.json` state files - **COMMITTED** (small, important)
- ❌ `.report.md` files - **GITIGNORED** (large, verbose)
