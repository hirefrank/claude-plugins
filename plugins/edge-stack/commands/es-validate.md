---
description: Run Cloudflare Workers validation checks before committing code
---

# Cloudflare Validation Command

Run comprehensive validation checks for Cloudflare Workers projects:

## Validation Checks

### Continuous SKILL-based Validation (Already Active During Development)

**Cloudflare Workers SKILLs**:
- **workers-runtime-validator**: Runtime compatibility validation
- **cloudflare-security-checker**: Security pattern validation
- **workers-binding-validator**: Binding configuration validation
- **edge-performance-optimizer**: Performance optimization guidance
- **kv-optimization-advisor**: KV storage optimization
- **durable-objects-pattern-checker**: DO best practices validation
- **cors-configuration-validator**: CORS setup validation

**Frontend Design SKILLs** (if Nuxt UI components detected):
- **nuxt-ui-design-validator**: Prevents generic aesthetics (Inter fonts, purple gradients, minimal animations)
- **component-aesthetic-checker**: Validates Nuxt UI component customization depth and consistency
- **animation-interaction-validator**: Ensures engaging animations, hover states, and loading feedback

### Explicit Command Validation (Run by /validate)
1. **Documentation sync** - Validates all docs reflect current state
2. **wrangler.toml syntax** - Validates configuration file
3. **compatibility_date** - Ensures current runtime version
4. **TypeScript checks** - Runs typecheck if available
5. **Build verification** - Runs build command and checks for errors
6. **Linting** - Runs linter if available
7. **Bundle size analysis** - Checks deployment size limits
8. **Remote bindings** - Validates binding configuration

## Usage

Run this command before committing code:

```
/validate
```

## When to Use

- Before `git commit` 
- After making configuration changes
- Before deployment
- When troubleshooting issues

## Validation Rules

### Strict Requirements
- **0 errors** - All errors must be fixed before committing
- **≤5 warnings** - More than 5 warnings must be addressed before committing

### Exit Codes
- **0**: All checks passed ✅ (0 errors, ≤5 warnings)
- **1**: Validation failed ❌ (fix issues before committing)

## Build Requirements

The validation will:
- **SKILL Summary**: Report any P1/P2 issues found by active SKILLs during development
- Run `pnpm build` if build script exists (fails on any build errors)
- Run `pnpm typecheck` if typecheck script exists (fails on any TypeScript errors)
- Run `pnpm lint` if lint script exists (counts warnings toward threshold)
- Fail fast on first error to save time
- Enforce code quality: no errors, max 5 warnings

**Integration Note**: SKILLs provide continuous validation during development, catching issues early. The /validate command provides explicit validation and summarizes any SKILL findings alongside traditional build/lint checks.

This helps catch issues early and ensures code quality before committing to repository.

## Documentation Validation (Step 1)

<thinking>
Before running any code validation, verify that all documentation is up-to-date.
This prevents committing code with outdated docs.
</thinking>

### Required Documentation Files

The plugin must maintain these documentation files:
- **README.md** - Overview, features, command list, agent list, SKILL list
- **PREFERENCES.md** - Development standards, billing/auth preferences, design guidelines
- **IMPLEMENTATION-COMPLETE.md** or **IMPLEMENTATION_COMPLETE.md** - Implementation status
- **POST-MERGE-ACTIVITIES.md** - Post-deployment tasks and monitoring
- **TESTING.md** - Test specifications and strategies
- **docs/mcp-usage-examples.md** - MCP query patterns

### Documentation Validation Checks

**1. Count actual files**:

```bash
# Count commands
COMMAND_COUNT=$(find commands -name "es-*.md" | wc -l)
NON_ES_COMMANDS=$(find commands -name "*.md" ! -name "es-*.md" | wc -l)
TOTAL_COMMANDS=$((COMMAND_COUNT + NON_ES_COMMANDS))

# Count agents
AGENT_COUNT=$(find agents -name "*.md" | wc -l)

# Count SKILLs
SKILL_COUNT=$(find skills -name "SKILL.md" | wc -l)

echo "📊 Actual counts:"
echo "  Commands: $TOTAL_COMMANDS ($COMMAND_COUNT /es-* + $NON_ES_COMMANDS other)"
echo "  Agents: $AGENT_COUNT"
echo "  SKILLs: $SKILL_COUNT"
```

**2. Check README.md accuracy**:

```bash
# Extract counts from README
README_COMMANDS=$(grep -oP '\d+(?= workflow commands)' README.md || echo "NOT_FOUND")
README_AGENTS=$(grep -oP '\d+(?= specialized agents)' README.md || echo "NOT_FOUND")
README_SKILLS=$(grep -oP '\d+(?= autonomous SKILLs)' README.md || echo "NOT_FOUND")

echo ""
echo "📄 README.md claims:"
echo "  Commands: $README_COMMANDS"
echo "  Agents: $README_AGENTS"
echo "  SKILLs: $README_SKILLS"

# Compare
DOCS_VALID=true

if [ "$README_COMMANDS" != "$TOTAL_COMMANDS" ]; then
  echo "❌ ERROR: README.md lists $README_COMMANDS commands, but found $TOTAL_COMMANDS"
  DOCS_VALID=false
fi

if [ "$README_AGENTS" != "$AGENT_COUNT" ]; then
  echo "❌ ERROR: README.md lists $README_AGENTS agents, but found $AGENT_COUNT"
  DOCS_VALID=false
fi

if [ "$README_SKILLS" != "$SKILL_COUNT" ]; then
  echo "❌ ERROR: README.md lists $README_SKILLS SKILLs, but found $SKILL_COUNT"
  DOCS_VALID=false
fi

if [ "$DOCS_VALID" = false ]; then
  echo ""
  echo "❌ Documentation validation FAILED"
  echo "   Fix: Update README.md with correct counts before committing"
  exit 1
fi
```

**3. Verify all commands are documented**:

```bash
# List all commands
COMMANDS_LIST=$(find commands -name "*.md" -exec basename {} .md \; | sort)

# Check if README mentions each command
UNDOCUMENTED_COMMANDS=""
for cmd in $COMMANDS_LIST; do
  if ! grep -q "/$cmd" README.md 2>/dev/null; then
    UNDOCUMENTED_COMMANDS="$UNDOCUMENTED_COMMANDS\n  - /$cmd"
  fi
done

if [ -n "$UNDOCUMENTED_COMMANDS" ]; then
  echo "⚠️  WARNING: Commands not mentioned in README.md:$UNDOCUMENTED_COMMANDS"
  echo "   Consider adding documentation for these commands"
fi
```

**4. Check for outdated command references**:

```bash
# Check for /cf- references (should be /es- now)
CF_REFS=$(grep -r '/cf-' --include="*.md" 2>/dev/null | wc -l)

if [ "$CF_REFS" -gt 0 ]; then
  echo "❌ ERROR: Found $CF_REFS references to /cf-* commands (should be /es-*)"
  echo "   Files with /cf- references:"
  grep -r '/cf-' --include="*.md" -l 2>/dev/null
  exit 1
fi
```

**5. Verify MCP server list**:

```bash
# Count MCPs in .mcp.json
if [ -f ".mcp.json" ]; then
  MCP_COUNT=$(jq '.mcpServers | keys | length' .mcp.json 2>/dev/null || echo "0")

  # Check if README mentions correct MCP count
  if ! grep -q "$MCP_COUNT MCP" README.md 2>/dev/null && ! grep -q "${MCP_COUNT} MCP" README.md 2>/dev/null; then
    echo "⚠️  WARNING: README.md may not list all $MCP_COUNT MCP servers"
  fi
fi
```

**6. Check documentation freshness**:

```bash
# Find recently modified code files
RECENT_CODE=$(find agents commands skills -name "*.md" -mtime -1 | wc -l)

if [ "$RECENT_CODE" -gt 0 ]; then
  # Check if README was also updated
  README_MODIFIED=$(find README.md -mtime -1 | wc -l)

  if [ "$README_MODIFIED" -eq 0 ]; then
    echo "⚠️  WARNING: $RECENT_CODE code files modified recently, but README.md not updated"
    echo "   Consider updating README.md to reflect recent changes"
  fi
fi
```

### Documentation Auto-Update

If documentation validation fails, offer to auto-update:

```bash
if [ "$DOCS_VALID" = false ]; then
  echo ""
  echo "Would you like to auto-update documentation? (y/n)"
  read -r UPDATE_DOCS

  if [ "$UPDATE_DOCS" = "y" ]; then
    # Update README.md counts
    sed -i "s/\*\*[0-9]* specialized agents\*\*/\*\*$AGENT_COUNT specialized agents\*\*/g" README.md
    sed -i "s/\*\*[0-9]* autonomous SKILLs\*\*/\*\*$SKILL_COUNT autonomous SKILLs\*\*/g" README.md
    sed -i "s/\*\*[0-9]* workflow commands\*\*/\*\*$TOTAL_COMMANDS workflow commands\*\*/g" README.md

    echo "✅ README.md updated with correct counts"
    echo "   Please review changes and commit"
  fi
fi
```

### Documentation Validation Success

If all checks pass:

```bash
echo ""
echo "✅ Documentation validation PASSED"
echo "   - All counts accurate"
echo "   - No outdated command references"
echo "   - All commands documented"
```