# Claude Skills Analyzer Plugin

Analyzes your AI conversation exports (Claude, ChatGPT) to automatically generate reusable Custom Skills based on your actual usage patterns.

## Overview

Transform your conversation history into actionable Claude Skills! This plugin performs sophisticated analysis of your AI interactions to identify recurring patterns, evaluate their automation potential, and generate complete, ready-to-use Custom Skills packages.

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

### 4. Run the Analysis

```shell
/analyze-skills
```

Choose from output options:
- **Option A**: Analysis report only
- **Option B**: Complete implementation package (recommended)
- **Option C**: Incremental implementation (top 3-5 skills)
- **Option D**: Custom specification

### 5. Troubleshoot if Needed

```shell
# Get help with common issues
/skills-troubleshoot

# Diagnoses problems like:
# - Missing conversation files
# - JSON parsing errors
# - Analysis producing no patterns
# - Plugin installation issues
```

## Features

### 🔄 Cross-Platform Intelligence
- Unified analysis of Claude and ChatGPT data
- Smart deduplication of cross-platform workflows
- Platform preference insights
- Generates platform-agnostic skills

### 📊 Pattern Analysis
- Frequency tracking across conversation history
- Temporal analysis and usage trends
- Complexity assessment for automation potential
- Quality scoring by impact and time-saving

### ⚡ Incremental Processing
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

- **Statistical significance**: Patterns must occur in >5% of conversations
- **Consistency threshold**: 70%+ similarity across instances
- **Time savings focus**: Target >30 min/week automation potential
- **Evidence-based**: Minimum 3 conversation excerpts per pattern
- **Maximum focus**: Generate 5-8 high-impact skills only

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

## Available Commands

### `/analyze-skills`
**Main analysis command** - Performs comprehensive conversation analysis and generates Custom Skills based on your usage patterns.

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

### Analysis Phases

1. **Data Processing**: Platform detection and parsing
2. **Pattern Discovery**: Categorization and clustering
3. **Frequency Analysis**: Temporal and usage patterns
4. **Cross-Platform Deduplication**: Smart duplicate handling
5. **Skill Generation**: Complete package creation

## Contributing

Issues and suggestions for this plugin:
- [Plugin Issues](https://github.com/hirefrank/claude-plugins/issues?q=label:claude-skills-analyzer)
- [Feature Requests](https://github.com/hirefrank/claude-plugins/discussions)

## Version History

- **v1.0.0**: Initial release with cross-platform analysis

## License

MIT License - see [LICENSE](../../LICENSE) for details.