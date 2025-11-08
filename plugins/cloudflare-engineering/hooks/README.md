# Cloudflare Workers Stop Hooks

This directory contains stop hooks for Cloudflare Workers projects to ensure code quality and proper configuration before ending Claude Code sessions.

## Available Hooks

### 1. Script-Based Hook: `stop-cloudflare-validation.sh`

**Purpose**: Automated validation checks for Cloudflare Workers projects.

**Checks performed**:
- ✅ wrangler.toml syntax validation
- ✅ compatibility_date is 2025-09-15 or later
- ✅ Remote bindings configuration (warns if missing)
- ✅ TypeScript errors (if typecheck script exists)
- ✅ Bundle size estimation (via dry-run deployment)

**Installation**:

1. Copy the hook script to your Claude Code hooks directory:
   ```bash
   cp stop-cloudflare-validation.sh ~/.claude/hooks/
   chmod +x ~/.claude/hooks/stop-cloudflare-validation.sh
   ```

2. Update `~/.claude/settings.json` to add the hook:
   ```json
   {
     "$schema": "https://json.schemastore.org/claude-code-settings.json",
     "hooks": {
       "Stop": [
         {
           "matcher": "",
           "hooks": [
             {
               "type": "command",
               "command": "~/.claude/stop-hook-git-check.sh"
             },
             {
               "type": "command",
               "command": "~/.claude/hooks/stop-cloudflare-validation.sh"
             }
           ]
         }
       ]
     }
   }
   ```

**Usage**: Runs automatically when you end a Claude Code session in a Cloudflare Workers project (detects `wrangler.toml`).

---

### 2. Prompt-Based Stop Hook (RECOMMENDED)

**Purpose**: Encourages Claude to do thorough cleanup work, validation, and documentation before ending the session.

**Benefits**:
- ✅ Longer, more productive work sessions
- ✅ Comprehensive validation (beyond what scripts can do)
- ✅ Automatic cleanup (unused files, console.logs, etc.)
- ✅ Test coverage verification
- ✅ Documentation updates
- ✅ Summary of work completed

**Installation**:

Add this to your `~/.claude/settings.json` as a prompt-based stop hook:

```json
{
  "$schema": "https://json.schemastore.org/claude-code-settings.json",
  "hooks": {
    "Stop": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/stop-hook-git-check.sh"
          },
          {
            "type": "command",
            "command": "~/.claude/hooks/stop-cloudflare-validation.sh"
          },
          {
            "type": "prompt",
            "prompt": "Before ending this session, perform a comprehensive cleanup and validation:\n\n## 1. Code Quality Checks\n- Run TypeScript checks: `pnpm typecheck` (fix any errors)\n- Run linter: `pnpm lint` (fix any warnings)\n- Run tests: `pnpm test` (ensure all pass)\n- Check bundle size: `wrangler deploy --dry-run` (warn if > 500KB)\n\n## 2. Cloudflare-Specific Validation\n- Validate wrangler.toml: `wrangler validate`\n- Verify compatibility_date is 2025-09-15 or later\n- Confirm all bindings have `remote = true` configured\n- Check that all env.* references match wrangler.toml bindings\n- Verify no Node.js APIs used (fs, process, Buffer, etc.)\n\n## 3. Code Cleanup\n- Remove any console.log() debug statements\n- Remove commented-out code blocks\n- Remove unused imports\n- Remove any temporary files or test files\n- Ensure all files are under 500 LOC (split if needed)\n\n## 4. Documentation\n- Update package.json scripts if new commands were added\n- Verify all pnpm scripts work (not npm/yarn)\n- Update README.md if new features added\n- Add JSDoc comments to exported functions (if missing)\n\n## 5. Git Status\n- Ensure all changes are committed\n- Ensure all commits are pushed to remote\n- Verify commit messages are descriptive\n- Check for any untracked files that should be committed\n\n## 6. Session Summary\nProvide a brief summary:\n- What was accomplished in this session\n- Any issues encountered and resolved\n- Follow-up tasks needed (if any)\n- Performance metrics (if applicable): bundle size, test coverage, etc.\n\n## 7. Final Checks\n- All TODO comments addressed or documented\n- No FIXME comments left without explanation\n- All critical paths tested (if code changes were made)\n- Deployment readiness confirmed (if applicable)\n\nComplete these checks and provide a summary before ending the session. If any check fails, fix it before ending."
          }
        ]
      }
    ]
  }
}
```

**Compact version** (for easier copying):

```json
{
  "type": "prompt",
  "prompt": "Before ending this session, perform comprehensive cleanup and validation:\n\n1. Run: pnpm typecheck, pnpm lint, pnpm test (fix any errors)\n2. Validate wrangler.toml (wrangler validate)\n3. Verify compatibility_date >= 2025-09-15\n4. Check all bindings have remote = true\n5. Remove console.log, commented code, unused imports\n6. Ensure all files < 500 LOC\n7. Update package.json scripts if needed (use pnpm)\n8. Ensure all changes committed and pushed\n9. Check bundle size (wrangler deploy --dry-run)\n10. Verify no Node.js APIs (fs, process, Buffer)\n\nProvide summary: what was accomplished, any follow-up tasks, performance metrics."
}
```

---

## Hook Behavior

### When Stop Hooks Run

Stop hooks execute when:
- User manually ends a Claude Code session
- Session times out due to inactivity
- User switches to a different conversation
- Claude Code application closes

### Hook Exit Codes

- **Exit 0**: Success - Session ends normally
- **Exit 2**: Warning - Issues found, user is notified but session can still end
- **Non-zero**: Blocked - Session end is prevented until issues are resolved

### Hook Execution Order

1. **Script hooks run first** (in order defined)
2. **Prompt hooks run after scripts** (Claude processes the prompt)

### Recursion Prevention

Hooks include `stop_hook_active` check to prevent infinite loops when Claude runs commands that might trigger hooks.

---

## Best Practices

### For Script Hooks

**DO**:
- ✅ Check for project-specific files (wrangler.toml) before running
- ✅ Provide clear, actionable error messages
- ✅ Use exit code 2 for warnings (non-blocking)
- ✅ Use exit code 1 for critical errors (blocking)
- ✅ Include recursion prevention
- ✅ Make scripts fast (< 5 seconds)

**DON'T**:
- ❌ Modify files automatically
- ❌ Make network requests (slow, unreliable)
- ❌ Require user input (hooks are non-interactive)
- ❌ Run slow operations (full builds, deployments)

### For Prompt Hooks

**DO**:
- ✅ Be specific about what to check
- ✅ Provide exact commands to run
- ✅ Ask for a summary at the end
- ✅ Include project-specific validations
- ✅ Encourage cleanup and documentation
- ✅ Request performance metrics

**DON'T**:
- ❌ Make prompts too long (Claude may skip steps)
- ❌ Ask for user input (Claude can't)
- ❌ Be vague ("check everything")

---

## Customization

### Project-Specific Hooks

To create project-specific hooks, use the `matcher` field:

```json
{
  "matcher": "hirefrank-marketplace",  // Only for this project
  "hooks": [
    {
      "type": "prompt",
      "prompt": "Check specific requirements for hirefrank-marketplace..."
    }
  ]
}
```

### Cloudflare-Specific Hooks

For all Cloudflare projects, use a matcher that checks for `wrangler.toml`:

```json
{
  "matcher": "**/*",  // All projects
  "hooks": [
    {
      "type": "command",
      "command": "~/.claude/hooks/stop-cloudflare-validation.sh"
    }
  ]
}
```

The script itself checks for `wrangler.toml` and exits gracefully if not found.

---

## Troubleshooting

### Hook Not Running

1. Check `~/.claude/settings.json` syntax (must be valid JSON)
2. Verify script has execute permissions: `chmod +x ~/.claude/hooks/*.sh`
3. Check script path is absolute (not relative)
4. Look for errors in Claude Code output

### Hook Blocking Session End

1. Read the error message carefully
2. Fix the reported issues
3. Try ending session again
4. If stuck, disable hook temporarily:
   - Edit `~/.claude/settings.json`
   - Comment out the problematic hook
   - Restart Claude Code

### Hook Running Too Slowly

1. Profile script: `time ~/.claude/hooks/stop-cloudflare-validation.sh`
2. Remove slow operations (network requests, full builds)
3. Consider making checks warnings instead of errors (exit 2 instead of 1)

---

## Examples

### Minimal Hook (Just wrangler.toml validation)

```bash
#!/bin/bash
input=$(cat)
stop_hook_active=$(echo "$input" | jq -r '.stop_hook_active')
if [[ "$stop_hook_active" = "true" ]]; then exit 0; fi

if [ ! -f wrangler.toml ]; then exit 0; fi

wrangler validate &> /dev/null
exit $?
```

### Bundle Size Check Only

```bash
#!/bin/bash
input=$(cat)
stop_hook_active=$(echo "$input" | jq -r '.stop_hook_active')
if [[ "$stop_hook_active" = "true" ]]; then exit 0; fi

if [ ! -f wrangler.toml ]; then exit 0; fi

output=$(wrangler deploy --dry-run 2>&1 || true)
if echo "$output" | grep -E "Total Upload.*[1-9][0-9]{3} KiB" > /dev/null; then
  echo "⚠️ Bundle size is large (> 1MB)" >&2
  exit 2
fi

exit 0
```

---

## Resources

- [Claude Code Hooks Documentation](https://code.claude.com/docs/en/hooks)
- [Cloudflare Workers Best Practices](https://developers.cloudflare.com/workers/best-practices/)
- [wrangler CLI Reference](https://developers.cloudflare.com/workers/wrangler/)

---

## Managing Hooks

### Temporarily Disable Hooks

If the validation hooks are too aggressive during development, you can temporarily disable them:

```bash
# Disable the stop hook
mv hooks/stop-cloudflare-validation.sh hooks/stop-cloudflare-validation.sh.disabled
```

### Re-enable Hooks

To re-enable the hooks:

```bash
# Re-enable the stop hook
mv hooks/stop-cloudflare-validation.sh.disabled hooks/stop-cloudflare-validation.sh
```

### Current Status

- **Active Hook**: `stop-cloudflare-validation.sh` (currently disabled as `.disabled`)
- **Configuration**: `hooks.json` - references the script path
- **Trigger**: Runs on "Stop" events in Claude Code sessions
- **Scope**: Only runs in projects with `wrangler.toml`

---

## Version

Created: 2025-01-05
Last updated: 2025-01-07
Plugin: cloudflare-engineering
