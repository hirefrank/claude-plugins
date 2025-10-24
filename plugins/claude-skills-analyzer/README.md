# Claude Skills Analyzer Plugin

Analyzes your AI conversation exports (Claude, ChatGPT) to automatically generate reusable Custom Skills based on your actual usage patterns.

## Overview

Transform your conversation history into actionable Claude Skills! This plugin performs sophisticated analysis of your AI interactions to identify recurring patterns, evaluate their automation potential, and generate complete, ready-to-use Custom Skills packages.

**Architecture**: Uses a modular design with [shared analysis methodology](./shared/analysis-methodology.md) powering both export-based analysis and tool-based pattern detection.

## Installation

```shell
# Add the marketplace (if not already added)
/plugin marketplace add hirefrank/claude-plugins

# Install this plugin
/plugin install claude-skills-analyzer@hirefrank

# Restart Claude Code to activate
```

## Usage

### 1. Get Setup Guidance

```shell
/skills-setup
```

This command will:
- Create the necessary directory structure automatically
- Walk you through exporting from Claude and ChatGPT
- Explain privacy and security features
- Show you what to expect from analysis

### 2. Export Your Conversations

For detailed export instructions, follow the guidance provided by `/skills-setup` - it will walk you through both Claude and ChatGPT exports step-by-step.

### 3. Run the Analysis

```shell
/analyze-skills
```

Choose from output options:
- **Option A**: Analysis report only
- **Option B**: Complete implementation package (recommended)
- **Option C**: Incremental implementation (top 3-5 skills)
- **Option D**: Custom specification

The analysis will automatically create the `reports/` and `generated-skills/` directories as needed.

### 4. Troubleshoot if Needed

```shell
/skills-troubleshoot
```

Get help diagnosing issues like:
- Missing conversation files
- JSON parsing errors
- Analysis producing no patterns
- Plugin installation problems



## Components

### 📦 Commands (Claude Code)
- **`/analyze-skills`**: Export-based comprehensive analysis
- **`/skills-setup`**: Setup guidance and directory creation
- **`/skills-troubleshoot`**: Problem diagnosis and fixes

### 🎯 Skills (Web + Claude Code)
- **`workflow-pattern-analyzer`**: Tool-based analysis (Claude Code only - modular)
- **`workflow-pattern-analyzer-web`**: Tool-based analysis (Web + Claude Code - self-contained)
- **`conversation-analyzer`**: Base analysis capability

### 🧩 Shared Methodology
All components use the [shared analysis methodology](./shared/analysis-methodology.md):
- 5-dimensional scoring framework (0-50 composite scale)
- Pattern discovery and classification
- Relationship mapping and consolidation
- Prioritization matrix generation
- Quality standards and validation

## Features

### 🔄 Cross-Platform Intelligence
- Unified analysis of Claude and ChatGPT data
- Smart deduplication of cross-platform workflows
- Platform preference insights
- Generates platform-agnostic skills

### 📊 Statistical Rigor
- 5-dimensional skill-worthiness scoring (frequency, consistency, complexity, time savings, error reduction)
- Pattern validation with significance thresholds
- Evidence-based recommendations with conversation excerpts
- Temporal analysis and usage trends

### ⚡ Incremental Processing (Export Analysis)
- Skip previously analyzed conversations
- Process only new or modified data
- Maintain analysis logs for efficiency
- Build on previous analysis results

## Generated Output

All output is automatically organized in your project directory:

### Analysis Reports
Located in `reports/{timestamp}/`:
- **comprehensive-skills-analysis.md** - Complete pattern analysis with evidence
- **implementation-guide.md** - Actionable deployment roadmap  
- **skills-analysis-log.json** - Machine-readable data for incremental processing

### Skill Packages
Located in `generated-skills/skill-name/`:
```
skill-name/
├── SKILL.md           # Main skill with YAML frontmatter
├── reference.md       # Detailed methodology and frameworks
├── examples.md        # Real-world usage examples
└── templates/         # Reusable output templates
```

**Note**: These directories are automatically created when needed.

## Quality Standards

All components follow the [shared quality standards](./shared/analysis-methodology.md#quality-standards):

- **Statistical significance**: Patterns must occur in >5% of conversations OR >3 instances
- **Consistency threshold**: 70%+ similarity across instances
- **Time savings focus**: Target >30 min/week cumulative automation potential
- **Evidence-based**: Minimum 2-3 conversation excerpts per pattern
- **Maximum focus**: Generate 8-12 high-impact skills (recommend top 5-8 for initial implementation)
- **No generic patterns**: Avoid broad categories like "writing" or "analysis"

## Example Use Cases

### Business Communication
Identifies email drafting, proposal writing, and client communication patterns.

### Code Review Workflows
Recognizes systematic code analysis and documentation patterns.

### Content Creation
Discovers newsletter writing, blog structures, and social media workflows.

### Research & Analysis
Finds research methodologies and report generation patterns.

## Data Privacy

- **Local processing**: All analysis on your machine
- **No data upload**: Exports never leave your system
- **Anonymized output**: Generated skills remove sensitive info
- **Gitignored exports**: Auto-excluded from version control

## Analysis Approaches

### Export-Based Analysis (Claude Code only)
**Command**: `/analyze-skills`

**Best for:**
- Complete conversation history analysis (100+ conversations)
- Cross-platform analysis (Claude + ChatGPT)
- Incremental processing of large datasets
- Historical trend analysis

**Requirements:**
- Conversation export JSON files
- Claude Code environment

### Tool-Based Analysis (Web + Claude Code)
**Skills**: `workflow-pattern-analyzer` (modular) | `workflow-pattern-analyzer-web` (self-contained)

**Best for:**
- Quick pattern detection without exports
- Web interface users
- Recent conversation analysis
- Iterative skill discovery

**Requirements:**
- No exports needed
- Uses `recent_chats` and `conversation_search` tools

**Choose your version:**
- **Web Compatible**: [workflow-pattern-analyzer-web](./skills/workflow-pattern-analyzer-web/) - Single file for claude.ai upload
- **Modular**: [workflow-pattern-analyzer](./skills/workflow-pattern-analyzer/) - References shared methodology (Claude Code only)

## Available Commands

### `/analyze-skills`
**Export-based analysis** - Performs comprehensive conversation analysis from JSON exports and generates Custom Skills based on your complete usage patterns.

### `/skills-setup`
**Setup guidance** - Complete walkthrough for:
- Directory structure creation
- Conversation export instructions (Claude & ChatGPT)
- Privacy and security information
- Expected results and pro tips

### `/skills-troubleshoot`
**Problem diagnosis** - Helps resolve common issues like:
- Missing or invalid conversation files
- JSON parsing errors
- Analysis producing no patterns
- Plugin installation problems
- Permission and directory issues

## Quick Troubleshooting

For immediate help with setup or issues:
```shell
/skills-setup      # Complete setup guide
/skills-troubleshoot  # Diagnose and fix problems
```

For detailed troubleshooting, the `/skills-troubleshoot` command provides comprehensive diagnostics and solutions.

## Technical Details

### Supported Export Formats

**Claude Export Structure:**
- `conversations.json` - Message history with metadata
- `projects.json` - Project workflows and documentation
- `users.json` - Account information for context

**ChatGPT Export Structure:**
- `conversations.json` - Conversation history with mapping
- `user.json` - User profile information
- `shared_conversations.json` - Shared conversation metadata
- `message_feedback.json` - Response feedback (optional)

### Analysis Methodology

All analysis components use the [shared methodology](./shared/analysis-methodology.md):

**Core Phases:**
1. **Pattern Discovery**: Explicit, implicit, domain, and temporal pattern detection
2. **Frequency Analysis**: Statistical validation with significance thresholds
3. **Skill-Worthiness Scoring**: 5-dimensional evaluation (0-50 composite scale)
4. **Relationship Mapping**: Overlap detection and consolidation strategies
5. **Prioritization**: Frequency vs impact matrix generation
6. **Skill Generation**: Complete package creation with progressive disclosure

**Export-Specific Enhancements:**
- Phase 0: Incremental processing with analysis logs
- Phase 5: Cross-platform deduplication (ChatGPT + Claude)

## Contributing

Issues and suggestions for this plugin:
- [Plugin Issues](https://github.com/hirefrank/claude-plugins/issues?q=label:claude-skills-analyzer)
- [Feature Requests](https://github.com/hirefrank/claude-plugins/discussions)

## Architecture

The plugin uses a modular architecture:

```
claude-skills-analyzer/
├── commands/               # Claude Code commands
│   ├── analyze-skills.md   # Export-based analysis
│   ├── skills-setup.md     # Setup guidance
│   └── skills-troubleshoot.md
├── skills/                 # Standalone skills
│   ├── conversation-analyzer/
│   ├── workflow-pattern-analyzer/      # Modular (Claude Code)
│   └── workflow-pattern-analyzer-web/  # Self-contained (Web + Claude Code)
├── shared/                 # Shared components
│   └── analysis-methodology.md     # Core analysis framework
└── README.md
```

**Benefits:**
- Modular components share methodology (no duplication in Claude Code)
- Web-compatible version for universal platform support
- Consistent analysis quality across all tools
- Easy to maintain and extend
- Choose architecture based on your deployment needs

## Version History

- **v1.2.0**: Added web-compatible workflow-pattern-analyzer-web skill for universal platform support
- **v1.1.0**: Added modular architecture with shared methodology and workflow-pattern-analyzer skill
- **v1.0.0**: Initial release with cross-platform analysis

## License

MIT License - see [LICENSE](../../LICENSE) for details.