---
description: Resolve all TODOs and GitHub issues using parallel processing with multiple agents
---

Resolve all TODO files and GitHub issues using parallel processing.

## Workflow

### 1. Analyze

Get all unresolved items from multiple sources:

**TODO Files:**
- Get all unresolved TODOs from the `/todos/*.md` directory

**GitHub Issues:**
- Fetch open GitHub issues via `gh issue list --json number,title,labels,body,url`
- Parse and extract actionable items from issues

### 2. Plan

Create a TodoWrite list of all unresolved items grouped by source (TODO files vs GitHub issues) and type.

**Dependency Analysis:**
- Look at dependencies that might occur and prioritize the ones needed by others
- For example, if you need to change a name, you must wait to do the others
- Consider cross-dependencies between file TODOs and GitHub issues

**Visualization:**
- Output a mermaid flow diagram showing the resolution flow
- Can we do everything in parallel? Do we need to do one first that leads to others in parallel?
- Put the items in the mermaid diagram flow-wise so the agent knows how to proceed in order

### 3. Implement (PARALLEL)

Spawn appropriate agents for each unresolved item in parallel, using the right agent type for each source:

**For TODO files:**
- Spawn a pr-comment-resolver agent for each unresolved TODO item

**For GitHub issues:**
- Spawn a general-purpose agent for each issue
- Pass issue number, title, and body to the agent

**Example:**
If there are 2 TODO items and 3 GitHub issues, spawn 5 agents in parallel:

1. Task pr-comment-resolver(todo1)
2. Task pr-comment-resolver(todo2)
3. Task general-purpose(issue1)
4. Task general-purpose(issue2)
5. Task general-purpose(issue3)

Always run all in parallel subagents/Tasks for each item (respecting dependencies from Step 2).

### 4. Commit & Resolve

**For TODO files:**
- Remove the TODO from the file and mark it as resolved

**For GitHub issues:**
- Close the issue via `gh issue close <number> --comment "Resolved in commit <sha>"`
- Reference the commit that resolves the issue

**Final steps:**
- Commit all changes with descriptive message
- Push to remote repository
