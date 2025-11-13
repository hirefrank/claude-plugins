---
description: Commit all changes with AI-generated message and push to current branch
---

# Commit and Push Changes

<command_purpose> Automatically stage all changes, generate a comprehensive commit message based on the diff, commit with proper formatting, and push to the current branch. </command_purpose>

## Introduction

<role>Git Workflow Automation Specialist</role>

This command analyzes your changes, generates a meaningful commit message following conventional commit standards, and pushes to your current working branch.

## Prerequisites

<requirements>
- Git repository initialized
- Changes to commit (tracked or untracked files)
- Remote repository configured
- Authentication set up for push operations
</requirements>

## Commit Message Override

<commit_message_override> #$ARGUMENTS </commit_message_override>

**Usage**:
- `/es-commit` - Auto-generate commit message from changes
- `/es-commit "Custom message"` - Use provided message

## Main Tasks

### 1. Pre-Commit Validation

<thinking>
Before committing, verify the repository state and ensure we're ready to commit.
</thinking>

**Check repository status**:

```bash
# Verify we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
  echo "❌ Error: Not a git repository"
  exit 1
fi

# Get current branch
CURRENT_BRANCH=$(git branch --show-current)
echo "📍 Current branch: $CURRENT_BRANCH"

# Check if there are changes to commit
if git diff --quiet && git diff --cached --quiet && [ -z "$(git ls-files --others --exclude-standard)" ]; then
  echo "✅ No changes to commit"
  exit 0
fi

# Show status
git status --short
```

### 2. Analyze Changes

<thinking>
Analyze what changed to generate an appropriate commit message.
</thinking>

**Gather change information**:

```bash
# Count changes
ADDED=$(git ls-files --others --exclude-standard | wc -l)
MODIFIED=$(git diff --name-only | wc -l)
STAGED=$(git diff --cached --name-only | wc -l)
DELETED=$(git ls-files --deleted | wc -l)

echo ""
echo "📊 Change Summary:"
echo "  Added: $ADDED files"
echo "  Modified: $MODIFIED files"
echo "  Staged: $STAGED files"
echo "  Deleted: $DELETED files"

# Get detailed diff for commit message generation
git diff --cached --stat
git diff --stat
```

### 3. Generate Commit Message

<thinking>
If user didn't provide a message, generate one based on the changes.
Use conventional commit format with proper categorization.
</thinking>

**If no custom message provided**:

Analyze the diff and generate a commit message following this format:

```
<type>: <short description>

<detailed description>

<body with specifics>

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

**Commit type selection**:
- `feat:` - New features or capabilities
- `fix:` - Bug fixes
- `refactor:` - Code restructuring without behavior change
- `docs:` - Documentation only
- `style:` - Formatting, whitespace, etc.
- `perf:` - Performance improvements
- `test:` - Adding or updating tests
- `chore:` - Maintenance tasks, dependencies
- `ci:` - CI/CD changes

**Message generation guidelines**:

1. **Analyze file changes**:
   ```bash
   # Check which directories/files changed
   git diff --name-only HEAD
   git diff --cached --name-only
   git ls-files --others --exclude-standard
   ```

2. **Categorize the changes**:
   - New files → likely `feat:`
   - Modified existing files → check diff content
   - Deleted files → `refactor:` or `chore:`
   - Documentation files → `docs:`
   - Config files → `chore:` or `ci:`

3. **Generate specific description**:
   - List key files changed
   - Explain WHY the change was made (not just WHAT)
   - Include impact/benefits
   - Reference related commands, agents, or SKILLs if relevant

4. **Example generated message**:
   ```
   feat: Add automated commit workflow command

   Created /es-commit command to streamline git workflow by automatically
   staging changes, generating contextual commit messages, and pushing to
   the current working branch.

   Key features:
   - Auto-detects current branch (PR branches, feature branches, main)
   - Generates conventional commit messages from diff analysis
   - Supports custom commit messages via arguments
   - Validates repository state before committing
   - Automatically pushes to remote after successful commit

   Files added:
   - commands/es-commit.md (workflow automation command)

   🤖 Generated with [Claude Code](https://claude.com/claude-code)

   Co-Authored-By: Claude <noreply@anthropic.com>
   ```

### 4. Stage All Changes

<thinking>
Stage all changes including untracked files.
</thinking>

```bash
# Stage everything
git add -A

echo "✅ Staged all changes"
```

### 5. Create Commit

<thinking>
Commit with the generated or provided message.
Use heredoc for proper formatting.
</thinking>

**If custom message provided**:

```bash
git commit -m "$(cat <<'EOF'
$CUSTOM_MESSAGE

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"
```

**If auto-generated message**:

```bash
git commit -m "$(cat <<'EOF'
$GENERATED_MESSAGE
EOF
)"
```

**Verify commit succeeded**:

```bash
if [ $? -eq 0 ]; then
  echo "✅ Commit created successfully"
  git log -1 --oneline
else
  echo "❌ Commit failed"
  exit 1
fi
```

### 6. Push to Current Branch

<thinking>
Push to the current branch (whether it's main, a feature branch, or a PR branch).
Use -u flag to set upstream if not already set.
</thinking>

```bash
# Get current branch again
CURRENT_BRANCH=$(git branch --show-current)

# Check if branch has upstream
if git rev-parse --abbrev-ref @{upstream} > /dev/null 2>&1; then
  # Upstream exists, just push
  echo "📤 Pushing to origin/$CURRENT_BRANCH..."
  git push origin "$CURRENT_BRANCH"
else
  # No upstream, set it with -u
  echo "📤 Pushing to origin/$CURRENT_BRANCH (setting upstream)..."
  git push -u origin "$CURRENT_BRANCH"
fi

if [ $? -eq 0 ]; then
  echo "✅ Pushed successfully to origin/$CURRENT_BRANCH"
else
  echo "❌ Push failed"
  exit 1
fi
```

### 7. Summary Report

<deliverable>
Final report showing what was committed and pushed
</deliverable>

```markdown
## ✅ Commit Complete

**Branch**: $CURRENT_BRANCH
**Commit**: $(git log -1 --oneline)
**Remote**: origin/$CURRENT_BRANCH

### Changes Committed:
- Added: $ADDED files
- Modified: $MODIFIED files
- Deleted: $DELETED files

### Commit Message:
```
$COMMIT_MESSAGE
```

### Next Steps:
- View commit: `git log -1 -p`
- View on GitHub: `gh browse`
- Create PR: `gh pr create` (if on feature branch)
```

## Usage Examples

### Auto-generate commit message
```bash
/es-commit
```

### Custom commit message
```bash
/es-commit "fix: Resolve authentication timeout issue"
```

### With detailed custom message
```bash
/es-commit "feat: Add Polar.sh billing integration

Complete implementation of Polar.sh billing with webhooks,
subscription middleware, and D1 database schema."
```

## Safety Features

**Pre-commit checks**:
- ✅ Verifies git repository exists
- ✅ Shows status before committing
- ✅ Validates changes exist
- ✅ Confirms commit succeeded before pushing

**Branch awareness**:
- ✅ Always pushes to current branch (respects PR branches)
- ✅ Sets upstream automatically if needed
- ✅ Shows clear feedback on branch and remote

**Message quality**:
- ✅ Follows conventional commit standards
- ✅ Includes Claude Code attribution
- ✅ Provides detailed context from diff analysis

## Integration with Other Commands

**Typical workflow**:
1. `/es-work` - Work on feature
2. `/es-validate` - Validate changes
3. `/es-commit` - Commit and push ← THIS COMMAND
4. `gh pr create` - Create PR (if on feature branch)

**Or for quick iterations**:
1. Make changes
2. `/es-commit` - Auto-commit with generated message
3. Continue working

## Best Practices

**Do's** ✅:
- Run `/es-validate` before committing
- Review the generated commit message
- Use custom messages for complex changes
- Let it auto-detect your current branch
- Use on feature branches and main branch

**Don'ts** ❌:
- Don't commit secrets or credentials (command doesn't check)
- Don't use for force pushes (not supported)
- Don't amend commits (creates new commit)
- Don't bypass hooks (respects all git hooks)

## Troubleshooting

**Issue**: "Not a git repository"
**Solution**: Run `git init` or navigate to repository root

**Issue**: "No changes to commit"
**Solution**: Make changes first or check if already committed

**Issue**: "Push failed"
**Solution**: Check authentication (`gh auth status`), verify remote exists

**Issue**: "Commit message too generic"
**Solution**: Provide custom message with `/es-commit "your message"`

---

**Remember**: This command commits ALL changes (tracked and untracked). Review `git status` if you want to commit selectively.
