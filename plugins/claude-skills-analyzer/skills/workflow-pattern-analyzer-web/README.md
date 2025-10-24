# Workflow Pattern Analyzer (Web Compatible)

**Single-file, web-compatible version** of the workflow pattern analyzer skill for use in Claude.ai web interface.

## Purpose

This is a **self-contained version** of the workflow-pattern-analyzer skill designed specifically for platforms that require single-file uploads:

- ✅ **Claude.ai web interface** (upload as zip)
- ✅ **Claude API** (single skill upload)
- ✅ **Claude Code** (works but modular version is preferred)

## Differences from Modular Version

| Feature | Modular Version | Web-Compatible Version |
|---------|----------------|------------------------|
| **File structure** | References `../../shared/analysis-methodology.md` | Complete methodology embedded |
| **Maintenance** | Shared methodology, no duplication | Self-contained, fully duplicated |
| **Platform support** | Claude Code only | All platforms |
| **File size** | Smaller (references shared files) | Larger (includes everything) |
| **Updates** | Update shared file once | Must update each skill individually |

## Usage

### In Claude.ai Web Interface

1. Download `SKILL.md` from this directory
2. Create a zip file containing just `SKILL.md`
3. Upload via Settings > Features > Custom Skills
4. Use with phrases like:
   - "Analyze my conversation patterns"
   - "What workflows should I automate?"
   - "Find skill opportunities in my recent chats"

### In Claude API

```python
# Upload the skill
with open('SKILL.md', 'r') as f:
    skill_content = f.read()

response = client.skills.create(
    name="workflow-pattern-analyzer-web",
    content=skill_content
)
```

### In Claude Code

Place `SKILL.md` in your skills directory, though the modular version is recommended for Claude Code environments.

## Full Feature Parity

This web-compatible version includes **100% of the functionality** from the modular version:

### ✅ Complete Analysis Framework
- 7-phase methodology (data collection → skill generation)
- 5-dimensional scoring system (0-50 composite scale)
- Pattern discovery across 4 detection methods
- Statistical validation with significance thresholds

### ✅ Full Output Capabilities
- Detailed analysis reports with evidence
- Prioritization matrix (frequency vs impact)
- Complete skill package generation
- Interactive follow-up options

### ✅ Quality Standards
- Pattern validation requirements
- Skill consolidation rules
- Anti-patterns guidance
- Progressive disclosure strategy

### ✅ Examples & Usage Patterns
- Quick scan (30 conversations)
- Standard analysis (50-75 conversations) 
- Deep dive (100+ conversations)
- Targeted domain searches

## Comparison with Export-Based Analysis

| Feature | Export Analysis (`/analyze-skills`) | Tool-Based Analysis (this skill) |
|---------|-------------------------------------|----------------------------------|
| **Platform** | Claude Code only | All platforms (web + CLI) |
| **Data source** | JSON export files | `recent_chats` + `conversation_search` |
| **History scope** | Complete history | Accessible recent history |
| **Cross-platform** | Claude + ChatGPT | Claude only |
| **Setup required** | Export files, directory structure | None |
| **Analysis depth** | Comprehensive (100+ conversations) | Extensive (within tool limits) |
| **Best for** | Historical analysis, large datasets | Quick insights, web users |

## When to Use This Version

**✅ Use this web-compatible version when:**
- Working in Claude.ai web interface
- Want zero-setup analysis
- Need quick pattern identification
- Prefer single-file skills
- Using Claude API with skill uploads

**🔧 Use the modular version when:**
- Working in Claude Code
- Want maintainable architecture
- Building multiple related skills
- Prefer shared methodology approach

## Technical Implementation

This version embeds the complete shared methodology directly in the SKILL.md file:

```markdown
---
name: workflow-pattern-analyzer-web
description: [Complete trigger description]
---

# Workflow Pattern Analyzer (Web Compatible)

## Instructions
[Complete 7-phase analysis framework]

### Phase 1: Data Collection Strategy
[Full methodology embedded]

### Phase 2: Pattern Discovery & Classification
[All 4 detection methods included]

### Phase 3-7: [Complete framework]
[No external references - everything included]
```

**File size**: ~15KB (vs ~3KB for modular version)
**Dependencies**: None (vs modular version's shared file dependency)
**Compatibility**: Universal (vs Claude Code only)

## Maintenance Notes

When updating methodology:
1. ✅ Update `shared/analysis-methodology.md` (affects modular version)
2. ⚠️ **Also update this file** (web-compatible version won't auto-sync)

Consider this trade-off between maintainability and compatibility when choosing which version to use.

## Installation & Testing

1. **Download**: Get `SKILL.md` from this directory
2. **Verify**: Check YAML frontmatter is valid
3. **Test**: Upload to your preferred platform
4. **Validate**: Try with "Analyze my conversation patterns"

The skill will automatically detect analysis scope and provide depth options (quick scan, standard analysis, deep dive, targeted search).

---

**Built for universal compatibility while maintaining full analytical rigor**