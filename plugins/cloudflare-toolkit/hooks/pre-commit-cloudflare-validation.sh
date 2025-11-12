#!/bin/bash
# Cloudflare Workers Pre-commit Validation
# Runs validation checks before git commit

echo "🔍 Running Cloudflare Workers pre-commit validation..." >&2

# Track errors and warnings
errors=0
warnings=0
WARNING_THRESHOLD=5

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
compat_date=$(grep "compatibility_date" wrangler.toml 2>/dev/null | head -1 | awk -F'"' '{print $2}')
if [[ -n "$compat_date" ]]; then
  # Check if date is 2025-09-15 or later
  if [[ "$compat_date" < "2025-09-15" ]]; then
    echo "  ⚠️  compatibility_date ($compat_date) should be 2025-09-15 or later" >&2
    errors=$((errors + 1))
  else
    echo "  ✅ compatibility_date is current ($compat_date)" >&2
  fi
fi

# 3. Run build if present
if [ -f package.json ] && grep -q "\"build\"" package.json; then
  echo "  Running build..." >&2
  if ! pnpm run build 2>&1; then
    echo "  ❌ Build failed" >&2
    errors=$((errors + 1))
  else
    echo "  ✅ Build succeeded" >&2
  fi
fi

# 4. Run lint if present
if [ -f package.json ] && grep -q "\"lint\"" package.json; then
  echo "  Running linter..." >&2
  lint_output=$(pnpm run lint 2>&1)
  lint_exit_code=$?
  
  if [ $lint_exit_code -ne 0 ]; then
    echo "  ❌ Linting failed" >&2
    errors=$((errors + 1))
  else
    # Count warnings in lint output
    lint_warnings=$(echo "$lint_output" | grep -c "warning" || echo "0")
    warnings=$((warnings + lint_warnings))
    
    if [ $lint_warnings -eq 0 ]; then
      echo "  ✅ Linting passed (no warnings)" >&2
    else
      echo "  ⚠️  Linting passed with $lint_warnings warning(s)" >&2
    fi
  fi
fi

# 5. Check TypeScript if present
if [ -f tsconfig.json ] && [ -f package.json ]; then
  if grep -q "\"typecheck\"" package.json; then
    echo "  Running TypeScript checks..." >&2
    tsc_output=$(pnpm run typecheck 2>&1)
    tsc_exit_code=$?
    
    if [ $tsc_exit_code -ne 0 ]; then
      echo "  ❌ TypeScript errors found" >&2
      errors=$((errors + 1))
    else
      # Count warnings in TypeScript output
      tsc_warnings=$(echo "$tsc_output" | grep -c "warning" || echo "0")
      warnings=$((warnings + tsc_warnings))
      
      if [ $tsc_warnings -eq 0 ]; then
        echo "  ✅ No TypeScript errors (no warnings)" >&2
      else
        echo "  ⚠️  No TypeScript errors with $tsc_warnings warning(s)" >&2
      fi
    fi
  fi
fi

# 6. Check bundle size (if build command exists)
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

# 7. Summary
echo "" >&2
echo "📊 Summary: $errors error(s), $warnings warning(s)" >&2

if [ $errors -gt 0 ]; then
  echo "❌ Found $errors error(s). ALL errors must be fixed before committing." >&2
  echo "   Zero tolerance for errors - fix every error before committing." >&2
  exit 1
elif [ $warnings -gt $WARNING_THRESHOLD ]; then
  echo "⚠️  Found $warnings warnings (threshold: $WARNING_THRESHOLD). Address warnings before committing." >&2
  echo "   Too many warnings indicates sloppy code. Clean up warnings to improve code quality." >&2
  exit 1
else
  echo "✅ All checks passed - ready to commit!" >&2
  exit 0
fi