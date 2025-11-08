#!/bin/bash
# Cloudflare Workers Validation Stop Hook
# Runs validation checks before ending Claude Code session

# Read the JSON input from stdin
input=$(cat)

# Check if stop hook is already active (recursion prevention)
stop_hook_active=$(echo "$input" | jq -r '.stop_hook_active')
if [[ "$stop_hook_active" = "true" ]]; then
  exit 0
fi

# Only run in Cloudflare Workers projects
if [ ! -f wrangler.toml ]; then
  exit 0
fi

echo "🔍 Running Cloudflare Workers validation checks..." >&2

# Track errors
errors=0

# 1. Validate wrangler.toml syntax
echo "  Checking wrangler.toml syntax..." >&2
if command -v wrangler &> /dev/null; then
  if ! wrangler validate 2>&1 | grep -q "Valid"; then
    echo "  ❌ wrangler.toml validation failed" >&2
    errors=$((errors + 1))
  else
    echo "  ✅ wrangler.toml is valid" >&2
  fi
fi

# 2. Check compatibility_date
compat_date=$(grep "compatibility_date" wrangler.toml | head -1 | awk -F'"' '{print $2}')
if [[ -n "$compat_date" ]]; then
  # Check if date is 2025-09-15 or later
  if [[ "$compat_date" < "2025-09-15" ]]; then
    echo "  ⚠️  compatibility_date ($compat_date) should be 2025-09-15 or later" >&2
    errors=$((errors + 1))
  else
    echo "  ✅ compatibility_date is current ($compat_date)" >&2
  fi
fi

# 3. Check for remote bindings configuration
if grep -q "\[\[kv_namespaces\]\]" wrangler.toml || \
   grep -q "\[\[d1_databases\]\]" wrangler.toml || \
   grep -q "\[\[r2_buckets\]\]" wrangler.toml; then

  # Count bindings without remote = true
  missing_remote=0

  # This is a simplified check - a real implementation would parse TOML properly
  if grep -A 3 "\[\[kv_namespaces\]\]" wrangler.toml | grep -v "remote = true" | grep -q "binding"; then
    echo "  ⚠️  Some bindings may be missing 'remote = true' configuration" >&2
    echo "     (Enable remote bindings for development with real Cloudflare resources)" >&2
  fi
fi

# 4. Check TypeScript if present
if [ -f tsconfig.json ] && [ -f package.json ]; then
  if grep -q "\"typecheck\"" package.json; then
    echo "  Running TypeScript checks..." >&2
    if pnpm run typecheck 2>&1 | grep -q "error"; then
      echo "  ❌ TypeScript errors found" >&2
      errors=$((errors + 1))
    else
      echo "  ✅ No TypeScript errors" >&2
    fi
  fi
fi

# 5. Check bundle size (if build command exists)
if [ -f package.json ] && grep -q "\"build\"" package.json; then
  echo "  Checking bundle size..." >&2

  # Try dry-run deployment to check size
  if command -v wrangler &> /dev/null; then
    output=$(wrangler deploy --dry-run 2>&1 || true)

    # Look for size in output (wrangler reports bundle size)
    if echo "$output" | grep -q "Total Upload"; then
      size=$(echo "$output" | grep "Total Upload" | awk '{print $3}')
      echo "  ℹ️  Bundle size: $size" >&2

      # Warn if over 1MB (Workers limit is 1MB for paid, 500KB for free)
      if echo "$output" | grep -E "Total Upload.*[1-9][0-9]{3}" | grep -q "KiB"; then
        echo "  ⚠️  Bundle size is large (> 1MB)" >&2
      fi
    fi
  fi
fi

# 6. Summary
echo "" >&2
if [ $errors -eq 0 ]; then
  echo "✅ All Cloudflare validation checks passed" >&2
  exit 0
else
  echo "⚠️  Found $errors validation issue(s). Please address before ending session." >&2
  exit 2
fi
