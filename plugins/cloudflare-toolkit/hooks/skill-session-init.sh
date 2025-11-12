#!/bin/bash
# Session Initialization SKILL Hook
# Runs comprehensive SKILL analysis when starting a development session

echo "🚀 Initializing Cloudflare Workers SKILL environment..." >&2

# Check if we're in a Cloudflare Workers project
if [[ ! -f "wrangler.toml" ]] && [[ ! -f "package.json" ]]; then
  echo "  ℹ️  Not a Workers project - skipping SKILL initialization" >&2
  exit 0
fi

echo "  📊 Running comprehensive SKILL analysis..." >&2

# 1. Workers Runtime Validator Analysis
echo "  🔧 Runtime compatibility analysis:" >&2
RUNTIME_ISSUES=0

# Check for Node.js API usage
if find . -name "*.ts" -o -name "*.js" | head -10 | xargs grep -l "require(" 2>/dev/null >/dev/null; then
  echo "    ❌ Found require() usage - should use ES modules" >&2
  RUNTIME_ISSUES=$((RUNTIME_ISSUES + 1))
fi

if find . -name "*.ts" -o -name "*.js" | head -10 | xargs grep -l "process\.env" 2>/dev/null >/dev/null; then
  echo "    ❌ Found process.env usage - should use env parameter" >&2
  RUNTIME_ISSUES=$((RUNTIME_ISSUES + 1))
fi

if find . -name "*.ts" -o -name "*.js" | head -10 | xargs grep -l "from ['\"]fs['\"]" 2>/dev/null >/dev/null; then
  echo "    ❌ Found fs import - not available in Workers" >&2
  RUNTIME_ISSUES=$((RUNTIME_ISSUES + 1))
fi

if [ $RUNTIME_ISSUES -eq 0 ]; then
  echo "    ✅ No runtime compatibility issues" >&2
fi

# 2. Security Analysis
echo "  🔒 Security analysis:" >&2
SECURITY_ISSUES=0

# Check for hardcoded secrets
if find . -name "*.ts" -o -name "*.js" -o -name "*.json" | head -10 | xargs grep -E "(sk_|sk_live_|sk_test_|api_key|secret|password).*=.*['\"][^'\"]+['\"]" 2>/dev/null >/dev/null; then
  echo "    ❌ Potential hardcoded secrets found" >&2
  SECURITY_ISSUES=$((SECURITY_ISSUES + 1))
fi

# Check for unsafe eval usage
if find . -name "*.ts" -o -name "*.js" | head -10 | xargs grep -l "eval(" 2>/dev/null >/dev/null; then
  echo "    ❌ Found eval() usage - security risk" >&2
  SECURITY_ISSUES=$((SECURITY_ISSUES + 1))
fi

if [ $SECURITY_ISSUES -eq 0 ]; then
  echo "    ✅ No security issues detected" >&2
fi

# 3. Performance Analysis
echo "  ⚡ Performance analysis:" >&2
PERFORMANCE_ISSUES=0

if [[ -f "package.json" ]]; then
  # Check bundle size impact
  if grep -q "\"moment\":" package.json 2>/dev/null; then
    echo "    ⚠️  moment.js detected (+68KB) - consider native Date" >&2
    PERFORMANCE_ISSUES=$((PERFORMANCE_ISSUES + 1))
  fi
  
  if grep -q "\"lodash\":" package.json 2>/dev/null; then
    echo "    ⚠️  lodash detected (+71KB) - consider native methods" >&2
    PERFORMANCE_ISSUES=$((PERFORMANCE_ISSUES + 1))
  fi
  
  if grep -q "\"axios\":" package.json 2>/dev/null; then
    echo "    ⚠️  axios detected (+13KB) - use fetch instead" >&2
    PERFORMANCE_ISSUES=$((PERFORMANCE_ISSUES + 1))
  fi
fi

# Check for synchronous operations
if find . -name "*.ts" -o -name "*.js" | head -10 | xargs grep -l "\.readFileSync\|\.writeFileSync" 2>/dev/null >/dev/null; then
  echo "    ⚠️  Found synchronous file operations - use async alternatives" >&2
  PERFORMANCE_ISSUES=$((PERFORMANCE_ISSUES + 1))
fi

if [ $PERFORMANCE_ISSUES -eq 0 ]; then
  echo "    ✅ No performance issues detected" >&2
fi

# 4. Binding Analysis
echo "  🔗 Binding analysis:" >&2
BINDING_ISSUES=0

# Check for proper env parameter usage
if find . -name "*.ts" -o -name "*.js" | head -10 | xargs grep -l "env\." 2>/dev/null >/dev/null; then
  echo "    ✅ Found env parameter usage" >&2
else
  echo "    ℹ️  No env parameter usage detected" >&2
fi

# Check wrangler.toml bindings
if [[ -f "wrangler.toml" ]]; then
  if grep -q "\[vars\]" wrangler.toml 2>/dev/null; then
    echo "    ✅ Found environment variables configuration" >&2
  fi
  
  if grep -q "\[kv_namespaces\]" wrangler.toml 2>/dev/null; then
    echo "    ✅ Found KV namespace bindings" >&2
  fi
  
  if grep -q "\[durable_objects\]" wrangler.toml 2>/dev/null; then
    echo "    ✅ Found Durable Objects bindings" >&2
  fi
fi

# 5. CORS Analysis
echo "  🌐 CORS analysis:" >&2
CORS_ISSUES=0

# Check for CORS handling
if find . -name "*.ts" -o -name "*.js" | head -10 | xargs grep -l "new Response" 2>/dev/null >/dev/null; then
  if ! find . -name "*.ts" -o -name "*.js" | head -10 | xargs grep -l "Access-Control-Allow-Origin" 2>/dev/null >/dev/null; then
    echo "    ⚠️  Found Response creation without CORS headers" >&2
    CORS_ISSUES=$((CORS_ISSUES + 1))
  else
    echo "    ✅ Found CORS header configuration" >&2
  fi
else
  echo "    ℹ️  No Response creation found" >&2
fi

# 6. Durable Objects Pattern Analysis
echo "  🏗️  Durable Objects pattern analysis:" >&2
DO_ISSUES=0

if [[ -f "wrangler.toml" ]] && grep -q "\[durable_objects\]" wrangler.toml 2>/dev/null; then
  # Check for proper DO implementation patterns
  if find . -name "*.ts" -o -name "*.js" | head -10 | xargs grep -l "export.*class.*DurableObject" 2>/dev/null >/dev/null; then
    echo "    ✅ Found Durable Object class export" >&2
  else
    echo "    ⚠️  Durable Objects configured but no class export found" >&2
    DO_ISSUES=$((DO_ISSUES + 1))
  fi
  
  # Check for proper fetch implementation
  if find . -name "*.ts" -o -name "*.js" | head -10 | xargs grep -l "fetch.*request.*env" 2>/dev/null >/dev/null; then
    echo "    ✅ Found proper DO fetch signature" >&2
  fi
fi

# 7. KV Optimization Analysis
echo "  💾 KV optimization analysis:" >&2
KV_ISSUES=0

if [[ -f "wrangler.toml" ]] && grep -q "\[kv_namespaces\]" wrangler.toml 2>/dev/null; then
  # Check for proper KV usage patterns
  if find . -name "*.ts" -o -name "*.js" | head -10 | xargs grep -l "\.get.*\.put" 2>/dev/null >/dev/null; then
    echo "    ✅ Found KV operations" >&2
    
    # Check for caching patterns
    if find . -name "*.ts" -o -name "*.js" | head -10 | xargs grep -l "cache.*ttl" 2>/dev/null >/dev/null; then
      echo "    ✅ Found KV caching patterns" >&2
    else
      echo "    ℹ️  Consider adding TTL for KV caching" >&2
    fi
  fi
fi

# Overall Summary
echo "" >&2
TOTAL_ISSUES=$((RUNTIME_ISSUES + SECURITY_ISSUES + PERFORMANCE_ISSUES + BINDING_ISSUES + CORS_ISSUES + DO_ISSUES + KV_ISSUES))

if [ $TOTAL_ISSUES -eq 0 ]; then
  echo "  🎉 Excellent! No issues found by any SKILLs" >&2
else
  echo "  📋 Summary: $TOTAL_ISSUES total issue(s) found:" >&2
  echo "    Runtime: $RUNTIME_ISSUES | Security: $SECURITY_ISSUES | Performance: $PERFORMANCE_ISSUES" >&2
  echo "    Bindings: $BINDING_ISSUES | CORS: $CORS_ISSUES | Durable Objects: $DO_ISSUES | KV: $KV_ISSUES" >&2
  echo "" >&2
  echo "  💡 Run individual commands for detailed remediation:" >&2
  echo "    /validate:runtime - Runtime compatibility checks" >&2
  echo "    /validate:security - Security pattern validation" >&2
  echo "    /validate:performance - Performance optimization" >&2
fi

echo "" >&2
echo "  ✅ SKILL environment initialization complete" >&2

exit 0