#!/bin/bash
# Post-Write SKILL Validation Hook
# Runs relevant SKILLs immediately after code changes

echo "🔍 Running post-write SKILL validation..." >&2

# Get the most recently modified file
RECENT_FILE=$(git status --porcelain 2>/dev/null | head -1 | cut -c4-)
if [[ -z "$RECENT_FILE" ]]; then
  # Fallback to most recently modified in current directory
  RECENT_FILE=$(find . -name "*.ts" -o -name "*.js" -o -name "*.json" | head -1)
fi

if [[ -z "$RECENT_FILE" ]]; then
  echo "  ℹ️  No relevant files found for SKILL validation" >&2
  exit 0
fi

echo "  📁 Analyzing: $RECENT_FILE" >&2

# Track issues
ISSUES=0

# 1. Runtime Validation (workers-runtime-validator)
echo "  🔧 Checking runtime compatibility..." >&2
if [[ "$RECENT_FILE" =~ \.(ts|js)$ ]]; then
  # Check for Node.js APIs
  if grep -q "require(" "$RECENT_FILE" 2>/dev/null; then
    echo "    ❌ Found require() - use ES modules instead" >&2
    ISSUES=$((ISSUES + 1))
  fi
  
  if grep -q "process\.env" "$RECENT_FILE" 2>/dev/null; then
    echo "    ❌ Found process.env - use env parameter instead" >&2
    ISSUES=$((ISSUES + 1))
  fi
  
  if grep -q "from ['\"]fs['\"]" "$RECENT_FILE" 2>/dev/null; then
    echo "    ❌ Found fs import - not available in Workers" >&2
    ISSUES=$((ISSUES + 1))
  fi
  
  if grep -q "from ['\"]buffer['\"]" "$RECENT_FILE" 2>/dev/null; then
    echo "    ❌ Found buffer import - use Uint8Array instead" >&2
    ISSUES=$((ISSUES + 1))
  fi
fi

# 2. Security Validation (cloudflare-security-checker)
echo "  🔒 Checking security patterns..." >&2
if [[ "$RECENT_FILE" =~ \.(ts|js)$ ]]; then
  # Check for hardcoded secrets
  if grep -E "(sk_|sk_live_|sk_test_|api_key|secret|password).*=.*['\"][^'\"]+['\"]" "$RECENT_FILE" 2>/dev/null; then
    echo "    ❌ Potential hardcoded secret detected" >&2
    ISSUES=$((ISSUES + 1))
  fi
  
  # Check for SQL injection patterns
  if grep -E "SELECT.*\$\{.*\}" "$RECENT_FILE" 2>/dev/null; then
    echo "    ❌ Potential SQL injection - use prepared statements" >&2
    ISSUES=$((ISSUES + 1))
  fi
fi

# 3. Binding Validation (workers-binding-validator)
echo "  🔗 Checking binding patterns..." >&2
if [[ "$RECENT_FILE" =~ \.(ts|js)$ ]]; then
  # Check for env parameter usage
  if grep -q "env\." "$RECENT_FILE" 2>/dev/null; then
    echo "    ✅ Found env parameter usage" >&2
  fi
fi

# 4. Performance Validation (edge-performance-optimizer)
echo "  ⚡ Checking performance patterns..." >&2
if [[ "$RECENT_FILE" =~ package\.json$ ]]; then
  # Check for heavy dependencies
  if grep -q "\"moment\"" "$RECENT_FILE" 2>/dev/null; then
    echo "    ⚠️  moment.js detected (68KB) - consider native Date" >&2
    ISSUES=$((ISSUES + 1))
  fi
  
  if grep -q "\"lodash\"" "$RECENT_FILE" 2>/dev/null; then
    echo "    ⚠️  lodash detected (71KB) - consider native methods" >&2
    ISSUES=$((ISSUES + 1))
  fi
  
  if grep -q "\"axios\"" "$RECENT_FILE" 2>/dev/null; then
    echo "    ⚠️  axios detected (13KB) - use fetch instead" >&2
    ISSUES=$((ISSUES + 1))
  fi
fi

# 5. CORS Validation (cors-configuration-validator)
echo "  🌐 Checking CORS patterns..." >&2
if [[ "$RECENT_FILE" =~ \.(ts|js)$ ]]; then
  # Check for Response creation without CORS
  if grep -q "new Response" "$RECENT_FILE" 2>/dev/null; then
    if ! grep -q "Access-Control-Allow-Origin" "$RECENT_FILE" 2>/dev/null; then
      echo "    ⚠️  Response without CORS headers detected" >&2
      ISSUES=$((ISSUES + 1))
    fi
  fi
fi

# Summary
echo "" >&2
if [ $ISSUES -eq 0 ]; then
  echo "  ✅ No issues found by SKILLs" >&2
else
  echo "  ⚠️  Found $ISSUES potential issue(s) - see above" >&2
fi

exit 0