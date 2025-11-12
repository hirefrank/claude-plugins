#!/bin/bash
# Enhanced Pre-Operation Validation Hook
# Comprehensive SKILL validation before major operations

echo "🔍 Running enhanced pre-operation SKILL validation..." >&2

# Check if we're in a Cloudflare Workers project
if [[ ! -f "wrangler.toml" ]] && [[ ! -f "package.json" ]]; then
  echo "  ℹ️  Not a Workers project - skipping validation" >&2
  exit 0
fi

# Get operation type from environment or argument
OPERATION=${1:-"deploy"}
echo "  🎯 Validating for operation: $OPERATION" >&2

# Track critical issues that should block operations
CRITICAL_ISSUES=0
WARNINGS=0

# 1. Critical Runtime Validation
echo "  🔧 Critical runtime checks:" >&2

# Check for Node.js API usage (blocking)
if find . -name "*.ts" -o -name "*.js" | xargs grep -l "require(" 2>/dev/null >/dev/null; then
  echo "    ❌ BLOCKING: require() usage found - Workers don't support CommonJS" >&2
  CRITICAL_ISSUES=$((CRITICAL_ISSUES + 1))
fi

if find . -name "*.ts" -o -name "*.js" | xargs grep -l "from ['\"]fs['\"]" 2>/dev/null >/dev/null; then
  echo "    ❌ BLOCKING: fs module import found - not available in Workers" >&2
  CRITICAL_ISSUES=$((CRITICAL_ISSUES + 1))
fi

if find . -name "*.ts" -o -name "*.js" | xargs grep -l "from ['\"]buffer['\"]" 2>/dev/null >/dev/null; then
  echo "    ❌ BLOCKING: buffer module import found - use Uint8Array instead" >&2
  CRITICAL_ISSUES=$((CRITICAL_ISSUES + 1))
fi

# 2. Critical Security Validation
echo "  🔒 Critical security checks:" >&2

# Check for obvious hardcoded secrets (blocking)
if find . -name "*.ts" -o -name "*.js" -o -name "*.json" | xargs grep -E "(sk_live_|sk_test_).*=.*['\"][^'\"]+['\"]" 2>/dev/null >/dev/null; then
  echo "    ❌ BLOCKING: Hardcoded Stripe keys detected" >&2
  CRITICAL_ISSUES=$((CRITICAL_ISSUES + 1))
fi

if find . -name "*.ts" -o -name "*.js" -o -name "*.json" | xargs grep -E "password.*=.*['\"][^'\"]{4,}['\"]" 2>/dev/null >/dev/null; then
  echo "    ❌ BLOCKING: Hardcoded password detected" >&2
  CRITICAL_ISSUES=$((CRITICAL_ISSUES + 1))
fi

# 3. Configuration Validation
echo "  ⚙️  Configuration checks:" >&2

if [[ -f "wrangler.toml" ]]; then
  # Check for required configuration
  if ! grep -q "name.*=" wrangler.toml 2>/dev/null; then
    echo "    ❌ BLOCKING: No worker name in wrangler.toml" >&2
    CRITICAL_ISSUES=$((CRITICAL_ISSUES + 1))
  fi
  
  if ! grep -q "compatibility_date" wrangler.toml 2>/dev/null; then
    echo "    ⚠️  WARNING: No compatibility_date - may cause runtime issues" >&2
    WARNINGS=$((WARNINGS + 1))
  fi
  
  # Check for binding consistency
  if grep -q "\[kv_namespaces\]" wrangler.toml 2>/dev/null; then
    if ! find . -name "*.ts" -o -name "*.js" | xargs grep -l "env\." 2>/dev/null >/dev/null; then
      echo "    ⚠️  WARNING: KV bindings configured but no env usage found" >&2
      WARNINGS=$((WARNINGS + 1))
    fi
  fi
else
  echo "    ❌ BLOCKING: No wrangler.toml found" >&2
  CRITICAL_ISSUES=$((CRITICAL_ISSUES + 1))
fi

# 4. Performance Validation (warnings only)
echo "  ⚡ Performance checks:" >&2

if [[ -f "package.json" ]]; then
  # Check for very large dependencies
  PACKAGE_SIZE=$(grep -o '"[^"]*":[^,}]*' package.json | grep -E '"moment"|"lodash"|"axios"' | wc -l)
  if [ $PACKAGE_SIZE -gt 0 ]; then
    echo "    ⚠️  WARNING: $PACKAGE_SIZE heavy dependency(ies) detected - may affect cold starts" >&2
    WARNINGS=$((WARNINGS + 1))
  fi
fi

# 5. Operation-Specific Validation
case $OPERATION in
  "deploy")
    echo "  🚀 Deployment-specific checks:" >&2
    
    # Check for environment variables
    if [[ -f "wrangler.toml" ]] && grep -q "\[vars\]" wrangler.toml 2>/dev/null; then
      echo "    ✅ Environment variables configured" >&2
    fi
    
    # Check for production readiness
    if find . -name "*.ts" -o -name "*.js" | xargs grep -l "console\.log" 2>/dev/null >/dev/null; then
      echo "    ⚠️  WARNING: console.log statements found - remove for production" >&2
      WARNINGS=$((WARNINGS + 1))
    fi
    ;;
    
  "build")
    echo "  🔨 Build-specific checks:" >&2
    
    # Check TypeScript configuration
    if [[ -f "tsconfig.json" ]]; then
      if grep -q '"target": "ES2022"' tsconfig.json 2>/dev/null; then
        echo "    ✅ TypeScript target compatible with Workers" >&2
      else
        echo "    ⚠️  WARNING: TypeScript target may not be optimal for Workers" >&2
        WARNINGS=$((WARNINGS + 1))
      fi
    fi
    ;;
    
  "test")
    echo "  🧪 Test-specific checks:" >&2
    
    # Check for test files
    if find . -name "*.test.ts" -o -name "*.test.js" -o -name "*.spec.ts" -o -name "*.spec.js" | grep -q .; then
      echo "    ✅ Test files found" >&2
    else
      echo "    ⚠️  WARNING: No test files found" >&2
      WARNINGS=$((WARNINGS + 1))
    fi
    ;;
esac

# Final Assessment
echo "" >&2
echo "  📊 Validation Summary:" >&2
echo "    Critical Issues: $CRITICAL_ISSUES (will block operation)" >&2
echo "    Warnings: $WARNINGS (recommend addressing)" >&2

if [ $CRITICAL_ISSUES -gt 0 ]; then
  echo "" >&2
  echo "  🛑 OPERATION BLOCKED - Fix critical issues before proceeding" >&2
  echo "  💡 Run /validate for detailed remediation guidance" >&2
  exit 1
elif [ $WARNINGS -gt 0 ]; then
  echo "" >&2
  echo "  ⚠️  Operation can proceed but addressing warnings is recommended" >&2
  exit 0
else
  echo "" >&2
  echo "  ✅ All checks passed - operation ready to proceed" >&2
  exit 0
fi