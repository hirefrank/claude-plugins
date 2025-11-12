#!/bin/bash
# Pre-Write SKILL Validation Hook
# Runs quick validation before code changes are made

echo "🔍 Running pre-write SKILL validation..." >&2

# Check if we're in a Cloudflare Workers project
if [[ ! -f "wrangler.toml" ]] && [[ ! -f "package.json" ]]; then
  echo "  ℹ️  Not a Workers project - skipping validation" >&2
  exit 0
fi

# Track warnings
WARNINGS=0

# 1. Check for common anti-patterns in existing codebase
echo "  🔧 Checking existing codebase patterns..." >&2

# Check for Node.js API usage
if find . -name "*.ts" -o -name "*.js" | head -5 | xargs grep -l "require(" 2>/dev/null >/dev/null; then
  echo "    ⚠️  Found require() usage in codebase" >&2
  WARNINGS=$((WARNINGS + 1))
fi

# Check for large dependencies
if [[ -f "package.json" ]]; then
  if grep -q "\"moment\":" package.json 2>/dev/null; then
    echo "    ⚠️  moment.js in dependencies - consider native Date" >&2
    WARNINGS=$((WARNINGS + 1))
  fi
  
  if grep -q "\"lodash\":" package.json 2>/dev/null; then
    echo "    ⚠️  lodash in dependencies - consider native methods" >&2
    WARNINGS=$((WARNINGS + 1))
  fi
fi

# 2. Check wrangler.toml configuration
if [[ -f "wrangler.toml" ]]; then
  echo "  ⚙️  Checking wrangler configuration..." >&2
  
  # Check for missing compatibility_date
  if ! grep -q "compatibility_date" wrangler.toml 2>/dev/null; then
    echo "    ⚠️  No compatibility_date in wrangler.toml" >&2
    WARNINGS=$((WARNINGS + 1))
  fi
  
  # Check for Node.js compatibility mode
  if grep -q "compatibility_flags.*nodejs_compat" wrangler.toml 2>/dev/null; then
    echo "    ℹ️  Node.js compatibility mode enabled" >&2
  fi
fi

# 3. Environment variable validation
echo "  🔒 Checking environment patterns..." >&2

# Check for potential hardcoded secrets in common files
for file in .env .env.local *.config.js *.config.ts; do
  if [[ -f "$file" ]]; then
    if grep -E "(sk_|sk_live_|sk_test_|api_key|secret|password).*=.*['\"][^'\"]{8,}['\"]" "$file" 2>/dev/null >/dev/null; then
      echo "    ⚠️  Potential hardcoded secret in $file" >&2
      WARNINGS=$((WARNINGS + 1))
    fi
  fi
done

# Summary
echo "" >&2
if [ $WARNINGS -eq 0 ]; then
  echo "  ✅ No pre-write warnings" >&2
else
  echo "  ⚠️  $WARNINGS warning(s) found - consider addressing before making changes" >&2
fi

exit 0